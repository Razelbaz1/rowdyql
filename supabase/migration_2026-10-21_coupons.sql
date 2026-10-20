-- Coupons, stage 1 (2026-10-21). Raz's promo codes: a code opens chapters (or the whole course) for N days from redeeming, until a
-- date, or forever; a quota and a last day to redeem are optional. Run once in the SQL editor; safe to run again.
-- 1. entitlements.expires_at: a chapter may be open for a while. has_access and my_chapters skip ended ones; my_access lists the
--    caller's chapters with their end, the ended ones too for 60 days, so the page can say "הגישה הסתיימה".
-- 2. coupons (staff read and write them), coupon_redemptions (who redeemed what, until when; revoking keeps the row) and
--    coupon_attempts (at most 5 unknown codes in 10 minutes per account). Students reach them only through coupon_redeem().
-- 3. coupon_redeem(): signed in, active account. Answers {chapters, expires_at}, or {error} with unknown / expired / used_up /
--    again / slow. It answers instead of raising, so a wrong try is still counted.
-- 4. Staff: coupon_list() (with how many redeemed), coupon_users(code), coupon_revoke(redemption id).

alter table public.entitlements add column if not exists expires_at timestamptz;

create or replace function public.has_access(p_chapter text) returns boolean language sql stable security definer set search_path = '' as $$
  select public.is_active() and exists (select 1 from public.entitlements e where e.user_id = auth.uid() and e.chapter = p_chapter
    and e.revoked_at is null and (e.expires_at is null or e.expires_at > now()));
$$;
revoke execute on function public.has_access(text) from public, anon;
grant execute on function public.has_access(text) to authenticated;

create or replace function public.my_chapters() returns setof text language sql stable security definer set search_path = '' as $$
  select e.chapter from public.entitlements e
  where e.user_id = auth.uid() and e.revoked_at is null and (e.expires_at is null or e.expires_at > now()) and public.is_active()
  order by e.chapter;
$$;
revoke execute on function public.my_chapters() from public, anon;
grant execute on function public.my_chapters() to authenticated;

create or replace function public.my_access() returns table (chapter text, expires_at timestamptz) language sql stable security definer set search_path = '' as $$
  select e.chapter, e.expires_at from public.entitlements e
  where e.user_id = auth.uid() and e.revoked_at is null and public.is_active() and (e.expires_at is null or e.expires_at > now() - interval '60 days')
  order by e.chapter;
$$;
revoke execute on function public.my_access() from public, anon;
grant execute on function public.my_access() to authenticated;

create table if not exists public.coupons (
  code       text primary key check (code ~ '^[A-Z0-9-]{4,24}$'),
  note       text not null default '' check (char_length(note) <= 120),
  chapters   text[] not null check (cardinality(chapters) between 1 and 10 and chapters <@ array['intro', 'ra', 'sql', 'norm', 'erd']),
  days       int check (days between 1 and 365),
  until      timestamptz,
  quota      int check (quota between 1 and 100000),
  redeem_by  timestamptz,
  active     boolean not null default true,
  created_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  constraint coupons_one_end check (days is null or until is null)
);
alter table public.coupons enable row level security;
revoke all on public.coupons from anon, authenticated;
grant select, insert, update on public.coupons to authenticated;
drop policy if exists coupons_staff on public.coupons;
create policy coupons_staff on public.coupons for all using (public.is_teacher()) with check (public.is_teacher());

create table if not exists public.coupon_redemptions (
  id         bigint generated always as identity primary key,
  code       text not null references public.coupons (code) on update cascade,
  user_id    uuid not null references auth.users (id) on delete cascade,
  at         timestamptz not null default now(),
  chapters   text[] not null default '{}',   -- what this redemption opened or extended
  expires_at timestamptz,
  revoked_at timestamptz,
  unique (code, user_id)
);
alter table public.coupon_redemptions enable row level security;
revoke all on public.coupon_redemptions from anon, authenticated;

create table if not exists public.coupon_attempts (
  user_id uuid not null references auth.users (id) on delete cascade,
  at      timestamptz not null default now(),
  ok      boolean not null
);
create index if not exists coupon_attempts_user_at on public.coupon_attempts (user_id, at);
alter table public.coupon_attempts enable row level security;
revoke all on public.coupon_attempts from anon, authenticated;

create or replace function public.coupon_redeem(p_code text) returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_uid uuid := auth.uid();
  v_code text := upper(regexp_replace(coalesce(p_code, ''), '[\s_]+', '', 'g'));
  c public.coupons%rowtype; e public.entitlements%rowtype;
  v_exp timestamptz; v_open text[] := '{}'; ch text;
begin
  if v_uid is null then raise exception 'not signed in'; end if;
  if not public.is_active() then raise exception 'blocked'; end if;
  delete from public.coupon_attempts a where a.user_id = v_uid and a.at < now() - interval '1 day';
  if (select count(*) from public.coupon_attempts a where a.user_id = v_uid and not a.ok and a.at > now() - interval '10 minutes') >= 5 then
    return jsonb_build_object('error', 'slow');
  end if;
  if v_code ~ '^[A-Z0-9-]{4,24}$' then select * into c from public.coupons k where k.code = v_code for update; end if;
  if c.code is null then
    insert into public.coupon_attempts (user_id, ok) values (v_uid, false);
    return jsonb_build_object('error', 'unknown');
  end if;
  if not c.active or (c.redeem_by is not null and c.redeem_by < now()) or (c.until is not null and c.until <= now()) then
    return jsonb_build_object('error', 'expired');
  end if;
  if exists (select 1 from public.coupon_redemptions r where r.code = c.code and r.user_id = v_uid) then
    return jsonb_build_object('error', 'again');
  end if;
  if c.quota is not null and (select count(*) from public.coupon_redemptions r where r.code = c.code) >= c.quota then
    return jsonb_build_object('error', 'used_up');
  end if;
  v_exp := case when c.days is not null then now() + make_interval(days => c.days) else c.until end;   -- null: for good
  foreach ch in array c.chapters loop
    select * into e from public.entitlements x where x.user_id = v_uid and x.chapter = ch for update;
    if e.user_id is null then
      insert into public.entitlements (user_id, chapter, source, ref, expires_at) values (v_uid, ch, 'coupon', c.code, v_exp);
      v_open := v_open || ch;
    elsif e.revoked_at is not null or (e.expires_at is not null and e.expires_at <= now()) then
      -- revoked or ended: the code opens it again
      update public.entitlements x set source = 'coupon', ref = c.code, granted_at = now(), revoked_at = null, expires_at = v_exp
        where x.user_id = v_uid and x.chapter = ch;
      v_open := v_open || ch;
    elsif e.expires_at is not null and (v_exp is null or v_exp > e.expires_at) then
      -- open for a while: the later end wins
      update public.entitlements x set source = 'coupon', ref = c.code, expires_at = v_exp where x.user_id = v_uid and x.chapter = ch;
      v_open := v_open || ch;
    end if;   -- open for good already: nothing to do
    e := null;
  end loop;
  -- nothing new: the code isn't spent
  if cardinality(v_open) = 0 then return jsonb_build_object('chapters', '[]'::jsonb, 'expires_at', null); end if;
  insert into public.coupon_redemptions (code, user_id, chapters, expires_at) values (c.code, v_uid, v_open, v_exp);
  insert into public.coupon_attempts (user_id, ok) values (v_uid, true);
  return jsonb_build_object('chapters', to_jsonb(v_open), 'expires_at', v_exp);
end $$;
revoke execute on function public.coupon_redeem(text) from public, anon;
grant execute on function public.coupon_redeem(text) to authenticated;

create or replace function public.coupon_list() returns table (code text, note text, chapters text[], days int, until timestamptz, quota int,
  redeem_by timestamptz, active boolean, created_at timestamptz, used int)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.is_teacher() then raise exception 'staff only'; end if;
  return query select c.code, c.note, c.chapters, c.days, c.until, c.quota, c.redeem_by, c.active, c.created_at,
    (select count(*)::int from public.coupon_redemptions r where r.code = c.code)
    from public.coupons c order by c.created_at desc;
end $$;
revoke execute on function public.coupon_list() from public, anon;
grant execute on function public.coupon_list() to authenticated;

create or replace function public.coupon_users(p_code text) returns table (id bigint, name text, email text, at timestamptz, expires_at timestamptz, revoked_at timestamptz)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.is_teacher() then raise exception 'staff only'; end if;
  return query select r.id, p.full_name, u.email::text, r.at, r.expires_at, r.revoked_at
    from public.coupon_redemptions r join auth.users u on u.id = r.user_id left join public.profiles p on p.id = r.user_id
    where r.code = p_code order by r.at desc;
end $$;
revoke execute on function public.coupon_users(text) from public, anon;
grant execute on function public.coupon_users(text) to authenticated;

-- closes what this redemption opened, where the chapter still comes from this code; the account stays
create or replace function public.coupon_revoke(p_id bigint) returns jsonb language plpgsql security definer set search_path = '' as $$
declare r public.coupon_redemptions%rowtype;
begin
  if not public.is_teacher() then raise exception 'staff only'; end if;
  update public.coupon_redemptions x set revoked_at = now() where x.id = p_id and x.revoked_at is null returning * into r;
  if r.id is null then raise exception 'not found'; end if;
  update public.entitlements e set revoked_at = now()
    where e.user_id = r.user_id and e.chapter = any (r.chapters) and e.source = 'coupon' and e.ref = r.code and e.revoked_at is null;
  return jsonb_build_object('id', r.id);
end $$;
revoke execute on function public.coupon_revoke(bigint) from public, anon;
grant execute on function public.coupon_revoke(bigint) to authenticated;
