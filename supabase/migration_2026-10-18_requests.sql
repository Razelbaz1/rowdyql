-- The requests desk (run once in the SQL editor; safe to run again).
-- Needs pg_net and the Vault secret 'resend_api_key' (the leave_feedback migration), and public.is_teacher().
create extension if not exists pg_net;

-- one row per message to hello@rowdyql.com. The inbox agent writes the rows (service role); only staff can read or change them.
create table if not exists public.requests (
  id            bigint generated always as identity primary key,
  at            timestamptz not null default now(),          -- when the message arrived
  gmail_thread  text unique,                                  -- the agent's handle on the Gmail thread
  message_id    text,                                         -- the student's Message-ID header, so the reply lands in their thread
  from_name     text not null default '',
  from_email    text not null,
  subject       text not null default '',
  body          text not null default '',
  user_id       uuid references auth.users (id) on delete set null,  -- a RowdyQL account with that email, if there is one
  inst          text not null default '',
  course        text not null default '',
  category      text not null default 'other'
                check (category in ('exists', 'building', 'questions', 'new_topic', 'out_of_scope', 'other')),
  topic         text not null default '',                     -- the topic as the agent understood it
  match         text not null default '',                     -- where it already is on the site (a lesson), if anywhere
  decision      text not null default '',                     -- the agent's proposed decision, in one or two lines
  reply_subject text not null default '',
  reply_text    text not null default '',                     -- the drafted reply, plain text; Raz may edit it before sending
  status        text not null default 'review'
                check (status in ('review', 'discussion', 'sent', 'closed')),
  note          text not null default '',                     -- Raz's note
  sent_at       timestamptz,
  sent_by       uuid references auth.users (id) on delete set null,
  updated_at    timestamptz not null default now()
);
create index if not exists requests_status_at on public.requests (status, at desc);
alter table public.requests enable row level security;
drop policy if exists requests_staff on public.requests;
create policy requests_staff on public.requests for all using (public.is_teacher()) with check (public.is_teacher());
revoke all on public.requests from anon;

create or replace function public.requests_touch() returns trigger language plpgsql set search_path = '' as $$
begin new.updated_at := now(); return new; end $$;
drop trigger if exists requests_touch on public.requests;
create trigger requests_touch before update on public.requests for each row execute function public.requests_touch();

-- staff only: sends the reply (after Raz's click in the board) from hello@ through Resend, in the student's thread, with a copy to hello@
-- (Raz's Gmail, through Cloudflare Email Routing). p_text, when given, replaces the draft first.
create or replace function public.send_request_reply(p_id bigint, p_text text default null)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  r public.requests; v_key text; v_text text; v_html text; v_subj text; v_hdr jsonb := '{}'::jsonb; v_req bigint;
begin
  if not public.is_teacher() then
    raise exception 'staff only';
  end if;
  select * into r from public.requests where id = p_id for update;
  if not found then
    raise exception 'no such request';
  end if;
  if r.status = 'sent' then
    raise exception 'already sent';
  end if;
  v_text := btrim(coalesce(p_text, r.reply_text));
  if v_text = '' then
    raise exception 'empty reply';
  end if;
  select decrypted_secret into v_key from vault.decrypted_secrets where name = 'resend_api_key' limit 1;
  if v_key is null then
    raise exception 'no resend key';
  end if;
  v_subj := coalesce(nullif(btrim(r.reply_subject), ''), case when r.subject ~* '^re:' then r.subject else 'Re: ' || coalesce(nullif(r.subject, ''), 'RowdyQL') end);
  if coalesce(r.message_id, '') <> '' then
    v_hdr := jsonb_build_object('In-Reply-To', r.message_id, 'References', r.message_id);
  end if;
  v_html := replace(replace($html$<!DOCTYPE html>
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
  <div style="display:none; max-height:0; overflow:hidden; opacity:0; color:transparent;">{{pre}}</div>
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
              <div style="margin:0 0 14px;font-size:16px;line-height:1.65;color:#373C44;">{{body}}</div>
            </td>
          </tr>
          <tr>
            <td class="pad" dir="rtl" bgcolor="#F7F2EC" style="background:#F7F2EC; border-top:1px solid #DDD7CF; padding:18px 32px; text-align:right;">
              <div style="font-family:'Heebo',Arial,Helvetica,sans-serif; font-size:13px; line-height:1.6; color:#5F6670;">זו תשובה לפנייה ששלחתם ל-RowdyQL. אפשר פשוט להשיב למייל הזה.</div>
              <div dir="ltr" style="font-family:'Heebo',Arial,Helvetica,sans-serif; font-size:13px; line-height:1.6; color:#5F6670;">RowdyQL · <a href="https://rowdyql.com" style="color:#20778A; text-decoration:none;">rowdyql.com</a></div>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>$html$,
              '{{pre}}', public.html_esc(left(regexp_replace(v_text, '\s+', ' ', 'g'), 110))),
              '{{body}}', replace(regexp_replace(public.html_esc(v_text), '(https?://[^\s<"]+)', '<a href="\1" style="color:#20778A;">\1</a>', 'g'), E'\n', '<br>'));
  select net.http_post(
    url     := 'https://api.resend.com/emails',
    headers := jsonb_build_object('Authorization', 'Bearer ' || v_key, 'Content-Type', 'application/json'),
    body    := jsonb_build_object('from', 'RowdyQL <hello@rowdyql.com>', 'to', jsonb_build_array(r.from_email), 'bcc', jsonb_build_array('hello@rowdyql.com'),
                                  'reply_to', 'hello@rowdyql.com', 'subject', v_subj, 'html', v_html, 'text', v_text, 'headers', v_hdr),
    timeout_milliseconds := 20000) into v_req;
  update public.requests set reply_text = v_text, reply_subject = v_subj, status = 'sent', sent_at = now(), sent_by = auth.uid() where id = p_id;
  return jsonb_build_object('id', p_id, 'request', v_req);
end $$;

revoke execute on function public.send_request_reply(bigint, text) from public, anon;
grant execute on function public.send_request_reply(bigint, text) to authenticated;
