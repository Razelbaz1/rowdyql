-- Paid content from the server (2026-10-21). The public page holds no lessons: each chapter's text, exercises, solutions and
-- quizzes is a pack (build.py → dist-packs/<chapter>.js). The build uploads each pack here (pack_put, with the deploy key), and a
-- signed-in account gets a short-lived address for every chapter it may open (pack_tickets). The browser loads that address as a
-- script through the Edge Function `pack`, which hands back the pack only for a valid ticket (pack_body), and checks it against the
-- hash the page was built with. The ticket key never leaves the database. Run once in the SQL editor; safe to run again.

-- 1. Who may open which chapter. A row per account and chapter; revoking keeps the row (revoked_at), so Raz sees the history.
create table if not exists public.entitlements (
  user_id    uuid not null references auth.users (id) on delete cascade,
  chapter    text not null check (chapter ~ '^[a-z0-9_]{1,30}$'),
  source     text not null check (source in ('coupon', 'purchase', 'staff', 'grant')),
  ref        text not null default '' check (length(ref) <= 200),   -- the coupon code or the order
  granted_at timestamptz not null default now(),
  revoked_at timestamptz,
  primary key (user_id, chapter)
);
alter table public.entitlements enable row level security;
drop policy if exists entitlements_own on public.entitlements;
create policy entitlements_own on public.entitlements for select using (user_id = auth.uid());
drop policy if exists entitlements_staff on public.entitlements;
create policy entitlements_staff on public.entitlements for all using (public.is_teacher()) with check (public.is_teacher());
revoke all on public.entitlements from anon;

-- the caller may open the chapter: an entitlement that wasn't revoked, on an account that isn't blocked
create or replace function public.has_access(p_chapter text) returns boolean language sql stable security definer set search_path = '' as $$
  select public.is_active() and exists (select 1 from public.entitlements e where e.user_id = auth.uid() and e.chapter = p_chapter and e.revoked_at is null);
$$;
revoke execute on function public.has_access(text) from public, anon;
grant execute on function public.has_access(text) to authenticated;

-- 2. The packs. No one reads the table directly; a few versions per chapter stay, so a page built a moment before the newest
--    upload still finds its own pack.
create table if not exists public.content_packs (
  chapter    text not null check (chapter ~ '^[a-z0-9_]{1,30}$'),
  sri        text not null check (sri ~ '^sha384-[A-Za-z0-9+/]{64}$'),
  body       text not null check (length(body) <= 2000000),
  created_at timestamptz not null default now(),
  primary key (chapter, sri)
);
alter table public.content_packs enable row level security;
revoke all on public.content_packs from anon, authenticated;

-- the build's key: only its sha256 is here, the key itself is a secret of the Cloudflare build
create or replace function public.deploy_ok() returns boolean language sql stable security definer set search_path = '' as $$
  select coalesce(length(h) >= 32 and encode(extensions.digest(h, 'sha256'), 'hex') = 'c31a3821bfb55675302fdc42f6e00be72cc020f1214f9aac4023453de46b535f', false)
  from (select nullif(current_setting('request.headers', true), '')::json ->> 'x-deploy' as h) x;
$$;
revoke execute on function public.deploy_ok() from public, anon, authenticated;

-- the build uploads a pack; the hash must match the body, byte for byte (that is what the browser will check)
create or replace function public.pack_put(p_chapter text, p_sri text, p_body text) returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  if not public.deploy_ok() then raise exception 'no'; end if;
  if p_sri <> 'sha384-' || encode(extensions.digest(convert_to(p_body, 'UTF8'), 'sha384'), 'base64') then raise exception 'hash mismatch'; end if;
  insert into public.content_packs (chapter, sri, body) values (p_chapter, p_sri, p_body) on conflict (chapter, sri) do nothing;
  delete from public.content_packs c where c.chapter = p_chapter and c.sri <> p_sri
    and c.sri not in (select k.sri from public.content_packs k where k.chapter = p_chapter order by k.created_at desc limit 5);
  return jsonb_build_object('chapter', p_chapter, 'sri', p_sri);
end $$;
revoke execute on function public.pack_put(text, text, text) from public, authenticated;
grant execute on function public.pack_put(text, text, text) to anon;

-- 3. Tickets: for each chapter the page asks for (with the hash it was built with), an address that works for 10 minutes, only for
--    a chapter this account may open and a pack that exists. The HMAC key is made once, in the Vault.
do $$ begin
  if not exists (select 1 from vault.secrets where name = 'pack_ticket_key') then
    perform vault.create_secret(encode(extensions.gen_random_bytes(32), 'hex'), 'pack_ticket_key', 'HMAC key of the content pack tickets');
  end if;
end $$;

create or replace function public.pack_sig(p_user uuid, p_chapter text, p_sri text, p_exp bigint) returns text language sql stable security definer set search_path = '' as $$
  select encode(extensions.hmac(p_user::text || '|' || p_chapter || '|' || p_sri || '|' || p_exp::text,
                                (select s.decrypted_secret from vault.decrypted_secrets s where s.name = 'pack_ticket_key' limit 1), 'sha256'), 'hex');
$$;
revoke execute on function public.pack_sig(uuid, text, text, bigint) from public, anon, authenticated;

create or replace function public.pack_tickets(p_packs jsonb) returns table (c text, url text) language plpgsql stable security definer set search_path = '' as $$
declare v_uid uuid := auth.uid(); v_exp bigint := extract(epoch from now())::bigint + 600; r jsonb;
begin
  if v_uid is null then raise exception 'not signed in'; end if;
  for r in select * from jsonb_array_elements(coalesce(p_packs, '[]'::jsonb)) limit 20 loop
    if public.has_access(r->>'c') and exists (select 1 from public.content_packs k where k.chapter = r->>'c' and k.sri = r->>'s') then
      c := r->>'c';
      url := 'https://afzlmlbigruxijudqukp.supabase.co/functions/v1/pack?c=' || c || '&s=' || replace(replace(replace(r->>'s', '+', '%2B'), '/', '%2F'), '=', '%3D')
             || '&u=' || v_uid || '&x=' || v_exp || '&t=' || public.pack_sig(v_uid, c, r->>'s', v_exp);
      return next;
    end if;
  end loop;
end $$;
revoke execute on function public.pack_tickets(jsonb) from public, anon;
grant execute on function public.pack_tickets(jsonb) to authenticated;

-- the Edge Function trades a valid, unexpired ticket for the pack (anon: the ticket itself is the permission)
create or replace function public.pack_body(p_chapter text, p_sri text, p_user uuid, p_exp bigint, p_sig text) returns text language plpgsql stable security definer set search_path = '' as $$
declare v_body text;
begin
  if p_exp < extract(epoch from now())::bigint or p_exp > extract(epoch from now())::bigint + 900 then return null; end if;
  if p_sig is null or length(p_sig) <> 64 or p_sig <> public.pack_sig(p_user, p_chapter, p_sri, p_exp) then return null; end if;
  select k.body into v_body from public.content_packs k where k.chapter = p_chapter and k.sri = p_sri;
  return v_body;
end $$;
revoke execute on function public.pack_body(text, text, uuid, bigint, text) from public, authenticated;
grant execute on function public.pack_body(text, text, uuid, bigint, text) to anon;

-- 4. Staff open every chapter (rows of source 'staff' for each teacher account), so Raz reads the course without the coupon.
insert into public.entitlements (user_id, chapter, source)
select p.id, ch.c, 'staff' from public.profiles p cross join (values ('intro'), ('ra')) as ch(c)
where p.role = 'teacher' on conflict (user_id, chapter) do nothing;
