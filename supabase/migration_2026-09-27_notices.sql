-- Notifications: the bell on the site, and the same message by email (run once in the SQL editor; safe to run again).
-- Needs pg_net and the Vault secret 'resend_api_key' from the leave_feedback migration. Without the key, messages still reach the bell.
create extension if not exists pg_net;

-- a message from staff to everyone; rows arrive only through send_notice()
create table if not exists public.notices (
  id      bigint generated always as identity primary key,
  at      timestamptz not null default now(),
  title   text not null,
  body    text not null default '',
  emailed int not null default 0,
  author  uuid references auth.users (id) on delete set null
);
alter table public.notices enable row level security;
drop policy if exists notices_read on public.notices;
create policy notices_read on public.notices for select to authenticated using (true);
drop policy if exists notices_staff_delete on public.notices;
create policy notices_staff_delete on public.notices for delete using (public.is_teacher());

-- who opened which message (the unread count on the bell; staff see how many read each one)
create table if not exists public.notice_reads (
  notice_id bigint not null references public.notices (id) on delete cascade,
  user_id   uuid not null default auth.uid() references auth.users (id) on delete cascade,
  at        timestamptz not null default now(),
  primary key (notice_id, user_id)
);
alter table public.notice_reads enable row level security;
drop policy if exists notice_reads_insert_own on public.notice_reads;
create policy notice_reads_insert_own on public.notice_reads for insert with check (user_id = auth.uid());
drop policy if exists notice_reads_select on public.notice_reads;
create policy notice_reads_select on public.notice_reads for select using (user_id = auth.uid() or public.is_teacher());

-- a user can turn the emails off in the personal area; the bell always works
alter table public.profiles add column if not exists notify_email boolean not null default true;

create or replace function public.html_esc(p text)
returns text language sql immutable set search_path = '' as $$
  select replace(replace(replace(coalesce(p, ''), '&', '&amp;'), '<', '&lt;'), '>', '&gt;');
$$;

-- staff only: saves the message for the bell and, if asked, emails it (Resend batch API, 100 per request, sent by pg_net after the commit)
create or replace function public.send_notice(p_title text, p_body text default '', p_email boolean default true)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_title text := left(btrim(coalesce(p_title, '')), 120);
  v_body  text := left(btrim(coalesce(p_body, '')), 2000);
  v_reply constant text := 'hello@rowdyql.com';  -- replies go to Raz (Cloudflare Email Routing)
  v_id bigint; v_key text; v_html text; v_n int := 0; c record;
begin
  if not public.is_teacher() then
    raise exception 'staff only';
  end if;
  if v_title = '' then
    raise exception 'empty title';
  end if;
  insert into public.notices (title, body, author) values (v_title, v_body, auth.uid()) returning id into v_id;

  if p_email then
    begin
      select decrypted_secret into v_key from vault.decrypted_secrets where name = 'resend_api_key' limit 1;
      if v_key is not null then
        v_html := replace(replace(replace($html$<!doctype html>
<html lang="he" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="color-scheme" content="light">
<meta name="supported-color-schemes" content="light">
<title>RowdyQL</title>
</head>
<body style="margin:0;padding:0;background:#F4F7F6;">
<div style="display:none;max-height:0;overflow:hidden;opacity:0;color:transparent;">{{pre}}</div>
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background:#F4F7F6;">
<tr><td align="center" style="padding:32px 16px;">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width:560px;background:#FFFFFF;border:1px solid #D5DEDB;border-radius:16px;overflow:hidden;">
    <tr><td align="center" bgcolor="#0B1416" style="background:#0B1416;padding:26px 24px;">
      <a href="https://rowdyql.com" style="text-decoration:none;"><img src="https://rowdyql.com/email-logo.png" width="240" alt="RowdyQL" style="display:block;border:0;width:240px;max-width:100%;height:auto;color:#FFFFFF;font-family:Arial,Helvetica,sans-serif;font-size:24px;font-weight:bold;"></a>
    </td></tr>
    <tr><td dir="rtl" style="padding:32px 32px 6px;font-family:Arial,Helvetica,sans-serif;text-align:right;color:#15201E;">
      <h1 style="margin:0 0 12px;font-size:24px;line-height:1.3;">{{title}}</h1>
      {{hi}}<div style="font-size:16px;line-height:1.65;color:#3D4B48;">{{body}}</div>
    </td></tr>
    <tr><td align="center" style="padding:24px 32px 26px;">
      <table role="presentation" cellpadding="0" cellspacing="0" border="0"><tr><td align="center" bgcolor="#0E5566" style="border-radius:10px;">
        <a href="https://rowdyql.com" style="display:inline-block;padding:14px 30px;font-family:Arial,Helvetica,sans-serif;font-size:16px;font-weight:bold;color:#FFFFFF;text-decoration:none;border-radius:10px;">כניסה ל-RowdyQL</a>
      </td></tr></table>
    </td></tr>
    <tr><td dir="rtl" style="padding:0 32px 28px;font-family:Arial,Helvetica,sans-serif;text-align:right;">
      <p style="margin:0;font-size:13px;line-height:1.6;color:#93A5A1;">קיבלתם את המייל כי יש לכם חשבון ב-RowdyQL. אפשר לכבות עדכונים במייל באזור האישי באתר.</p>
    </td></tr>
    <tr><td align="center" bgcolor="#0B1416" style="background:#0B1416;padding:14px 16px;font-family:Arial,Helvetica,sans-serif;font-size:12px;color:#93A5A1;">
      RowdyQL &middot; <a href="https://rowdyql.com" style="color:#5CC3D9;text-decoration:none;">rowdyql.com</a>
    </td></tr>
  </table>
</td></tr>
</table>
</body>
</html>$html$,
                    '{{title}}', public.html_esc(v_title)),
                    '{{pre}}', public.html_esc(left(regexp_replace(v_body, '\s+', ' ', 'g'), 110))),
                    '{{body}}', replace(regexp_replace(public.html_esc(v_body), '(https?://[^\s<"]+)', '<a href="\1" style="color:#0E5566;">\1</a>', 'g'), E'\n', '<br>'));
        for c in
          select jsonb_agg(jsonb_build_object('from', 'RowdyQL <noreply@rowdyql.com>', 'to', jsonb_build_array(r.email), 'reply_to', v_reply,
                                              'subject', v_title, 'html', replace(v_html, '{{hi}}', r.hi))) as batch,
                 count(*)::int as n
          from (select u.email,
                       case when coalesce(p.first_name, '') <> ''
                            then '<p style="margin:0 0 12px;font-size:16px;line-height:1.65;color:#3D4B48;">היי ' || public.html_esc(p.first_name) || ',</p>'
                            else '' end as hi,
                       (row_number() over (order by u.created_at) - 1) / 100 as chunk
                from auth.users u join public.profiles p on p.id = u.id
                where u.email is not null and u.email_confirmed_at is not null
                  and coalesce(p.status, 'active') <> 'blocked' and p.notify_email) r
          group by r.chunk
        loop
          perform net.http_post(
            url     := 'https://api.resend.com/emails/batch',
            headers := jsonb_build_object('Authorization', 'Bearer ' || v_key, 'Content-Type', 'application/json'),
            body    := c.batch,
            timeout_milliseconds := 20000);
          v_n := v_n + c.n;
        end loop;
        update public.notices set emailed = v_n where id = v_id;
      end if;
    exception when others then
      v_n := 0;
      raise warning 'notice email skipped: %', sqlerrm;
    end;
  end if;
  return jsonb_build_object('id', v_id, 'emailed', v_n);
end $$;

revoke execute on function public.send_notice(text, text, boolean) from public, anon;
grant execute on function public.send_notice(text, text, boolean) to authenticated;
