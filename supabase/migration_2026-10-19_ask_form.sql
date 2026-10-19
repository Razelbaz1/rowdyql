-- "Write to us" inside the site (Raz, 2026-10-19). Run once in the SQL editor; safe to run again.
-- A signed-in student writes up to 1000 characters in a window on the site; request_submit puts it in public.requests as 'new',
-- with the account's name, email, institution and field taken from the server (never from the browser), plus the lesson and page.
-- The board shows it first; the reply still goes by email from hello@ through send_request_reply.

alter table public.requests add column if not exists source text not null default 'mail';
alter table public.requests add column if not exists lesson text not null default '';
alter table public.requests add column if not exists page   text not null default '';
alter table public.requests drop constraint if exists requests_source_check;
alter table public.requests add constraint requests_source_check check (source in ('mail', 'site'));
alter table public.requests drop constraint if exists requests_status_check;
alter table public.requests add constraint requests_status_check check (status in ('new', 'review', 'discussion', 'sent', 'closed'));
create index if not exists requests_user_site_at on public.requests (user_id, at) where source = 'site';

-- one message from the signed-in student. 'daily limit' after 5 in the same Israeli calendar day.
create or replace function public.request_submit(p_text text, p_subject text default '', p_lesson text default '', p_page text default '')
returns bigint language plpgsql security definer set search_path = '' as $$
declare uid uuid := auth.uid(); v_email text; v_id bigint;
        v_text text := btrim(regexp_replace(coalesce(p_text, ''), '[\x01-\x08\x0B\x0C\x0E-\x1F\x7F]', '', 'g'));
begin
  if uid is null then raise exception 'not signed in'; end if;
  if not public.is_active() then raise exception 'blocked'; end if;
  if v_text = '' or length(v_text) > 1000 then raise exception 'bad length'; end if;
  if (select count(*) from public.requests r where r.user_id = uid and r.source = 'site'
        and r.at >= (date_trunc('day', now() at time zone 'Asia/Jerusalem') at time zone 'Asia/Jerusalem')) >= 5 then
    raise exception 'daily limit';
  end if;
  select u.email into v_email from auth.users u where u.id = uid;
  insert into public.requests (from_name, from_email, subject, body, user_id, inst, course, category, status, source, lesson, page)
  select coalesce(p.full_name, ''), v_email, left(regexp_replace(coalesce(p_subject, ''), '[[:cntrl:]]', ' ', 'g'), 200), v_text, uid,
         coalesce(p.institution, ''), coalesce(p.field_of_study, ''), 'other', 'new', 'site',
         left(regexp_replace(coalesce(p_lesson, ''), '[[:cntrl:]]', ' ', 'g'), 200),
         case when coalesce(p_page, '') ~ '^https://rowdyql\.com/' then left(p_page, 500) else '' end
  from public.profiles p where p.id = uid
  returning id into v_id;
  if v_id is null then raise exception 'no profile'; end if;
  return v_id;
end $$;
revoke execute on function public.request_submit(text, text, text, text) from public, anon;
grant execute on function public.request_submit(text, text, text, text) to authenticated;
