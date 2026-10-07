-- Gender at sign-up: required in the wizard, M or F. Kept as data; the site keeps plural address.
-- handle_new_user copies it from the sign-up metadata, and the dashboard roster shows it. Run once; safe to run again.
alter table public.profiles add column if not exists gender text;
alter table public.profiles drop constraint if exists profiles_gender_check;
alter table public.profiles add constraint profiles_gender_check check (gender in ('M','F'));

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
declare m jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
begin
  insert into public.profiles (id, email, full_name, first_name, last_name, birth_date, gender, study_year, semester, goals, interests, consent_at, consent_version)
  values (
    new.id,
    new.email,
    coalesce(nullif(m->>'full_name',''), trim(coalesce(m->>'first_name','') || ' ' || coalesce(m->>'last_name','')), new.email),
    nullif(m->>'first_name',''),
    nullif(m->>'last_name',''),
    nullif(m->>'birth_date','')::date,
    case when m->>'gender' in ('M','F') then m->>'gender' end,
    nullif(m->>'study_year','')::smallint,
    nullif(m->>'semester',''),
    nullif(m->>'goals',''),
    nullif(m->>'interests',''),
    coalesce((m->>'consent_at')::timestamptz, now()),
    coalesce(m->>'consent_version', 'unknown')
  ) on conflict (id) do nothing;
  insert into public.events (user_id, kind) values (new.id, 'signup');
  return new;
end $$;

-- the dashboard roster shows gender
drop view if exists public.staff_roster;
create view public.staff_roster with (security_invoker = true) as
  select p.id, p.email, p.full_name, p.first_name, p.last_name, p.birth_date, p.gender, p.study_year, p.semester, p.goals, p.interests, p.created_at,
         (select count(*) from public.progress pr where pr.user_id = p.id) as progress_keys,
         (select max(updated_at) from public.progress pr where pr.user_id = p.id) as last_active,
         (select count(*) from public.events e where e.user_id = p.id and e.kind = 'visit') as visits,
         (select max(at) from public.events e where e.user_id = p.id and e.kind = 'visit') as last_visit,
         (select n.text from public.notes n where n.user_id = p.id) as note,
         p.status, p.status_note, p.status_at,
         p.studying, p.institution, p.field_of_study, p.level, p.onboarded_at
  from public.profiles p;
