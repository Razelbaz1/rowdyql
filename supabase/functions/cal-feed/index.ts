// cal-feed: the calendar link that updates itself. GET /functions/v1/cal-feed/<token>.ics returns the student's sessions as text/calendar.
// The site computes the sessions (calSched) and writes them to the progress key 'dbs_cal_out' once the calendar is confirmed; this only
// formats them, like the site's calIcs. Times are in UTC, so no time zone block is needed. Deploy with verify_jwt off: calendar apps
// send no token of ours, and the secret in the address is the key. It reads through cal_feed() with the site's public key.
const BASE = (globalThis as any).Deno?.env.get('SUPABASE_URL') || 'https://afzlmlbigruxijudqukp.supabase.co';
const KEY = 'sb_publishable_VqElbkoG6ZWGI4VtWEZ7Tw_Quqxv1fR';

/* lines longer than 75 bytes continue on the next line, after a space (RFC 5545) */
export function fold(line: string) {
  const enc = new TextEncoder(); if (enc.encode(line).length <= 75) return line; let out = '', cur = '', nb = 0;
  for (const ch of line) { const b = enc.encode(ch).length; if (nb + b > (out ? 74 : 75)) { out += (out ? '\r\n ' : '') + cur; cur = ''; nb = 0; } cur += ch; nb += b; }
  return out + '\r\n ' + cur;
}
/* any line break (also a lone \r) becomes \n, and other control characters go, so a title can never start a line of its own */
const tx = (s: unknown) => String(s).slice(0, 300).replace(/\\/g, '\\\\').replace(/;/g, '\\;').replace(/,/g, '\\,').replace(/\r\n|\r|\n/g, '\\n').replace(/[\u0000-\u001f\u007f]/g, '');
const dt = (iso: string) => new Date(iso).toISOString().replace(/[-:]/g, '').replace(/\.\d+Z$/, 'Z');

/* feed = { v, lang, d: description with {url}, s: [{ k: key, a: start, b: end, t: title, u: lesson address }] } */
export function ics(feed: any, now = new Date()) {
  const stamp = dt(now.toISOString()), lang = /^(he|en)$/.test(feed && feed.lang) ? feed.lang : 'he';
  const L = ['BEGIN:VCALENDAR', 'VERSION:2.0', 'PRODID:-//RowdyQL//Study calendar//' + lang.toUpperCase(), 'CALSCALE:GREGORIAN', 'METHOD:PUBLISH',
    'X-WR-CALNAME:RowdyQL', 'X-WR-TIMEZONE:Asia/Jerusalem', 'REFRESH-INTERVAL;VALUE=DURATION:PT1H', 'X-PUBLISHED-TTL:PT1H'];
  for (const e of Array.isArray(feed && feed.s) ? feed.s : []) {
    if (!e || !e.k || isNaN(Date.parse(e.a)) || isNaN(Date.parse(e.b))) continue;
    const title = 'RowdyQL · ' + e.t, url = /^https:\/\/rowdyql\.com\/[^\s]*$/.test(e.u) ? e.u : 'https://rowdyql.com/';
    L.push('BEGIN:VEVENT', 'UID:' + String(e.k).replace(/[^0-9A-Za-z]/g, '') + '-f@rowdyql.com', 'DTSTAMP:' + stamp, 'DTSTART:' + dt(e.a), 'DTEND:' + dt(e.b),
      'SUMMARY:' + tx(title), 'DESCRIPTION:' + tx(String(feed.d || '{url}').replace('{url}', url)), 'URL:' + url,
      'BEGIN:VALARM', 'ACTION:DISPLAY', 'DESCRIPTION:' + tx(title), 'TRIGGER:-PT30M', 'END:VALARM', 'END:VEVENT');
  }
  L.push('END:VCALENDAR'); return L.map(fold).join('\r\n') + '\r\n';
}

export async function handle(req: Request, get = fetch) {
  if (req.method !== 'GET' && req.method !== 'HEAD') return new Response('', { status: 405, headers: { allow: 'GET, HEAD' } });
  const u = new URL(req.url), tok = (u.pathname.split('/').pop() || '').replace(/\.ics$/i, '') || u.searchParams.get('t') || '';
  if (!/^[0-9a-f]{64}$/.test(tok)) return new Response('Not found\n', { status: 404 });
  const r = await get(BASE + '/rest/v1/rpc/cal_feed', { method: 'POST', headers: { apikey: KEY, 'content-type': 'application/json' }, body: JSON.stringify({ p_token: tok }) });
  if (!r.ok) return new Response('Try again later\n', { status: 503, headers: { 'retry-after': '600' } });
  const feed = await r.json(); if (!feed) return new Response('Not found\n', { status: 404 });
  return new Response(req.method === 'HEAD' ? null : ics(feed), { headers: { 'content-type': 'text/calendar; charset=utf-8', 'content-disposition': 'inline; filename="rowdyql.ics"', 'cache-control': 'private, max-age=300' } });
}

if ((globalThis as any).Deno) (globalThis as any).Deno.serve((req: Request) => handle(req));
