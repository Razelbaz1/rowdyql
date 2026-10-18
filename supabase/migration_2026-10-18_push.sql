-- Study reminders by Web Push (run once in the SQL editor; safe to run again).
-- A student turns reminders on per device: the site saves the browser's push subscription through push_sub_save(). The Edge Function
-- push-tick, called by pg_cron every 15 minutes, reads what it needs through push_data(), claims each reminder once through
-- push_claim(), and drops dead subscriptions through push_gone(). Those three check a shared secret kept in the Vault ('push_tick'),
-- the same value as the function's PUSH_TICK secret. Create it once, outside this file:  select vault.create_secret('<random>', 'push_tick');
-- Reminders exist only for a confirmed calendar (the site writes dbs_cal_out only then) and a device that turned them on.
create extension if not exists pg_cron;
create extension if not exists pg_net;

-- one row per device; the student sees their own rows, and writes only through the functions below
create table if not exists public.push_subs (
  endpoint   text primary key,
  user_id    uuid not null references auth.users (id) on delete cascade,
  p256dh     text not null,
  auth       text not null,
  ua         text not null default '',
  created_at timestamptz not null default now()
);
create index if not exists push_subs_user on public.push_subs (user_id);
alter table public.push_subs enable row level security;
drop policy if exists push_subs_own on public.push_subs;
create policy push_subs_own on public.push_subs for select using (user_id = auth.uid());
revoke all on public.push_subs from anon;
revoke insert, update, delete on public.push_subs from authenticated;

-- what was already sent (kind 'pre' or 'post' per session key), so nothing goes twice; no access at all
create table if not exists public.push_sent (
  user_id uuid not null references auth.users (id) on delete cascade,
  skey    text not null,
  kind    text not null check (kind in ('pre', 'post')),
  at      timestamptz not null default now(),
  primary key (user_id, skey, kind)
);
alter table public.push_sent enable row level security;
revoke all on public.push_sent from anon, authenticated;

-- the student's device: saved (or moved to them, when another account used this browser before), and dropped
create or replace function public.push_sub_save(p_endpoint text, p_p256dh text, p_auth text, p_ua text default '') returns void
language plpgsql security definer set search_path = '' as $$
begin
  if auth.uid() is null then raise exception 'not signed in'; end if;
  if p_endpoint !~ '^https://' or length(p_endpoint) > 1000 or length(p_p256dh) > 200 or length(p_auth) > 100 then raise exception 'bad subscription'; end if;
  insert into public.push_subs (endpoint, user_id, p256dh, auth, ua) values (p_endpoint, auth.uid(), p_p256dh, p_auth, left(coalesce(p_ua, ''), 300))
    on conflict (endpoint) do update set user_id = auth.uid(), p256dh = excluded.p256dh, auth = excluded.auth, ua = excluded.ua;
end $$;
create or replace function public.push_sub_drop(p_endpoint text) returns void language sql security definer set search_path = '' as $$
  delete from public.push_subs where endpoint = p_endpoint and user_id = auth.uid();
$$;
revoke all on function public.push_sub_save(text, text, text, text) from public, anon;
revoke all on function public.push_sub_drop(text) from public, anon;
grant execute on function public.push_sub_save(text, text, text, text) to authenticated;
grant execute on function public.push_sub_drop(text) to authenticated;

-- the shared secret, checked by the three functions the Edge Function calls
create or replace function public.push_ok(p_secret text) returns boolean language sql stable security definer set search_path = '' as $$
  select coalesce(length(p_secret) >= 32 and p_secret = (select s.decrypted_secret from vault.decrypted_secrets s where s.name = 'push_tick' limit 1), false);
$$;
revoke all on function public.push_ok(text) from public, anon, authenticated;

-- every student with a device: their devices, their calendar list and their active days
create or replace function public.push_data(p_secret text) returns jsonb language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.push_ok(p_secret) then raise exception 'no'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object('u', u.user_id, 'subs', u.subs, 'cal', c.value, 'days', coalesce(d.value, '[]'::jsonb)))
    from (select ps.user_id, jsonb_agg(jsonb_build_object('e', ps.endpoint, 'p', ps.p256dh, 'a', ps.auth)) as subs from public.push_subs ps group by ps.user_id) u
    join public.progress c on c.user_id = u.user_id and c.key = 'dbs_cal_out'
    left join public.progress d on d.user_id = u.user_id and d.key = 'dbs_days'), '[]'::jsonb);
end $$;

-- claim reminders: returns only the ones not sent before (and forgets claims older than 60 days)
create or replace function public.push_claim(p_secret text, p_items jsonb) returns jsonb language plpgsql security definer set search_path = '' as $$
declare won jsonb;
begin
  if not public.push_ok(p_secret) then raise exception 'no'; end if;
  delete from public.push_sent where at < now() - interval '60 days';
  with ins as (
    insert into public.push_sent (user_id, skey, kind)
    select (i->>'u')::uuid, i->>'k', i->>'kind' from jsonb_array_elements(p_items) i
    on conflict do nothing returning user_id, skey, kind)
  select coalesce(jsonb_agg(jsonb_build_object('u', user_id, 'k', skey, 'kind', kind)), '[]'::jsonb) into won from ins;
  return won;
end $$;

-- devices the push service says are gone
create or replace function public.push_gone(p_secret text, p_endpoints text[]) returns void language plpgsql security definer set search_path = '' as $$
begin
  if not public.push_ok(p_secret) then raise exception 'no'; end if;
  delete from public.push_subs where endpoint = any(p_endpoints);
end $$;
revoke all on function public.push_data(text) from public;
revoke all on function public.push_claim(text, jsonb) from public;
revoke all on function public.push_gone(text, text[]) from public;
grant execute on function public.push_data(text) to anon;
grant execute on function public.push_claim(text, jsonb) to anon;
grant execute on function public.push_gone(text, text[]) to anon;

-- every 15 minutes, on the quarter hour
select cron.unschedule('push-tick') where exists (select 1 from cron.job where jobname = 'push-tick');
select cron.schedule('push-tick', '*/15 * * * *', $$
  select net.http_post(
    url := 'https://afzlmlbigruxijudqukp.supabase.co/functions/v1/push-tick',
    headers := jsonb_build_object('content-type', 'application/json', 'x-tick', (select s.decrypted_secret from vault.decrypted_secrets s where s.name = 'push_tick' limit 1)),
    body := '{}'::jsonb, timeout_milliseconds := 20000)
$$);
