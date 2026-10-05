-- Leaving: anonymous reasons + a goodbye email, in the same step as the account deletion (run once in the SQL editor; safe to run again).
-- Before it: (1) Database -> Extensions -> enable pg_net (the line below does the same);
--            (2) store the Resend API key in Vault once:  select vault.create_secret('re_...', 'resend_api_key');
-- Without the key the deletion still works, only the goodbye email is skipped.
create extension if not exists pg_net;

-- reasons people give when they delete their account; no user id, no name, no email
create table if not exists public.leave_feedback (
  id      bigint generated always as identity primary key,
  at      timestamptz not null default now(),
  reasons text[] not null default '{}',
  note    text
);
alter table public.leave_feedback enable row level security;
drop policy if exists leave_feedback_staff on public.leave_feedback;
create policy leave_feedback_staff on public.leave_feedback for select using (public.is_teacher());
-- no insert policy: rows arrive only through delete_my_account()

drop function if exists public.delete_my_account();
create or replace function public.delete_my_account(p_reasons text[] default '{}', p_note text default null)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  uid uuid := auth.uid();
  v_email text; v_first text; v_key text; v_hi text;
  v_reply constant text := 'hello@rowdyql.com';  -- where replies to the goodbye email go (see supabase/email/README.md)
begin
  if uid is null then
    raise exception 'not signed in';
  end if;
  if exists (select 1 from public.profiles where id = uid and role = 'teacher') then
    raise exception 'staff accounts are not deleted from the site';
  end if;
  select email into v_email from auth.users where id = uid;
  select first_name into v_first from public.profiles where id = uid;

  insert into public.leave_feedback (reasons, note)
  values (array(select r from unnest(coalesce(p_reasons, '{}'::text[])) as r where r in ('content','easy','hard','done','tech','other')),
          nullif(left(trim(coalesce(p_note, '')), 1000), ''));

  -- goodbye email through Resend (sent by pg_net after the commit); a problem here never blocks the deletion
  begin
    select decrypted_secret into v_key from vault.decrypted_secrets where name = 'resend_api_key' limit 1;
    if v_key is not null and v_email is not null then
      v_hi := case when coalesce(v_first, '') <> ''
                   then 'היי ' || replace(replace(replace(v_first, '&', '&amp;'), '<', '&lt;'), '>', '&gt;') || ', '
                   else '' end;
      perform net.http_post(
        url     := 'https://api.resend.com/emails',
        headers := jsonb_build_object('Authorization', 'Bearer ' || v_key, 'Content-Type', 'application/json'),
        body    := jsonb_build_object('from', 'RowdyQL <noreply@rowdyql.com>', 'to', v_email, 'reply_to', v_reply, 'subject', 'להתראות מ-RowdyQL',
                                      'html', replace($html$<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="x-apple-disable-message-reformatting">
<meta name="color-scheme" content="light">
<meta name="supported-color-schemes" content="light">
<title>RowdyQL</title>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@800;900&family=Heebo:wght@400;500;700&family=IBM+Plex+Mono:wght@400;500&family=Noto+Sans+Math&display=swap" rel="stylesheet">
<style>
  body { margin:0; padding:0; background:#F7F2EC; -webkit-text-size-adjust:100%; }
  table { border-collapse:collapse; }
  img { border:0; line-height:100%; outline:none; text-decoration:none; }
  a { color:#20778A; }
  @media (max-width:640px){ .container{ width:100% !important; } .pad{ padding-left:20px !important; padding-right:20px !important; } }
</style>
</head>
<body style="margin:0; padding:0; background:#F7F2EC;">
  <div style="display:none; max-height:0; overflow:hidden; opacity:0; color:transparent;">החשבון נמחק. תודה שבחרתם ללמוד איתנו.</div>
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#F7F2EC" style="background:#F7F2EC;">
    <tr>
      <td align="center" style="padding:28px 12px;">
        <table role="presentation" class="container" width="600" cellpadding="0" cellspacing="0" border="0" style="width:600px; max-width:600px; background:#FDFBF8; border:1px solid #DDD7CF; border-radius:8px; border-collapse:separate; box-shadow:none;">
          <tr>
            <td class="pad" dir="rtl" style="padding:24px 32px 20px 32px; border-bottom:1px solid #DDD7CF; text-align:right;">
              <a href="https://rowdyql.com" style="text-decoration:none;"><img src="https://rowdyql.com/email-logo-light.png" width="240" alt="RowdyQL" style="display:inline-block; width:240px; max-width:100%; height:auto; border:0; color:#373C44; font-family:'Rubik',Arial,Helvetica,sans-serif; font-weight:800; font-size:24px;"></a>
            </td>
          </tr>
          <tr>
            <td class="pad" dir="rtl" style="padding:32px 32px 24px 32px; font-family:'Heebo','Rubik',Arial,Helvetica,sans-serif; color:#373C44; font-size:16px; line-height:1.65; text-align:right;">
              <h1 style="margin:0 0 12px;font-family:'Rubik',Arial,Helvetica,sans-serif;font-weight:800;font-size:24px;line-height:1.3;color:#373C44;">להתראות, ותודה</h1>
              <p style="margin:0 0 14px;font-size:16px;line-height:1.65;color:#373C44;">{{hi}}החשבון שלכם ב-RowdyQL נמחק.</p>
              <p style="margin:0 0 14px;font-size:16px;line-height:1.65;color:#373C44;">תודה שבחרתם ללמוד איתנו. נשמח לשמוע מכם איך הייתה חוויית הלמידה, כדי שנוכל להשתפר. אפשר פשוט להשיב למייל הזה.</p>
              <p style="margin:0 0 14px;font-size:16px;line-height:1.65;color:#373C44;">אם תרצו לחזור בעתיד, תמיד אפשר להירשם מחדש. נשמח לראות אתכם שוב.</p>
              <table role="presentation" cellpadding="0" cellspacing="0" border="0" style="margin:8px 0 22px;"><tr><td bgcolor="#20778A" style="background:#20778A;border-radius:8px;"><a href="https://rowdyql.com" style="display:inline-block;border-radius:8px;padding:14px 28px;font-family:'Heebo',Arial,Helvetica,sans-serif;font-size:16px;font-weight:700;color:#FDFBF8;text-decoration:none;">RowdyQL</a></td></tr></table>
            </td>
          </tr>
          <tr>
            <td class="pad" dir="rtl" bgcolor="#F7F2EC" style="background:#F7F2EC; border-top:1px solid #DDD7CF; padding:18px 32px; text-align:right;">
              <div style="font-family:'Heebo',Arial,Helvetica,sans-serif; font-size:13px; line-height:1.6; color:#5F6670;">המייל הזה נשלח פעם אחת, כאישור למחיקה. לא יישלחו אליכם מיילים נוספים.</div>
              <div dir="ltr" style="font-family:'Heebo',Arial,Helvetica,sans-serif; font-size:13px; line-height:1.6; color:#5F6670;">RowdyQL · <a href="https://rowdyql.com" style="color:#20778A; text-decoration:none;">rowdyql.com</a></div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>$html$, '{{hi}}', v_hi)));
    end if;
  exception when others then
    null;
  end;

  delete from auth.users where id = uid;  -- profile, progress, events and notes follow (on delete cascade)
end;
$$;

revoke all on function public.delete_my_account(text[], text) from public;
revoke all on function public.delete_my_account(text[], text) from anon;
grant execute on function public.delete_my_account(text[], text) to authenticated;
