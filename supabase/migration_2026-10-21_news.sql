-- "What's new" (2026-10-21). Run once in the SQL editor; safe to run again.
-- 1. notices.kind: 'notice' (the bell, as before; may also be emailed) or 'news' (a window once + the bell; never emailed).
--    notices.guide: the id of a guide on the site (GUIDES in src/page.html), so the window offers "הראו לי איך" and walks the
--    student through the tool on the real page. Only the id is stored; the steps ship with the site.
-- 2. news_drafts: "what's new" proposals from the agent (the daily routine, or a Claude Code session after a change ships),
--    waiting for Raz in the board's announcements tab. Staff read them and edit the open ones (or drop them); only
--    news_publish() publishes, so a published proposal always has its notice.
-- 3. news_publish(): staff only. The proposal, as Raz edited it, becomes a 'news' notice.
-- 4. For the routine, behind the x-inbox header like the other inbox_* functions: inbox_news_state() (the last commit it
--    checked, and the recent proposals, so it doesn't propose the same change twice) and inbox_news() (moves that mark,
--    and adds a proposal when there is one; at most 3 a day).
-- 5. inbox_summary() also counts waiting proposals, so the summary email goes out when only a proposal is waiting.

alter table public.notices add column if not exists kind text not null default 'notice';
alter table public.notices drop constraint if exists notices_kind_check;
alter table public.notices add constraint notices_kind_check check (kind in ('notice', 'news'));
alter table public.notices add column if not exists guide text;
alter table public.notices drop constraint if exists notices_guide_check;
alter table public.notices add constraint notices_guide_check check (guide ~ '^[a-z0-9_]{1,40}$');

create table if not exists public.news_drafts (
  id        bigint generated always as identity primary key,
  at        timestamptz not null default now(),
  source    text not null default 'session' check (source in ('routine', 'session')),
  title     text not null check (char_length(btrim(title)) between 2 and 120),
  body      text not null default '' check (char_length(body) <= 2000),
  note      text not null default '' check (char_length(note) <= 1000),
  commits   text not null default '' check (char_length(commits) <= 500),
  guide     text check (guide ~ '^[a-z0-9_]{1,40}$'),
  status    text not null default 'review' check (status in ('review', 'discussion', 'published', 'dropped')),
  notice_id bigint references public.notices (id) on delete set null,
  done_at   timestamptz
);
alter table public.news_drafts enable row level security;
revoke all on public.news_drafts from anon, authenticated;
grant select, update on public.news_drafts to authenticated;
drop policy if exists news_drafts_staff_read on public.news_drafts;
create policy news_drafts_staff_read on public.news_drafts for select using (public.is_teacher());
drop policy if exists news_drafts_staff_edit on public.news_drafts;
create policy news_drafts_staff_edit on public.news_drafts for update
  using (public.is_teacher() and status in ('review', 'discussion'))
  with check (public.is_teacher() and status in ('review', 'discussion', 'dropped'));

-- the last commit on main the routine already checked (one row)
create table if not exists public.news_mark (
  id  int primary key default 1 check (id = 1),
  sha text not null check (sha ~ '^[0-9a-f]{7,40}$'),
  at  timestamptz not null default now()
);
alter table public.news_mark enable row level security;
revoke all on public.news_mark from anon, authenticated;

drop function if exists public.news_publish(bigint, text, text);
create or replace function public.news_publish(p_id bigint, p_title text, p_body text, p_guide text default null) returns jsonb
language plpgsql security definer set search_path = '' as $$
declare
  v_title text := left(btrim(coalesce(p_title, '')), 120);
  v_body  text := left(btrim(coalesce(p_body, '')), 2000);
  v_guide text := nullif(btrim(coalesce(p_guide, '')), '');
  v_nid bigint;
begin
  if not public.is_teacher() then raise exception 'staff only'; end if;
  if v_guide is not null and v_guide !~ '^[a-z0-9_]{1,40}$' then raise exception 'bad guide'; end if;
  if char_length(v_title) < 2 then raise exception 'empty title'; end if;
  perform 1 from public.news_drafts where id = p_id and status in ('review', 'discussion') for update;
  if not found then raise exception 'not an open proposal'; end if;
  insert into public.notices (title, body, author, kind, guide) values (v_title, v_body, auth.uid(), 'news', v_guide) returning id into v_nid;
  update public.news_drafts set title = v_title, body = v_body, guide = v_guide, status = 'published', notice_id = v_nid, done_at = now() where id = p_id;
  return jsonb_build_object('id', p_id, 'notice', v_nid);
end $$;
revoke execute on function public.news_publish(bigint, text, text, text) from public, anon;
grant execute on function public.news_publish(bigint, text, text, text) to authenticated;

create or replace function public.inbox_news_state() returns jsonb
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  return jsonb_build_object(
    'seen', (select m.sha from public.news_mark m where m.id = 1),
    'recent', coalesce((select jsonb_agg(jsonb_build_object('id', d.id, 'at', d.at, 'source', d.source, 'status', d.status, 'title', d.title, 'commits', d.commits, 'guide', d.guide) order by d.at desc)
                        from (select * from public.news_drafts order by at desc limit 15) d), '[]'::jsonb));
end $$;

create or replace function public.inbox_news(p_seen text, p_row jsonb default null) returns jsonb
language plpgsql security definer set search_path = '' as $$
declare v_id bigint; v_title text; v_guide text;
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  if coalesce(p_seen, '') !~ '^[0-9a-f]{7,40}$' then raise exception 'bad commit'; end if;
  if p_row is not null and jsonb_typeof(p_row) = 'object' then
    v_title := left(btrim(coalesce(p_row->>'title', '')), 120);
    if char_length(v_title) < 2 then raise exception 'empty title'; end if;
    v_guide := nullif(btrim(coalesce(p_row->>'guide', '')), '');
    if v_guide is not null and v_guide !~ '^[a-z0-9_]{1,40}$' then raise exception 'bad guide'; end if;
    if (select count(*) from public.news_drafts where source = 'routine' and at > now() - interval '1 day') >= 3 then raise exception 'daily cap'; end if;
    insert into public.news_drafts (source, title, body, note, commits, guide)
    values ('routine', v_title, left(btrim(coalesce(p_row->>'body', '')), 2000), left(btrim(coalesce(p_row->>'note', '')), 1000),
            left(btrim(coalesce(p_row->>'commits', '')), 500), v_guide)
    returning id into v_id;
  end if;
  insert into public.news_mark (id, sha, at) values (1, p_seen, now())
    on conflict (id) do update set sha = excluded.sha, at = now();
  return jsonb_build_object('id', v_id, 'seen', p_seen);
end $$;

revoke execute on function public.inbox_news_state() from public, authenticated;
revoke execute on function public.inbox_news(text, jsonb) from public, authenticated;
grant execute on function public.inbox_news_state() to anon;
grant execute on function public.inbox_news(text, jsonb) to anon;

-- the summary: requests (p_count) and/or proposals (p_news). The old two-argument version goes, so a call is never ambiguous.
drop function if exists public.inbox_summary(int, text);
create or replace function public.inbox_summary(p_count int, p_text text, p_news int default 0) returns jsonb
language plpgsql security definer set search_path = '' as $$
declare
  v_key text; v_text text := left(btrim(coalesce(p_text, '')), 8000); v_req bigint;
  v_n int := coalesce(p_count, 0); v_w int := coalesce(p_news, 0); v_subj text;
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  if v_text = '' or v_n < 0 or v_w < 0 or v_n + v_w < 1 or v_n > 500 or v_w > 20 then raise exception 'empty'; end if;
  if (select count(*) from public.inbox_log where kind = 'summary' and at > now() - interval '1 day') >= 3 then raise exception 'daily cap'; end if;
  select decrypted_secret into v_key from vault.decrypted_secrets where name = 'resend_api_key' limit 1;
  if v_key is null then raise exception 'no resend key'; end if;
  v_subj := 'RowdyQL · ' || case
    when v_w = 0 then v_n || ' פניות חדשות מחכות לך'
    when v_n = 0 and v_w = 1 then 'הצעה לפרסום מחכה לך'
    when v_n = 0 then v_w || ' הצעות לפרסום מחכות לך'
    else v_n || ' פניות חדשות ' || case when v_w = 1 then 'והצעה לפרסום' else 'ו-' || v_w || ' הצעות לפרסום' end || ' מחכות לך' end;
  select net.http_post(
    url     := 'https://api.resend.com/emails',
    headers := jsonb_build_object('Authorization', 'Bearer ' || v_key, 'Content-Type', 'application/json'),
    body    := jsonb_build_object('from', 'RowdyQL <noreply@rowdyql.com>', 'to', jsonb_build_array('razelbaz1@gmail.com'),
                                  'subject', v_subj, 'text', v_text,
                                  'html', '<div dir="rtl" style="font-family:Arial,Helvetica,sans-serif;font-size:15px;line-height:1.6;color:#373C44;">'
                                          || replace(regexp_replace(public.html_esc(v_text), '(https?://[^\s<"]+)', '<a href="\1">\1</a>', 'g'), E'\n', '<br>') || '</div>'),
    timeout_milliseconds := 20000) into v_req;
  insert into public.inbox_log (kind) values ('summary');
  return jsonb_build_object('request', v_req);
end $$;
revoke execute on function public.inbox_summary(int, text, int) from public, authenticated;
grant execute on function public.inbox_summary(int, text, int) to anon;
