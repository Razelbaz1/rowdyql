-- The inbox routine, stage A (2026-10-20). Run once in the SQL editor; safe to run again.
-- 1. The Vault secret behind the x-inbox header is renamed 'inbox_routine' → 'inbox_header', so it can't be confused with the
--    API key of the same old name (deleted 2026-10-19). The value stays.
-- 2. Two more narrow functions, so the routine also sorts the requests sent from the site's window: read the unsorted ones,
--    and save a draft on one (it then waits for Raz as 'review'). Same guard as the other four: the x-inbox header.

do $$ declare sid uuid; begin
  select s.id into sid from vault.secrets s where s.name = 'inbox_routine';
  if sid is not null and not exists (select 1 from vault.secrets where name = 'inbox_header') then
    perform vault.update_secret(sid, null, 'inbox_header', 'x-inbox header of the daily inbox routine (cloud environment network secret)');
  end if;
end $$;

create or replace function public.inbox_ok() returns boolean language sql stable security definer set search_path = '' as $$
  select coalesce(length(h) >= 32 and h = (select s.decrypted_secret from vault.decrypted_secrets s where s.name = 'inbox_header' limit 1), false)
  from (select nullif(current_setting('request.headers', true), '')::json ->> 'x-inbox' as h) x;
$$;
revoke execute on function public.inbox_ok() from public, anon, authenticated;

-- the requests from the site that nobody sorted yet, oldest first
create or replace function public.inbox_pending() returns table (id bigint, at timestamptz, from_name text, from_email text, user_id uuid,
  inst text, course text, lesson text, page text, subject text, body text)
language plpgsql stable security definer set search_path = '' as $$
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  return query select r.id, r.at, r.from_name, r.from_email, r.user_id, r.inst, r.course, r.lesson, r.page, r.subject, r.body
    from public.requests r where r.status = 'new' and r.source = 'site' order by r.at limit 50;
end $$;

-- a draft on one of them: category, topic, match, decision, reply. Only a 'new' row; it becomes 'review' (waiting for Raz)
create or replace function public.inbox_draft(p_id bigint, p_row jsonb) returns jsonb language plpgsql security definer set search_path = '' as $$
declare v_id bigint;
begin
  if not public.inbox_ok() then raise exception 'no'; end if;
  update public.requests r set
    category   = coalesce(p_row->>'category', r.category),
    topic      = left(coalesce(p_row->>'topic', r.topic), 300),
    match      = left(coalesce(p_row->>'match', r.match), 300),
    decision   = left(coalesce(p_row->>'decision', r.decision), 1000),
    reply_text = left(coalesce(p_row->>'reply_text', r.reply_text), 10000),
    status     = 'review'
  where r.id = p_id and r.status = 'new' returning r.id into v_id;
  if v_id is null then raise exception 'not a new request'; end if;
  return jsonb_build_object('id', v_id, 'status', 'review');
end $$;

revoke execute on function public.inbox_pending() from public, authenticated;
revoke execute on function public.inbox_draft(bigint, jsonb) from public, authenticated;
grant execute on function public.inbox_pending() to anon;
grant execute on function public.inbox_draft(bigint, jsonb) to anon;
