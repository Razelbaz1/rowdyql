// mail-in: the hello@rowdyql.com inbox (2026-10-20). The Cloudflare Worker rowdyql-mail-in posts every message here, raw
// (message/rfc822), or only its headers (JSON, big: true) when it is over 1.5 MB. This parses it with postal-mime and hands one
// row to public.mail_add, which files it as a request ('new', for the inbox routine to sort) or adds it to the request it answers.
// Attachments are never stored: their names go into the text, and the files stay in the copy in Raz's Gmail.
// Deploy with verify_jwt off: the Worker sends no token of ours. It passes the Worker's x-mail header on, and mail_add checks it.
const ENV = (k: string) => (globalThis as any).Deno?.env.get(k) || '';
const BASE = ENV('SUPABASE_URL') || 'https://afzlmlbigruxijudqukp.supabase.co';
const KEY = 'sb_publishable_VqElbkoG6ZWGI4VtWEZ7Tw_Quqxv1fR';
const MAXTEXT = 10000;

/* the message ids in a header ("<a@x> <b@y>"), with their brackets, as mail headers carry them */
export const ids = (v: unknown) => String(v || '').match(/<[^<>\s]{1,400}>/g) || [];

/* an HTML-only message as plain text: line breaks kept, tags and entities gone */
export function htmlText(html: string) {
  return String(html || '').replace(/<(script|style|head)[\s\S]*?<\/\1>/gi, '').replace(/<br\s*\/?>/gi, '\n').replace(/<\/(p|div|li|tr|h\d)>/gi, '\n')
    .replace(/<[^>]+>/g, '').replace(/&nbsp;/g, ' ').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, "'").replace(/&amp;/g, '&');
}

/* the student's own words: the quoted earlier mail cut (Gmail, Outlook and Apple, in Hebrew and English), signatures kept */
export function clean(text: string) {
  const t = String(text || '').replace(/\r\n?/g, '\n').replace(/[‎‏‪-‮]/g, '');
  const cuts = [/^On .{1,300}wrote:\s*$/m, /^בתאריך .{1,300}:\s*$/m, /^-{2,}\s*(Original Message|הודעה מקורית)\s*-{2,}\s*$/im, /^(From|מאת):\s.+\n(Sent|Date|נשלח|תאריך):\s/m];
  let end = t.length;
  for (const re of cuts) { const m = re.exec(t); if (m && m.index < end) end = m.index; }
  const own = t.slice(0, end).split('\n').filter(l => !/^\s*>/.test(l)).join('\n').replace(/\n{3,}/g, '\n\n').trim();
  return (own || t.trim()).slice(0, MAXTEXT);
}

/* one parsed message (postal-mime's shape) as the row mail_add takes */
export function toRow(m: any) {
  const files = (m.attachments || []).filter((a: any) => a && a.disposition !== 'inline' && a.filename).map((a: any) => String(a.filename).slice(0, 120));
  let body = clean(m.text || htmlText(m.html || ''));
  if (files.length) body += '\n\n[קבצים מצורפים, לא נשמרו כאן: ' + files.slice(0, 10).join(', ') + ']';
  return {
    message_id: ids(m.messageId)[0] || '',
    refs: [...new Set([...ids(m.inReplyTo), ...ids(m.references)])].slice(-50),
    from_email: String((m.from && m.from.address) || '').trim().toLowerCase().slice(0, 320),
    from_name: String((m.from && m.from.name) || '').trim().slice(0, 200),
    subject: String(m.subject || '').trim().slice(0, 500),
    body,
  };
}

/* a message over the size cap: only its headers came, so the row says where the full text is */
export function bigRow(j: any) {
  const from = String(j.from || ''), addr = (from.match(/<([^<>\s]+@[^<>\s]+)>/) || from.match(/([^\s<>"]+@[^\s<>"]+)/) || [])[1] || '';
  const name = from.replace(/<[^>]*>/, '').replace(/"/g, '').trim();
  return {
    message_id: ids(j.message_id)[0] || '', refs: [...new Set([...ids(j.in_reply_to), ...ids(j.references)])].slice(-50),
    from_email: addr.toLowerCase().slice(0, 320), from_name: name === addr ? '' : name.slice(0, 200), subject: String(j.subject || '').slice(0, 500),
    body: '[המייל גדול מדי לקריאה כאן (' + (Math.round((+j.size || 0) / 100000) / 10) + ' MB, כנראה בגלל קבצים). המייל המלא נמצא בעותק ב-Gmail.]',
  };
}

async function rpc(key: string, row: any) {
  const r = await fetch(BASE + '/rest/v1/rpc/mail_add', { method: 'POST', headers: { apikey: KEY, 'content-type': 'application/json', 'x-mail': key }, body: JSON.stringify({ p: row }) });
  return new Response(await r.text(), { status: r.status, headers: { 'content-type': 'application/json' } });
}

export async function handle(req: Request, parse: (b: ArrayBuffer) => Promise<any>, send = rpc) {
  if (req.method !== 'POST') return new Response('no', { status: 405 });
  const key = req.headers.get('x-mail') || '';
  if (key.length < 32) return new Response('no', { status: 401 });
  let row;
  try {
    if (/json/i.test(req.headers.get('content-type') || '')) row = bigRow(await req.json());
    else row = toRow(await parse(await req.arrayBuffer()));
  } catch (e) { return new Response('unreadable: ' + String(e && (e as any).message || e).slice(0, 200), { status: 400 }); }
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(row.from_email)) return new Response('no sender', { status: 400 });
  return send(key, row);
}

if ((globalThis as any).Deno) {
  const PostalMime = (await import('npm:postal-mime@2.4.4')).default;
  (globalThis as any).Deno.serve((req: Request) => handle(req, b => PostalMime.parse(b)).catch(e => new Response(String(e && e.message || e), { status: 500 })));
}
