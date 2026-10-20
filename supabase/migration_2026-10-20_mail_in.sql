-- The separate inbox, stage B (2026-10-20). Mail to hello@rowdyql.com goes Cloudflare Email Routing → the Worker
-- rowdyql-mail-in (a copy to Raz's Gmail) → the Edge Function mail-in (parses it) → mail_add() here, into public.requests as 'new'.
-- The inbox routine then reads only inbox_pending() and never opens Gmail; its daily summary goes out through inbox_summary(),
-- to Raz's address only. Run once in the SQL editor; safe to run again.

-- 1. The Worker's key. Only its sha256 is here: the key itself lives in the Worker (secret MAIL_KEY) and nowhere else.
create or replace function public.mail_ok() returns boolean language sql stable security definer set search_path = '' as $$
  select coalesce(length(h) >= 32 and encode(extensions.digest(h, 'sha256'), 'hex') = 'b258a8332a9fb59c5a26d6cfe3cdf9110a81d41964017ef269493aa40f8e9bfc', false)
  from (select nullif(current_setting('request.headers', true), '')::json ->> 'x-mail' as h) x;
$$;
revoke execute on function public.mail_ok() from public, anon, authenticated;

-- 2. One message in. A new request ('new', for the routine), or, when it answers a request from the same sender (In-Reply-To or
--    References name its message_id), that request again: the reply we sent and the new text go under the old body, and it
--    becomes 'new' so the routine drafts the next reply. Our own mail is skipped, a retry of the same message is a no-op,
--    and more than 200 messages a day stop at the door (a flood; the copies are still in Gmail).
create or replace function public.mail_add(p jsonb) returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_from text := lower(btrim(left(coalesce(p->>'from_email', ''), 320)));
  v_mid  text := left(coalesce(p->>'message_id', ''), 500);
  v_body text := left(regexp_replace(coalesce(p->>'body', ''), '[\x01-\x08\x0B\x0C\x0E-\x1F\x7F]', '', 'g'), 10000);
  v_refs text[]; v_id bigint; r public.requests; v_when text := to_char(now() at time zone 'Asia/Jerusalem', 'DD.MM.YYYY HH24:MI');
begin
  if not public.mail_ok() then raise exception 'no'; end if;
  if v_from !~ '^[^@\s]+@[^@\s]+\.[^@\s]+$' then raise exception 'bad sender'; end if;
  if v_from in ('hello@rowdyql.com', 'noreply@rowdyql.com') then return jsonb_build_object('skipped', 'own'); end if;
  if v_mid <> '' then
    select id into v_id from public.requests where message_id = v_mid limit 1;
    if v_id is not null then return jsonb_build_object('id', v_id, 'dup', true); end if;
  end if;
  if (select count(*) from public.requests where source = 'mail' and at > now() - interval '1 day') >= 200 then raise exception 'daily cap'; end if;
  select coalesce(array_agg(left(x, 500)), '{}') into v_refs from (select jsonb_array_elements_text(coalesce(p->'refs', '[]'::jsonb)) x limit 50) s;
  if cardinality(v_refs) > 0 then
    select * into r from public.requests q where q.message_id = any (v_refs) and lower(q.from_email) = v_from order by q.at desc limit 1;
    if found then
      update public.requests set
        body = left(body
          || case when status = 'sent' and reply_text <> '' then E'\n\n— התשובה שנשלחה' || coalesce(' (' || to_char(sent_at at time zone 'Asia/Jerusalem', 'DD.MM.YYYY HH24:MI') || ')', '') || E' —\n' || reply_text else '' end
          || E'\n\n— הודעה נוספת (' || v_when || E') —\n' || v_body, 20000),
        message_id = case when v_mid <> '' then v_mid else message_id end,
        status = 'new'
      where id = r.id;
      return jsonb_build_object('id', r.id, 'followup', true);
    end if;
  end if;
  insert into public.requests (at, message_id, from_name, from_email, subject, body, user_id, inst, course, category, status, source)
  select now(), v_mid, left(coalesce(nullif(btrim(p->>'from_name'), ''), pr.full_name, ''), 200), v_from,
         left(regexp_replace(coalesce(p->>'subject', ''), '[[:cntrl:]]', ' ', 'g'), 500), v_body,
         u.id, coalesce(pr.institution, ''), coalesce(pr.field_of_study, ''), 'other', 'new', 'mail'
  from (select 1) one
  left join auth.users u on lower(u.email) = v_from
  left join public.profiles pr on pr.id = u.id
  limit 1
  returning id into v_id;
  return jsonb_build_object('id', v_id);
end $$;
revoke execute on function public.mail_add(jsonb) from public, authenticated;
grant execute on function public.mail_add(jsonb) to anon;

-- 3. The routine's list: every unsorted request, from the site or by mail, oldest first, with the student's plan when they have an
--    account (so it needs no inbox_who for them). The return columns changed, so it is dropped first.
drop function if exists public.inbox_pending();
create function public.inbox_pending() returns table (id bigint, at timestamptz, source text, from_name text, from_email text, user_id uuid,
  inst text, course text, lesson text, page text, subject text, body text, plan jsonb)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  return query select r.id, r.at, r.source, r.from_name, r.from_email, r.user_id, r.inst, r.course, r.lesson, r.page, r.subject, r.body,
    (select pr.value from public.progress pr where pr.user_id = r.user_id and pr.key = 'dbs_plan')
    from public.requests r where r.status = 'new' order by r.at limit 50;
end $$;
revoke execute on function public.inbox_pending() from public, authenticated;
grant execute on function public.inbox_pending() to anon;

-- 4. The routine's daily summary, now without Gmail: Resend, to Raz only (the address is fixed here, so the routine can't
--    send anywhere else), at most 3 a day. The text is the routine's plain Hebrew lines.
create table if not exists public.inbox_log (at timestamptz not null default now(), kind text not null);
alter table public.inbox_log enable row level security;
revoke all on public.inbox_log from anon, authenticated;

create or replace function public.inbox_summary(p_count int, p_text text) returns jsonb language plpgsql security definer set search_path = '' as $$
declare v_key text; v_text text := left(btrim(coalesce(p_text, '')), 8000); v_req bigint;
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  if v_text = '' or coalesce(p_count, 0) < 1 or p_count > 500 then raise exception 'empty'; end if;
  if (select count(*) from public.inbox_log where kind = 'summary' and at > now() - interval '1 day') >= 3 then raise exception 'daily cap'; end if;
  select decrypted_secret into v_key from vault.decrypted_secrets where name = 'resend_api_key' limit 1;
  if v_key is null then raise exception 'no resend key'; end if;
  select net.http_post(
    url     := 'https://api.resend.com/emails',
    headers := jsonb_build_object('Authorization', 'Bearer ' || v_key, 'Content-Type', 'application/json'),
    body    := jsonb_build_object('from', 'RowdyQL <noreply@rowdyql.com>', 'to', jsonb_build_array('razelbaz1@gmail.com'),
                                  'subject', 'RowdyQL · ' || p_count || ' פניות חדשות מחכות לך', 'text', v_text,
                                  'html', '<div dir="rtl" style="font-family:Arial,Helvetica,sans-serif;font-size:15px;line-height:1.6;color:#373C44;">'
                                          || replace(regexp_replace(public.html_esc(v_text), '(https?://[^\s<"]+)', '<a href="\1">\1</a>', 'g'), E'\n', '<br>') || '</div>'),
    timeout_milliseconds := 20000) into v_req;
  insert into public.inbox_log (kind) values ('summary');
  return jsonb_build_object('request', v_req);
end $$;
revoke execute on function public.inbox_summary(int, text) from public, authenticated;
grant execute on function public.inbox_summary(int, text) to anon;
