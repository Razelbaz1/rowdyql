---
name: rowdyql-inbox
description: Sort the RowdyQL requests inbox (hello@rowdyql.com) for Raz. Reads new student emails in Gmail, always checks first whether the topic already exists on the site, sorts each one (exists, being built, questions for a topic, new topic, out of scope, other), drafts a personal reply in the site's voice, and fills the requests form that Raz reads and sends from the staff board ("פניות"). Also runs a discussion about one request when Raz pastes the prompt the board copies. Hebrew cues - "תמיין את הפניות", "יש פניות חדשות?", "תבדוק את התיבה", "דיון על פנייה", "פניות". Also "inbox", "requests".
---

# The RowdyQL requests inbox

Students write to **hello@rowdyql.com**. Cloudflare Email Routing forwards it to Raz's Gmail. This skill sorts the mail. It never sends a reply and never builds content. Raz reads every reply in the staff board (the "פניות" tab) and sends it with one click. The click calls `send_request_reply`, which sends from hello@ through Resend, in the student's thread. There is no copy to hello@: the board keeps the sent text and time.

Raz's rules (2026-10-18):
- Every request gets a reply, so the student feels heard and didn't write for nothing.
- Building a new topic is strict, a last resort, and only with Raz's approval. Students often think a topic is missing when it isn't. **Always look for the topic on the site first.**
- Questions sent for an existing topic are welcome: they grow the bank. They still go to Raz before they enter it, and only their story and field names are kept, never the data.
- No free text on the site. Requests come by email, and Raz distills the decisions on anything big.

Talk to Raz in Hebrew. The sources below are the truth. If something here conflicts with them, the source wins, and tell Raz.

## Where things are

- **Gmail:** use the claude.ai Gmail connector tools (load them with ToolSearch: `search_threads`, `get_thread`, `get_message`, `list_labels`, `create_label`, `label_thread`, `update_message_labels`).
- **Supabase:** go through Composio. Project details and the safe pattern are in the memory note `supabase-via-composio`. Write with `proxy_execute("POST", ".../database/query", "supabase", body={"query": sql})`. Read with `SUPABASE_RUN_READ_ONLY_QUERY`. The table is `public.requests`; `supabase/migration_2026-10-18_requests.sql` lists its columns and checks.
- **What the site teaches:**
  - `src/page.html`: built lessons are in `COURSE` (titles `ls_<id>`), planned ones in `PX_PLANNED` (titles `pl_ls_<id>`), and section titles are `data-title` keys with their text in `I18N`.
  - Lesson numbers come from the plan order: intro 1.x, RA 2.x, SQL 3.x, normalization 4.x, ERD 5.x.
  - Topics that are planned but not yet in `PX_PLANNED` are in the memory note `rowdyql-roadmap`.

## Sorting the inbox ("תמיין את הפניות")

1. **Find new mail:** `to:hello@rowdyql.com -from:hello@rowdyql.com -from:noreply@rowdyql.com -label:RowdyQL-נקלט`. In a Gmail search, a nested label's `/` is written `-`.
   - The labels already exist (created 2026-10-18), and their ids come from `list_labels`.
   - The connector does not expose the `Message-ID` header, so `message_id` stays empty for now. The reply then arrives as a new "Re:" email rather than inside the thread.
   - Skip anything sent from hello@ or noreply@. Those are our own replies and copies.
   - Also check `public.requests.gmail_thread`, so the same thread is never entered twice.
   - A new message in an old thread is a follow-up: add it to the row's `body` and set `status` back to `review`.
2. **Read each thread** with `get_thread`. Take:
   - the sender's name and address;
   - the subject and the body (plain text, quotes and signatures cut);
   - a message sent with the site's buttons ("כתבו לנו" at the end of every lesson, "שליחת מייל" in the personal area) ends with "נשלח מהעמוד: <lesson>" ("Sent from: <lesson>") and the page address. Keep both lines: they tell you which lesson the student was on;
   - the student message's `Message-ID` header, so the reply threads. If the connector doesn't expose it, leave `message_id` empty: the reply still arrives, just as a new thread.
3. **Who is it?** Look the address up in `auth.users` and `public.profiles` (read only): `user_id`, institution, field of study. Their plan is in `public.progress`, key `dbs_plan`. Don't copy more personal data than the form needs.
4. **Find the topic on the site first.** Search the lesson titles, the section titles and the lesson text, in Hebrew and English, with synonyms (e.g. "WITH" = "CTE", "צירוף" = JOIN, "חילוק" = ÷ / "for all").
   - **Found, built:** category `exists`. `match` = "2.4 ÷ חילוק, וקריאת ביטוי". Link the lesson by its stable address, e.g. https://rowdyql.com/#/ra/r-divide.
   - **Found, planned but not open yet:** category `exists` (it is already in the course), and say it opens soon. Use `building` only for a topic Raz approved and that is being written now.
   - **Not found, in scope:** a databases topic the course could teach. Category `new_topic`. `decision` = what you'd suggest (enrichment, part of a chapter, or "not now") and why, in one or two lines. Raz decides.
   - **Sample questions for a topic we have:** category `questions`. Name the lesson they belong to.
   - **Not about the course:** another subject, ads, spam. Category `out_of_scope`.
   - **Thanks, a bug, a question about the site or the account:** category `other`. Put the facts in `decision`. For a bug, say where it is and what you checked.
5. **Draft the reply** in the site's voice. Use the `rowdyql-voice` skill in write mode, and read the profile and `copy/examples.md` first.
   - Hebrew plural address, unless the student wrote in English; then reply in English.
   - Short, warm and specific. Open with "היי {first name}," when you know it. End with "רז, RowdyQL".
   - Answer what they asked: where it is (with the link), what happens next, or an honest no with a reason.
   - Never promise something Raz hasn't decided, such as a date, or that a new topic will be built. For `new_topic`, the draft says the request is written down and that we'll update them.
   - `reply_subject` stays empty, and the function writes "Re: <their subject>".
6. **Fill the form:** insert a row into `public.requests` with `status = 'review'`, through the Composio write. Escape quotes in SQL (`''`). Read the row back.
7. **Mark the mail:**
   - add the Gmail label `RowdyQL/נקלט` (create it once if it's missing), plus a label for the category: `RowdyQL/כבר קיים`, `RowdyQL/נושא חדש`, `RowdyQL/שאלות`, `RowdyQL/מחוץ לתחום` or `RowdyQL/אחר`;
   - mark the thread read (remove `UNREAD`).
   - Don't archive or delete anything.
8. **Report to Raz, in Hebrew and short:** how many came in, by category. List what needs his decision first, mainly `new_topic`. Then remind him that the drafts are waiting in the board's "פניות" tab.

## In the daily routine (a cloud run, no one watching)

A cloud routine runs this skill every morning (set up 2026-10-18). Composio is not available in the cloud. Two things differ from an interactive run.

**Supabase through its REST API.** The cloud environment holds a network secret for `afzlmlbigruxijudqukp.supabase.co`, and the agent proxy adds the key's headers to every request to that host. Never put a key in a command or a file, and never print headers. Use `curl` with `BASE=https://afzlmlbigruxijudqukp.supabase.co/rest/v1`:
- **Already in?** `curl -s "$BASE/requests?select=id,gmail_thread,status&gmail_thread=in.(ID1,ID2)"`
- **Who is it?** `curl -s "$BASE/profiles?select=id,first_name,institution,field_of_study&email=eq.ADDRESS"` (URL-encode the address). For the plan, use `"$BASE/progress?select=value&user_id=eq.UID&key=eq.dbs_plan"`.
- **Fill the form:**
  1. Write the row as JSON to a file with a short Python script (`json.dump(..., ensure_ascii=False)`), so the Hebrew and the line breaks stay intact.
  2. Send it: `curl -s -X POST "$BASE/requests" -H "Content-Type: application/json" -H "Prefer: return=representation" --data-binary @row.json`.
  3. Check that the answer has the new `id`.
- **A follow-up:** `PATCH "$BASE/requests?id=eq.ID"` with the new `body` and `status: review`.

If a call answers 401 or 403, the secret is missing or wrong. Don't retry in a loop. Write it in the summary email and stop.

**The summary email.** This is the one email the skill may send, and it goes only to Raz.
- **When nothing came in:** send nothing and end.
- **Otherwise:** after sorting, send one email with the Gmail connector's `send_message`.
  - To: `razelbaz1@gmail.com`. Subject: `RowdyQL · N פניות חדשות מחכות לך`.
  - In plain Hebrew: one line per request (who, category, topic, and the proposed decision in a few words), the `new_topic` ones first. End with: "הטיוטות מחכות בלוח הניהול, בלשונית 'פניות': https://rowdyql.com".
  - Never email anyone else, and never call `send_request_reply`.

The routine only reads the repository. It never commits, pushes or opens a pull request.

## A discussion ("דיון על פנייה #N")

Raz pastes the prompt that the board copied: the request's id, its Gmail thread, the draft, and what he thinks should change.

1. Read the row (by id) and the thread.
2. Talk it through with him, and agree on the decision and the reply.
3. Then update the row: `reply_text`, and `decision` / `category` / `topic` if they changed. Set `status = 'review'`, so the request is back in the board and he can send it.
4. If he decided to build a topic, note it in the roadmap memory. Building a topic is its own task, with its own plan.

## Never

- Never send an email to a student yourself (no `send_request_reply`, and no `send_message` except the routine's summary to Raz). Only Raz's click in the board sends a reply.
- Never build or change site content from a request.
- Never put student emails, names or messages into the public repo, the memory or a commit. They live in Supabase and Gmail only.
- Never delete mail or rows.
