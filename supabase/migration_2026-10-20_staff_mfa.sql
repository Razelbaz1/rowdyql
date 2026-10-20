-- Staff tools require two-step verification (2026-10-20).
-- is_teacher() now also requires a session that passed a code from an authenticator app (aal2). Every staff policy and staff RPC
-- goes through it (profiles, progress, events, notes, notices, notice_reads, leave_feedback, requests, the materials bucket,
-- staff_roster through RLS, send_notice, send_request_reply, set_user_status), so a password alone no longer opens staff data.
-- The site asks for the code before the board (staffOn() in src/page.html); this is the same rule on the server.
-- Apply only after Raz has added a device in the personal area and signed in with a code, or the board locks him out.
-- Not affected: delete_my_account checks the role directly, so a staff account can't be deleted at aal1 either;
-- the inbox routine (x-inbox header), push-tick and cal-feed don't use is_teacher().

create or replace function public.is_teacher()
returns boolean language sql stable security definer set search_path = public as $$
  select coalesce(auth.jwt() ->> 'aal', '') = 'aal2'
     and exists (select 1 from public.profiles where id = auth.uid() and role = 'teacher');
$$;
