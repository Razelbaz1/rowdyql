// push-tick: pg_cron calls it every 15 minutes. It sends the study reminders: one 30 minutes before a session, and one 15 minutes after it
// (active on the site that day: "nice, the next one is..."; not active: "didn't get to it? tomorrow works too"). The sessions and the
// texts, in the student's language, are the list the site writes (dbs_cal_out, only once the calendar is confirmed); this only decides
// what is due. Web Push is done by hand on WebCrypto (RFC 8291 aes128gcm, RFC 8292 VAPID), so it runs the same in Deno and in the Node
// tests. Deploy with verify_jwt off: the cron call carries the shared secret in x-tick, and every database call checks it again.
const ENV = (k: string) => (globalThis as any).Deno?.env.get(k) || '';
const BASE = ENV('SUPABASE_URL') || 'https://afzlmlbigruxijudqukp.supabase.co';
const KEY = 'sb_publishable_VqElbkoG6ZWGI4VtWEZ7Tw_Quqxv1fR';
const SITE = 'https://rowdyql.com/';
const MIN = 60000;

/* ---- base64url and bytes ---- */
export const b64u = {
  enc(u8: Uint8Array) { let s = ''; for (const b of u8) s += String.fromCharCode(b); return btoa(s).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, ''); },
  dec(s: string) { const b = atob(s.replace(/-/g, '+').replace(/_/g, '/') + '==='.slice((s.length + 3) % 4)); return Uint8Array.from(b, c => c.charCodeAt(0)); },
};
const cat = (...a: Uint8Array[]) => { const o = new Uint8Array(a.reduce((n, x) => n + x.length, 0)); let i = 0; for (const x of a) { o.set(x, i); i += x.length; } return o; };
const utf8 = (s: string) => new TextEncoder().encode(s);
async function hkdf(salt: Uint8Array, ikm: Uint8Array, info: Uint8Array, len: number) {
  const k = await crypto.subtle.importKey('raw', ikm, 'HKDF', false, ['deriveBits']);
  return new Uint8Array(await crypto.subtle.deriveBits({ name: 'HKDF', hash: 'SHA-256', salt, info }, k, len * 8));
}

/* ---- RFC 8291: the payload, encrypted for one subscription (one record, aes128gcm) ---- */
export async function encrypt(payload: Uint8Array, p256dh: string, auth: string, salt = crypto.getRandomValues(new Uint8Array(16))) {
  const uaPub = b64u.dec(p256dh), secret = b64u.dec(auth);
  const as = await crypto.subtle.generateKey({ name: 'ECDH', namedCurve: 'P-256' }, true, ['deriveBits']) as CryptoKeyPair;
  const asPub = new Uint8Array(await crypto.subtle.exportKey('raw', as.publicKey));
  const ua = await crypto.subtle.importKey('raw', uaPub, { name: 'ECDH', namedCurve: 'P-256' }, false, []);
  const shared = new Uint8Array(await crypto.subtle.deriveBits({ name: 'ECDH', public: ua } as any, as.privateKey, 256));
  const ikm = await hkdf(secret, shared, cat(utf8('WebPush: info\0'), uaPub, asPub), 32);
  const cek = await hkdf(salt, ikm, utf8('Content-Encoding: aes128gcm\0'), 16), nonce = await hkdf(salt, ikm, utf8('Content-Encoding: nonce\0'), 12);
  const key = await crypto.subtle.importKey('raw', cek, 'AES-GCM', false, ['encrypt']);
  const ct = new Uint8Array(await crypto.subtle.encrypt({ name: 'AES-GCM', iv: nonce }, key, cat(payload, new Uint8Array([2]))));
  const rs = new Uint8Array([0, 0, 16, 0]); /* record size 4096 */
  return cat(salt, rs, new Uint8Array([asPub.length]), asPub, ct);
}

/* ---- RFC 8292: the VAPID token for one push service (ES256, signed with our private key) ---- */
export async function vapidJwt(aud: string, subject: string, pub: string, priv: string, now = Date.now()) {
  const p = b64u.dec(pub), jwk = { kty: 'EC', crv: 'P-256', d: priv, x: b64u.enc(p.slice(1, 33)), y: b64u.enc(p.slice(33, 65)), ext: true };
  const k = await crypto.subtle.importKey('jwk', jwk, { name: 'ECDSA', namedCurve: 'P-256' }, false, ['sign']);
  const head = b64u.enc(utf8(JSON.stringify({ typ: 'JWT', alg: 'ES256' }))), body = b64u.enc(utf8(JSON.stringify({ aud, exp: Math.floor(now / 1000) + 12 * 3600, sub: subject })));
  const sig = new Uint8Array(await crypto.subtle.sign({ name: 'ECDSA', hash: 'SHA-256' }, k, utf8(head + '.' + body)));
  return head + '.' + body + '.' + b64u.enc(sig);
}

export async function send(sub: { e: string; p: string; a: string }, msg: object, vapid: { pub: string; priv: string; subject: string }, get = fetch) {
  const body = await encrypt(utf8(JSON.stringify(msg)), sub.p, sub.a), jwt = await vapidJwt(new URL(sub.e).origin, vapid.subject, vapid.pub, vapid.priv);
  const r = await get(sub.e, { method: 'POST', headers: { TTL: '1800', Urgency: 'high', 'Content-Encoding': 'aes128gcm', 'Content-Type': 'application/octet-stream', Authorization: 'vapid t=' + jwt + ', k=' + vapid.pub }, body });
  return r.status;
}

/* ---- what is due now. rows: [{ u, subs: [{ e, p, a }], cal: dbs_cal_out, days: dbs_days }]. The list's x holds the texts:
   pre_t / pre_b before a session; done_t / done_b (done_today when the next one is the same day, done_end when nothing is left) after
   one on a day the student was active;
   miss_t / miss_b after one on a day they weren't. Each session has k, a, b, t (title), u (address), w (weekday) and h (time). ---- */
const fill = (s: string, v: Record<string, string>) => String(s || '').replace(/\{(\w+)\}/g, (m, k) => k in v ? v[k] : m);
const ymd = (ms: number, tz: string) => new Intl.DateTimeFormat('en-CA', { timeZone: tz, year: 'numeric', month: '2-digit', day: '2-digit' }).format(new Date(ms));
export function due(rows: any[], now = Date.now()) {
  const out: any[] = [];
  for (const r of rows || []) {
    const cal = r && r.cal, x = cal && cal.x; if (!x || !Array.isArray(cal.s) || !r.subs || !r.subs.length) continue;
    const S = cal.s.filter((e: any) => e && e.k && !isNaN(Date.parse(e.a)) && !isNaN(Date.parse(e.b))).sort((p: any, q: any) => Date.parse(p.a) - Date.parse(q.a));
    const days = new Set(Array.isArray(r.days) ? r.days : []), url = (u: string) => /^https:\/\/rowdyql\.com\//.test(u) ? u : SITE;
    for (const e of S) {
      const a = Date.parse(e.a), b = Date.parse(e.b);
      if (a - now > 20 * MIN && a - now <= 35 * MIN) out.push({ u: r.u, k: e.k, kind: 'pre', subs: r.subs, msg: { title: fill(x.pre_t, { t: e.t }), body: fill(x.pre_b, { time: e.h }), url: url(e.u), tag: 'pre-' + e.k, lang: cal.lang } });
      if (now - b >= 14 * MIN && now - b < 29 * MIN) {
        const active = days.has(ymd(a, 'Asia/Jerusalem')) || days.has(ymd(a, 'UTC')), nx = S.find((f: any) => Date.parse(f.a) >= b);
        const today = nx && ymd(Date.parse(nx.a), 'Asia/Jerusalem') === ymd(a, 'Asia/Jerusalem') && x.done_today; /* a second session the same day: "today", not the weekday */
        const msg = active ? { title: fill(x.done_t, {}), body: nx ? fill(today ? x.done_today : x.done_b, { day: nx.w, time: nx.h }) : fill(x.done_end, {}) } : { title: fill(x.miss_t, {}), body: fill(x.miss_b, {}) };
        out.push({ u: r.u, k: e.k, kind: active ? 'done' : 'miss', subs: r.subs, msg: Object.assign(msg, { url: SITE + '#/', tag: 'post-' + e.k, lang: cal.lang }) });
      }
    }
  }
  return out;
}

/* ---- the run: read, claim (so nothing goes twice), send, and drop subscriptions the push service says are gone ---- */
async function rpc(fn: string, args: object, get = fetch) {
  const r = await get(BASE + '/rest/v1/rpc/' + fn, { method: 'POST', headers: { apikey: KEY, 'content-type': 'application/json' }, body: JSON.stringify(args) });
  if (!r.ok) throw new Error(fn + ' ' + r.status + ' ' + await r.text()); return r.json();
}
export async function tick(secret: string, vapid: { pub: string; priv: string; subject: string }, now = Date.now(), get = fetch) {
  const rows = await rpc('push_data', { p_secret: secret }, get), todo = due(rows, now); if (!todo.length) return { due: 0, sent: 0, gone: 0 };
  const won = await rpc('push_claim', { p_secret: secret, p_items: todo.map(d => ({ u: d.u, k: d.k, kind: d.kind === 'pre' ? 'pre' : 'post' })) }, get);
  const ok = new Set((won || []).map((w: any) => w.u + '|' + w.k + '|' + w.kind)), gone: string[] = []; let sent = 0;
  for (const d of todo) { if (!ok.has(d.u + '|' + d.k + '|' + (d.kind === 'pre' ? 'pre' : 'post'))) continue;
    for (const s of d.subs) { try { const st = await send(s, d.msg, vapid, get); if (st === 404 || st === 410) gone.push(s.e); else if (st < 300) sent++; } catch (_) { /* one bad push never stops the rest */ } } }
  if (gone.length) await rpc('push_gone', { p_secret: secret, p_endpoints: gone }, get);
  return { due: todo.length, sent, gone: gone.length };
}

export async function handle(req: Request) {
  const secret = ENV('PUSH_TICK'); if (!secret || req.headers.get('x-tick') !== secret) return new Response('Not found\n', { status: 404 });
  const res = await tick(secret, { pub: ENV('VAPID_PUBLIC'), priv: ENV('VAPID_PRIVATE'), subject: ENV('VAPID_SUBJECT') || 'mailto:hello@rowdyql.com' });
  return new Response(JSON.stringify(res), { headers: { 'content-type': 'application/json' } });
}

if ((globalThis as any).Deno) (globalThis as any).Deno.serve((req: Request) => handle(req).catch(e => new Response(String(e && e.message || e), { status: 500 })));
