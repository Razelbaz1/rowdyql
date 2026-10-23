-- Raz's shop tester buys new chapters (Raz, 2026-10-24). Run once in the SQL editor; safe to run again.
-- A chapter that isn't released is open to staff (to preview it) and to a shop tester only once they bought it, so Raz can test
-- buying a new chapter with the simulated payment before students see it. Students still see it as "soon". The rest of
-- has_access is unchanged (migration_2026-10-22_release.sql).

create or replace function public.has_access(p_chapter text) returns boolean language sql stable security definer set search_path = '' as $$
  select public.is_active() and auth.uid() is not null and p_chapter in ('intro', 'ra', 'sql', 'norm', 'erd') and (
    (not public.chapter_released(p_chapter) and (
      public.is_teacher()
      or (public.shop_tester() and exists (select 1 from public.entitlements e where e.user_id = auth.uid() and e.chapter = p_chapter
        and e.revoked_at is null and (e.expires_at is null or e.expires_at > now())))))
    or (public.chapter_released(p_chapter) and (
      p_chapter = 'intro'
      or public.shop_all_open()
      or exists (select 1 from public.entitlements e where e.user_id = auth.uid() and e.chapter = p_chapter
        and e.revoked_at is null and (e.expires_at is null or e.expires_at > now())))));
$$;
revoke execute on function public.has_access(text) from public, anon;
grant execute on function public.has_access(text) to authenticated;
