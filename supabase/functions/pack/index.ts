// pack: hands a chapter's content pack to a page that holds a valid ticket (2026-10-21). The page asks pack_tickets for an address
// per chapter its account may open, then loads that address as a <script> with the integrity hash it was built with. This only
// checks the shape of the ticket and trades it for the pack (pack_body, which checks the HMAC and the expiry inside the database,
// so the key never leaves it). Deploy with verify_jwt off: a <script src> can't carry a token, the ticket is the permission.
const ENV = (k: string) => (globalThis as any).Deno?.env.get(k) || '';
const BASE = ENV('SUPABASE_URL') || 'https://afzlmlbigruxijudqukp.supabase.co';
const KEY = 'sb_publishable_VqElbkoG6ZWGI4VtWEZ7Tw_Quqxv1fR';
/* the site, and its preview builds on Cloudflare Pages: the browser checks the pack's hash only across an allowed origin */
const ORIGIN = /^https:\/\/(rowdyql\.com|([a-z0-9-]+\.)?rowdyql\.pages\.dev)$/;

export function ticket(u: URL) {
  const c = u.searchParams.get('c') || '', s = u.searchParams.get('s') || '', id = u.searchParams.get('u') || '', x = u.searchParams.get('x') || '', t = u.searchParams.get('t') || '';
  if (!/^[a-z0-9_]{1,30}$/.test(c) || !/^sha384-[A-Za-z0-9+/]{64}$/.test(s) || !/^[0-9a-f-]{36}$/.test(id) || !/^\d{9,11}$/.test(x) || !/^[0-9a-f]{64}$/.test(t)) return null;
  return { p_chapter: c, p_sri: s, p_user: id, p_exp: +x, p_sig: t };
}

async function body(args: any): Promise<string | null> {
  const r = await fetch(BASE + '/rest/v1/rpc/pack_body', { method: 'POST', headers: { apikey: KEY, 'content-type': 'application/json' }, body: JSON.stringify(args) });
  if (!r.ok) return null; const v = await r.json(); return typeof v === 'string' ? v : null;
}

export async function handle(req: Request, get = body) {
  const o = req.headers.get('origin') || '', cors: Record<string, string> = ORIGIN.test(o) ? { 'access-control-allow-origin': o, vary: 'origin' } : { vary: 'origin' };
  if (req.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'access-control-allow-methods': 'GET' } });
  if (req.method !== 'GET') return new Response('no', { status: 405, headers: cors });
  const args = ticket(new URL(req.url));
  const js = args ? await get(args) : null;
  if (!js) return new Response('/* no */', { status: 403, headers: { ...cors, 'content-type': 'application/javascript; charset=utf-8', 'cache-control': 'no-store' } });
  return new Response(js, { status: 200, headers: { ...cors, 'content-type': 'application/javascript; charset=utf-8', 'cache-control': 'private, max-age=600',
    'x-content-type-options': 'nosniff', 'cross-origin-resource-policy': 'cross-origin' } });
}

if ((globalThis as any).Deno) (globalThis as any).Deno.serve((req: Request) => handle(req).catch(e => new Response(String(e && e.message || e), { status: 500 })));
