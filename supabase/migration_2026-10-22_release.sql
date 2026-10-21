-- Releasing chapters (Raz, 2026-10-22). Run once in the SQL editor; safe to run again.
-- New content doesn't reach students until Raz releases it. A chapter that isn't released is open only to staff and Raz's shop
-- testers (to preview it); everyone else sees it as "soon", whether sales are on or off, and even when they bought it (the whole
-- course includes it once it's out). The intro and Relational algebra are released; SQL, Normalization and ERD start closed.

create table if not exists public.chapter_release (
  chapter     text primary key check (chapter in ('intro', 'ra', 'sql', 'norm', 'erd')),
  released    boolean not null default false,
  released_at timestamptz,
  updated_by  uuid references auth.users (id) on delete set null
);
insert into public.chapter_release (chapter, released, released_at) values
  ('intro', true, now()), ('ra', true, now()), ('sql', false, null), ('norm', false, null), ('erd', false, null)
  on conflict (chapter) do nothing;
alter table public.chapter_release enable row level security;
revoke all on public.chapter_release from anon, authenticated;

create or replace function public.chapter_released(p_chapter text) returns boolean language sql stable security definer set search_path = '' as $$
  select coalesce((select r.released from public.chapter_release r where r.chapter = p_chapter), false);
$$;
revoke execute on function public.chapter_released(text) from public, anon, authenticated;

create or replace function public.has_access(p_chapter text) returns boolean language sql stable security definer set search_path = '' as $$
  select public.is_active() and auth.uid() is not null and p_chapter in ('intro', 'ra', 'sql', 'norm', 'erd') and (
    (not public.chapter_released(p_chapter) and public.shop_tester())
    or (public.chapter_released(p_chapter) and (
      p_chapter = 'intro'
      or public.shop_all_open()
      or exists (select 1 from public.entitlements e where e.user_id = auth.uid() and e.chapter = p_chapter
        and e.revoked_at is null and (e.expires_at is null or e.expires_at > now())))));
$$;
revoke execute on function public.has_access(text) from public, anon;
grant execute on function public.has_access(text) to authenticated;

create or replace function public.my_chapters() returns setof text language sql stable security definer set search_path = '' as $$
  select c from unnest(array['intro', 'ra', 'sql', 'norm', 'erd']) c where public.has_access(c) order by c;
$$;
revoke execute on function public.my_chapters() from public, anon;
grant execute on function public.my_chapters() to authenticated;

-- the caller's chapters with their end; a timed one that ended in the last 60 days too, so the page can say "הגישה הסתיימה"
drop function if exists public.my_access();
create or replace function public.my_access() returns table (chapter text, expires_at timestamptz) language plpgsql stable security definer set search_path = '' as $$
declare c text; v timestamptz; timed boolean;
begin
  if auth.uid() is null or not public.is_active() then return; end if;
  foreach c in array array['intro', 'ra', 'sql', 'norm', 'erd'] loop
    timed := c <> 'intro' and public.chapter_released(c) and not public.shop_all_open();
    v := null;
    if timed then
      select e.expires_at into v from public.entitlements e where e.user_id = auth.uid() and e.chapter = c and e.revoked_at is null;
    end if;
    if public.has_access(c) then
      chapter := c; expires_at := case when timed then v end; return next;
    elsif timed and v is not null and v > now() - interval '60 days' then
      chapter := c; expires_at := v; return next;
    end if;
  end loop;
end $$;
revoke execute on function public.my_access() from public, anon;
grant execute on function public.my_access() to authenticated;

-- the shop as this account sees it: + the chapters not out yet (shown as "soon"), and whether this account previews them
create or replace function public.shop_me() returns jsonb language sql stable security definer set search_path = '' as $$
  select jsonb_build_object(
    'tester', auth.uid() is not null and public.shop_tester(),
    'open', auth.uid() is not null and (public.shop_open() or public.shop_tester()),
    'sales', case when public.is_teacher() then public.shop_open() end,
    'unreleased', coalesce((select jsonb_agg(r.chapter order by array_position(array['intro', 'ra', 'sql', 'norm', 'erd'], r.chapter))
                            from public.chapter_release r where not r.released), '[]'::jsonb));
$$;
revoke execute on function public.shop_me() from public, anon;
grant execute on function public.shop_me() to authenticated;

create or replace function public.chapter_release_list() returns table (chapter text, released boolean, released_at timestamptz)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.is_teacher() then raise exception 'staff only'; end if;
  return query select r.chapter, r.released, r.released_at from public.chapter_release r
    order by array_position(array['intro', 'ra', 'sql', 'norm', 'erd'], r.chapter);
end $$;
revoke execute on function public.chapter_release_list() from public, anon;
grant execute on function public.chapter_release_list() to authenticated;

create or replace function public.chapter_set_released(p_chapter text, p_released boolean) returns jsonb
language plpgsql security definer set search_path = '' as $$
begin
  if not public.is_teacher() then raise exception 'staff only'; end if;
  update public.chapter_release r set released = coalesce(p_released, false),
    released_at = case when coalesce(p_released, false) then coalesce(r.released_at, now()) else null end, updated_by = auth.uid()
    where r.chapter = p_chapter;
  if not found then raise exception 'unknown chapter'; end if;
  return jsonb_build_object('chapter', p_chapter, 'released', public.chapter_released(p_chapter));
end $$;
revoke execute on function public.chapter_set_released(text, boolean) from public, anon;
grant execute on function public.chapter_set_released(text, boolean) to authenticated;
