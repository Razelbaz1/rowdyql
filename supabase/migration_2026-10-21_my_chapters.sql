-- What each account owns (2026-10-21). The page shapes the learn tab, the course map, the plan card and the purchase page by the
-- chapters an account owns. The content itself still comes only through pack_tickets / has_access; this list only draws the screens.
-- Run once in the SQL editor; safe to run again.

-- 1. The caller's chapters: entitlements that weren't revoked, on an account that isn't blocked.
create or replace function public.my_chapters() returns setof text language sql stable security definer set search_path = '' as $$
  select e.chapter from public.entitlements e
  where e.user_id = auth.uid() and e.revoked_at is null and public.is_active()
  order by e.chapter;
$$;
revoke execute on function public.my_chapters() from public, anon;
grant execute on function public.my_chapters() to authenticated;

-- 2. Staff own every chapter of the course, the ones still being written too, so Raz sees the course as a full buyer does.
insert into public.entitlements (user_id, chapter, source)
select p.id, ch.c, 'staff' from public.profiles p cross join (values ('intro'), ('ra'), ('sql'), ('norm'), ('erd')) as ch(c)
where p.role = 'teacher' on conflict (user_id, chapter) do nothing;
