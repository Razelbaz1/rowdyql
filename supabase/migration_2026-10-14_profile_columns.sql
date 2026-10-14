-- profiles: a user may update only their own personal details, onboarding answers and email setting.
-- Status, role, email and consent change only through the staff function set_user_status, delete_my_account
-- and the sign-up trigger (all security definer), so a blocked account can no longer release itself. Run once; safe to run again.
revoke update on public.profiles from anon, authenticated;
grant update (full_name, first_name, last_name, birth_date, gender, study_year, semester, goals, interests,
              studying, institution, field_of_study, level, onboarded_at, notify_email)
  on public.profiles to authenticated;
