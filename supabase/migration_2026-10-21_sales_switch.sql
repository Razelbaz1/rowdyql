-- The sales switch (2026-10-21). Run once in the SQL editor; safe to run again.
-- While sales are off (the default, until launch) every active, signed-in account may open every chapter, and the site shows no
-- prices, codes or gift badge: rowdyql.com can move to the protected build and nothing changes for students. Raz's test accounts
-- (staff and shop_testers) still see the shop as it will be, to test it. Staff turn sales on in the board on launch day.

create table if not exists public.shop_state (
  id         int primary key default 1 check (id = 1),
  open       boolean not null default false,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users (id) on delete set null
);
insert into public.shop_state (id, open) values (1, false) on conflict (id) do nothing;
alter table public.shop_state enable row level security;
revoke all on public.shop_state from anon, authenticated;

create or replace function public.shop_open() returns boolean language sql stable security definer set search_path = '' as $$
  select coalesce((select s.open from public.shop_state s where s.id = 1), false);
$$;
revoke execute on function public.shop_open() from public, anon, authenticated;

-- this account sees every chapter, with no shop: sales are off and it isn't one of Raz's test accounts
create or replace function public.shop_all_open() returns boolean language sql stable security definer set search_path = '' as $$
  select auth.uid() is not null and not public.shop_open() and not public.shop_tester();
$$;
revoke execute on function public.shop_all_open() from public, anon, authenticated;

create or replace function public.has_access(p_chapter text) returns boolean language sql stable security definer set search_path = '' as $$
  select public.is_active() and auth.uid() is not null and (
    p_chapter = 'intro'
    or (p_chapter in ('ra', 'sql', 'norm', 'erd') and public.shop_all_open())
    or exists (select 1 from public.entitlements e where e.user_id = auth.uid() and e.chapter = p_chapter
      and e.revoked_at is null and (e.expires_at is null or e.expires_at > now())));
$$;
revoke execute on function public.has_access(text) from public, anon;
grant execute on function public.has_access(text) to authenticated;

create or replace function public.my_chapters() returns setof text language sql stable security definer set search_path = '' as $$
  select c from (
    select x c from unnest(array['intro', 'ra', 'sql', 'norm', 'erd']) x where public.shop_all_open()
    union
    select 'intro'::text where auth.uid() is not null
    union
    select e.chapter from public.entitlements e
    where e.user_id = auth.uid() and e.revoked_at is null and (e.expires_at is null or e.expires_at > now())
  ) y where public.is_active() order by c;
$$;
revoke execute on function public.my_chapters() from public, anon;
grant execute on function public.my_chapters() to authenticated;

drop function if exists public.my_access();
create or replace function public.my_access() returns table (chapter text, expires_at timestamptz) language plpgsql stable security definer set search_path = '' as $$
begin
  if auth.uid() is null or not public.is_active() then return; end if;
  if public.shop_all_open() then
    return query select x, null::timestamptz from unnest(array['intro', 'ra', 'sql', 'norm', 'erd']) x;
    return;
  end if;
  return query select 'intro'::text, null::timestamptz
    union all
    select e.chapter, e.expires_at from public.entitlements e
    where e.user_id = auth.uid() and e.chapter <> 'intro' and e.revoked_at is null
      and (e.expires_at is null or e.expires_at > now() - interval '60 days');
end $$;
revoke execute on function public.my_access() from public, anon;
grant execute on function public.my_access() to authenticated;

-- the shop as this account sees it; staff also get the switch itself
create or replace function public.shop_me() returns jsonb language sql stable security definer set search_path = '' as $$
  select jsonb_build_object(
    'tester', auth.uid() is not null and public.shop_tester(),
    'open', auth.uid() is not null and (public.shop_open() or public.shop_tester()),
    'sales', case when public.is_teacher() then public.shop_open() end);
$$;
revoke execute on function public.shop_me() from public, anon;
grant execute on function public.shop_me() to authenticated;

create or replace function public.shop_set_open(p_open boolean) returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  if not public.is_teacher() then raise exception 'staff only'; end if;
  update public.shop_state s set open = coalesce(p_open, false), updated_at = now(), updated_by = auth.uid() where s.id = 1;
  return jsonb_build_object('open', public.shop_open());
end $$;
revoke execute on function public.shop_set_open(boolean) from public, anon;
grant execute on function public.shop_set_open(boolean) to authenticated;
