-- The separate inbox, a fix after the first real test (2026-10-20). A reply joins its request by In-Reply-To / References, but
-- some mail programs send a reply without them, and a student may answer by writing a new mail with "Re:" in the subject.
-- So when no reference matches and the subject starts with a reply prefix, the latest request from the same sender with the
-- same subject (prefixes stripped), from the last 60 days, gets it. That also catches replies to requests sent from the site
-- (their reply goes out as "Re: <subject>"). Run once in the SQL editor; safe to run again.

-- a subject without its reply and forward prefixes, for matching
create or replace function public.mail_subj(s text) returns text language sql immutable set search_path = '' as $$
  select lower(btrim(regexp_replace(coalesce(s, ''), '^(\s*(re|fw|fwd|aw|sv|השב|תשובה|הועבר)\s*:\s*)+', '', 'i')));
$$;
revoke execute on function public.mail_subj(text) from public, anon, authenticated;

create or replace function public.mail_add(p jsonb) returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_from text := lower(btrim(left(coalesce(p->>'from_email', ''), 320)));
  v_mid  text := left(coalesce(p->>'message_id', ''), 500);
  v_subj text := left(regexp_replace(coalesce(p->>'subject', ''), '[[:cntrl:]]', ' ', 'g'), 500);
  v_body text := left(regexp_replace(coalesce(p->>'body', ''), '[\x01-\x08\x0B\x0C\x0E-\x1F\x7F]', '', 'g'), 10000);
  v_refs text[]; v_id bigint; v_hit bigint; v_when text := to_char(now() at time zone 'Asia/Jerusalem', 'DD.MM.YYYY HH24:MI');
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
  -- the request it answers: by its references first, then by a "Re:" subject from the same sender
  if cardinality(v_refs) > 0 then
    select q.id into v_hit from public.requests q where q.message_id = any (v_refs) and lower(q.from_email) = v_from order by q.at desc limit 1;
  end if;
  if v_hit is null and v_subj ~* '^\s*(re|aw|sv|השב|תשובה)\s*:' and public.mail_subj(v_subj) <> '' then
    select q.id into v_hit from public.requests q
     where lower(q.from_email) = v_from and q.at > now() - interval '60 days' and public.mail_subj(q.subject) = public.mail_subj(v_subj)
     order by q.at desc limit 1;
  end if;
  if v_hit is not null then
    update public.requests set
      body = left(body
        || case when status = 'sent' and reply_text <> '' then E'\n\n— התשובה שנשלחה' || coalesce(' (' || to_char(sent_at at time zone 'Asia/Jerusalem', 'DD.MM.YYYY HH24:MI') || ')', '') || E' —\n' || reply_text else '' end
        || E'\n\n— הודעה נוספת (' || v_when || E') —\n' || v_body, 20000),
      message_id = case when v_mid <> '' then v_mid else message_id end,
      status = 'new'
    where id = v_hit;
    return jsonb_build_object('id', v_hit, 'followup', true);
  end if;
  insert into public.requests (at, message_id, from_name, from_email, subject, body, user_id, inst, course, category, status, source)
  select now(), v_mid, left(coalesce(nullif(btrim(p->>'from_name'), ''), pr.full_name, ''), 200), v_from, v_subj, v_body,
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
