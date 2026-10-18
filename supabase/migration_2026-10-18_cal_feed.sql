-- The calendar link that updates itself (run once in the SQL editor; safe to run again).
-- The site writes the student's sessions to the progress key 'dbs_cal_out', and only after they confirm the calendar (one copy of the
-- schedule: the site's calSched). cal_link() hands the signed-in student their secret token. The Edge Function cal-feed calls
-- cal_feed(token) with the public key and serves those sessions as a calendar. Nothing here decides who gets what.

-- one secret per student; no policies, so only the two functions below reach it
create table if not exists public.cal_feeds (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  token      text not null unique,
  created_at timestamptz not null default now()
);
alter table public.cal_feeds enable row level security;
revoke all on public.cal_feeds from anon, authenticated;

-- the student's token, made on first use (64 hex characters from two random UUIDs)
create or replace function public.cal_link() returns text language plpgsql security definer set search_path = '' as $$
declare tok text;
begin
  if auth.uid() is null then raise exception 'not signed in'; end if;
  insert into public.cal_feeds (user_id, token)
    values (auth.uid(), replace(gen_random_uuid()::text, '-', '') || replace(gen_random_uuid()::text, '-', ''))
    on conflict (user_id) do nothing;
  select f.token into tok from public.cal_feeds f where f.user_id = auth.uid();
  return tok;
end $$;
revoke all on function public.cal_link() from public, anon;
grant execute on function public.cal_link() to authenticated;

-- the sessions behind a token: null for an unknown token, {} before the site wrote any
create or replace function public.cal_feed(p_token text) returns jsonb language sql stable security definer set search_path = '' as $$
  select coalesce((select pr.value from public.progress pr where pr.user_id = f.user_id and pr.key = 'dbs_cal_out'), '{}'::jsonb)
  from public.cal_feeds f where f.token = p_token and length(p_token) = 64;
$$;
revoke all on function public.cal_feed(text) from public;
grant execute on function public.cal_feed(text) to anon, authenticated;
