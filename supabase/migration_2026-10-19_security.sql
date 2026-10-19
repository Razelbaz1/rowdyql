-- Security round, phase 1 (2026-10-19; the audit of the same day). Run once in the SQL editor; safe to run again.
-- Before: snapshot the policies, functions and grants it touches. After: read them back.
-- The inbox part needs the Vault secret 'inbox_routine' (64 hex), made once by section 7 and copied by Raz into the
-- cloud environment's network secret as the header x-inbox; then the secret API key 'inbox_routine' is deleted.

-- 1. Profile text: no markup in names, and sane lengths. The site escapes everything it shows; this is the second wall.
alter table public.profiles drop constraint if exists profiles_text_safe;
alter table public.profiles add constraint profiles_text_safe check (
  (coalesce(first_name, '') || coalesce(last_name, '') || coalesce(full_name, '')) !~ '[<>[:cntrl:]]'
  and length(coalesce(first_name, '')) <= 40 and length(coalesce(last_name, '')) <= 40 and length(coalesce(full_name, '')) <= 320
  and length(coalesce(institution, '')) <= 200 and length(coalesce(field_of_study, '')) <= 200
  and length(coalesce(goals, '')) <= 2000 and length(coalesce(interests, '')) <= 2000
);

-- 2. Size caps: one synced value at most 256 KB, one event's meta at most 4 KB (the staff board loads them all).
alter table public.progress drop constraint if exists progress_value_size;
alter table public.progress add constraint progress_value_size check (pg_column_size(value) <= 262144);
alter table public.events drop constraint if exists events_meta_size;
alter table public.events add constraint events_meta_size check (meta is null or pg_column_size(meta) <= 4096);

-- 3. A Message-ID goes into mail headers as is, so it must look like one.
alter table public.requests drop constraint if exists requests_message_id_shape;
alter table public.requests add constraint requests_message_id_shape check (message_id is null or message_id = '' or message_id ~ '^<[^<>[:space:]]{1,300}>$');

-- 4. A blocked account: no profile edits, no uploads, no new calendar link or push device, no reminders, no feed.
alter policy profiles_update_own on public.profiles using (id = auth.uid() and public.is_active());

drop policy if exists "materials: students upload to their folder" on storage.objects;
create policy "materials: students upload to their folder" on storage.objects for insert to authenticated
  with check (bucket_id = 'materials' and (storage.foldername(name))[1] = (auth.uid())::text and public.is_active());

create or replace function public.cal_feed(p_token text) returns jsonb language sql stable security definer set search_path = '' as $$
  select coalesce((select pr.value from public.progress pr where pr.user_id = f.user_id and pr.key = 'dbs_cal_out'), '{}'::jsonb)
  from public.cal_feeds f join public.profiles p on p.id = f.user_id
  where f.token = p_token and length(p_token) = 64 and coalesce(p.status, 'active') <> 'blocked';
$$;

create or replace function public.cal_link() returns text language plpgsql security definer set search_path = '' as $$
declare tok text;
begin
  if auth.uid() is null then raise exception 'not signed in'; end if;
  if not public.is_active() then raise exception 'blocked'; end if;
  insert into public.cal_feeds (user_id, token)
    values (auth.uid(), replace(gen_random_uuid()::text, '-', '') || replace(gen_random_uuid()::text, '-', ''))
    on conflict (user_id) do nothing;
  select f.token into tok from public.cal_feeds f where f.user_id = auth.uid();
  return tok;
end $$;

-- 5. Push devices: only the browsers' push services (as in push-tick's PUSH_HOST), at most 5 per account (the oldest goes).
--    An endpoint that moves to another account stays as before: one browser, the account that signed in last.
create or replace function public.push_sub_save(p_endpoint text, p_p256dh text, p_auth text, p_ua text default '') returns void
language plpgsql security definer set search_path = '' as $$
begin
  if auth.uid() is null then raise exception 'not signed in'; end if;
  if not public.is_active() then raise exception 'blocked'; end if;
  if length(p_endpoint) > 1000 or length(p_p256dh) > 200 or length(p_auth) > 100
     or p_endpoint !~ '^https://(fcm\.googleapis\.com|updates\.push\.services\.mozilla\.com|web\.push\.apple\.com|[a-z0-9-]+\.notify\.windows\.com)/' then
    raise exception 'bad subscription';
  end if;
  insert into public.push_subs (endpoint, user_id, p256dh, auth, ua) values (p_endpoint, auth.uid(), p_p256dh, p_auth, left(coalesce(p_ua, ''), 300))
    on conflict (endpoint) do update set user_id = auth.uid(), p256dh = excluded.p256dh, auth = excluded.auth, ua = excluded.ua;
  delete from public.push_subs where user_id = auth.uid() and endpoint in (
    select s.endpoint from public.push_subs s where s.user_id = auth.uid() order by s.created_at desc offset 5);
end $$;

create or replace function public.push_data(p_secret text) returns jsonb language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.push_ok(p_secret) then raise exception 'no'; end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object('u', u.user_id, 'subs', u.subs, 'cal', c.value, 'days', coalesce(d.value, '[]'::jsonb)))
    from (select ps.user_id, jsonb_agg(jsonb_build_object('e', ps.endpoint, 'p', ps.p256dh, 'a', ps.auth)) as subs from public.push_subs ps group by ps.user_id) u
    join public.profiles pf on pf.id = u.user_id and coalesce(pf.status, 'active') <> 'blocked'
    join public.progress c on c.user_id = u.user_id and c.key = 'dbs_cal_out'
    left join public.progress d on d.user_id = u.user_id and d.key = 'dbs_days'), '[]'::jsonb);
end $$;

-- 6. Grants: anon reaches no table directly (the site's guest needs none; cal_feed and the push functions run as their owner).
--    authenticated keeps select/insert/update/delete under RLS, and loses truncate/references/trigger.
--    Trigger functions can't be called over the API at all.
revoke all on all tables in schema public from anon;
revoke truncate, references, trigger on all tables in schema public from authenticated;
alter default privileges in schema public revoke all on tables from anon;
revoke execute on function public.handle_new_user() from public, anon, authenticated;
revoke execute on function public.rls_auto_enable() from public, anon, authenticated;
revoke execute on function public.requests_touch() from public, anon, authenticated;
revoke execute on function public.set_user_status(uuid, text, text) from public, anon;
grant execute on function public.set_user_status(uuid, text, text) to authenticated;
revoke execute on function public.cal_link() from public, anon;
grant execute on function public.cal_link() to authenticated;
revoke execute on function public.push_sub_save(text, text, text, text) from public, anon;
grant execute on function public.push_sub_save(text, text, text, text) to authenticated;

-- 7. The daily inbox routine: four narrow functions instead of a key that opens everything.
--    The routine's proxy adds the header x-inbox (the Vault secret 'inbox_routine') to every call to our host;
--    the routine itself sends only the public publishable key. Nothing else in the database is reachable with it.
do $$ begin
  if not exists (select 1 from vault.secrets where name = 'inbox_routine') then
    perform vault.create_secret(encode(extensions.gen_random_bytes(32), 'hex'), 'inbox_routine', 'x-inbox header of the daily inbox routine (cloud environment network secret)');
  end if;
end $$;

create or replace function public.inbox_ok() returns boolean language sql stable security definer set search_path = '' as $$
  select coalesce(length(h) >= 32 and h = (select s.decrypted_secret from vault.decrypted_secrets s where s.name = 'inbox_routine' limit 1), false)
  from (select nullif(current_setting('request.headers', true), '')::json ->> 'x-inbox' as h) x;
$$;
revoke execute on function public.inbox_ok() from public, anon, authenticated;

-- which of these Gmail threads are in already
create or replace function public.inbox_seen(p_threads text[]) returns table (id bigint, gmail_thread text, status text)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  return query select r.id, r.gmail_thread, r.status from public.requests r where r.gmail_thread = any (p_threads);
end $$;

-- who wrote: only what a reply needs (first name, institution, field, the plan), for an account with that email
create or replace function public.inbox_who(p_email text) returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare r jsonb;
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  select jsonb_build_object('user_id', p.id, 'first_name', p.first_name, 'institution', p.institution, 'field_of_study', p.field_of_study,
                            'plan', (select pr.value from public.progress pr where pr.user_id = p.id and pr.key = 'dbs_plan'))
    into r from public.profiles p where lower(p.email) = lower(btrim(p_email)) limit 1;
  return coalesce(r, '{}'::jsonb);
end $$;

-- a new request, always in review; only these fields can be set
create or replace function public.inbox_add(p_row jsonb) returns jsonb language plpgsql security definer set search_path = '' as $$
declare v_id bigint;
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  insert into public.requests (at, gmail_thread, message_id, from_name, from_email, subject, body, user_id, inst, course, category, topic, match, decision, reply_subject, reply_text, status)
  values (coalesce((p_row->>'at')::timestamptz, now()), p_row->>'gmail_thread', coalesce(p_row->>'message_id', ''),
          left(coalesce(p_row->>'from_name', ''), 200), left(p_row->>'from_email', 320), left(coalesce(p_row->>'subject', ''), 500), left(coalesce(p_row->>'body', ''), 20000),
          (select u.id from auth.users u where u.id = nullif(p_row->>'user_id', '')::uuid),
          left(coalesce(p_row->>'inst', ''), 200), left(coalesce(p_row->>'course', ''), 200), coalesce(p_row->>'category', 'other'),
          left(coalesce(p_row->>'topic', ''), 300), left(coalesce(p_row->>'match', ''), 300), left(coalesce(p_row->>'decision', ''), 1000),
          left(coalesce(p_row->>'reply_subject', ''), 500), left(coalesce(p_row->>'reply_text', ''), 10000), 'review')
  returning id into v_id;
  return (select jsonb_build_object('id', r.id, 'gmail_thread', r.gmail_thread, 'category', r.category, 'status', r.status) from public.requests r where r.id = v_id);
end $$;

-- a follow-up in a thread that is in already: the new text, back to review
create or replace function public.inbox_followup(p_thread text, p_body text) returns jsonb language plpgsql security definer set search_path = '' as $$
declare v_id bigint;
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  update public.requests set body = left(coalesce(p_body, ''), 20000), status = 'review' where gmail_thread = p_thread returning id into v_id;
  if v_id is null then raise exception 'no such thread'; end if;
  return jsonb_build_object('id', v_id, 'status', 'review');
end $$;

revoke execute on function public.inbox_seen(text[]) from public, authenticated;
revoke execute on function public.inbox_who(text) from public, authenticated;
revoke execute on function public.inbox_add(jsonb) from public, authenticated;
revoke execute on function public.inbox_followup(text, text) from public, authenticated;
grant execute on function public.inbox_seen(text[]) to anon;
grant execute on function public.inbox_who(text) to anon;
grant execute on function public.inbox_add(jsonb) to anon;
grant execute on function public.inbox_followup(text, text) to anon;
