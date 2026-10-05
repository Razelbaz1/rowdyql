# Adapter - email

## Purpose and when to attach
Every branded email: account emails (confirm, reset, reauthentication, goodbye), notices, announcements, a newsletter. Attach with `core.md`, `voice/voice-profile.md` and `templates/email-shell.html` when the request is "write / build an email ...". The site's current account emails live in `supabase/email/` in the repo; they move to this shell when Raz asks.

## Format specs
- Container 600px wide, centered on a full-width canvas table; 100% under 640px.
- Table-based layout, every style inline, `role="presentation"` on every table. No flexbox, no grid, no external CSS, no script. Light only (`color-scheme: light`).
- Fonts: web fonts often do not load in mail clients. Body stack `'Heebo','Rubik',Arial,Helvetica,sans-serif`; headings `'Rubik',Arial,Helvetica,sans-serif` weight 800 (Arial falls back to bold).
- Fixed titles are images (Raz, 2026-10-05). Gmail and Outlook never load web fonts, so a text h1 shows up in Arial. A title that does not change (for example "איפוס סיסמה") is rendered in Rubik 800, 24px, ink on the card color #FDFBF8, as a 2x PNG (`rowdyql/tools/emailtitles.js`, hosted at rowdyql.com/email-titles/). It sits inside the `<h1>` with the title as its alt text. A title that changes per message (a notice title, a greeting with a name) stays text, and the name moves to the first paragraph.
- Header: the light logo as a hosted PNG (`assets/email-logo-light.png`, 480px wide, shown at 240px), absolute https URL in HEADER_IMAGE_URL, alt "RowdyQL".
- Body text 16px, line-height 1.65; h1 24px; section kickers 13px weight 700 (letter-spacing only in Latin); footer 13px.
- One call to action, as a table cell (never `<button>`).

## Core in this medium
- Colors: outer canvas #F7F2EC; card #FDFBF8 with a 1px solid #DDD7CF border; body text #373C44; secondary text and footer #5F6670; links #20778A; the CTA cell fill #20778A with text #FDFBF8 (5.00:1); inner boxes on #F7F2EC with a 1px #DDD7CF border. State colors only when the email marks something (a note: #966212 on #FFF1D6).
- Type: Rubik 800 for the one h1, Heebo for everything else; weights 400, 500, 700 only.
- Tokens: radius 8px on the card, boxes and CTA (Outlook on Windows shows them square, which is fine); shadow none; borders 1px.
- Motifs: none in email bodies (no inline SVG, no CSS gradients; mail clients drop them).
- Logo: the header cell, light lockup 240px wide on surface, a 1px #DDD7CF rule under it; the footer carries the name line in text ("RowdyQL · rowdyql.com").
- Imagery: optional body image 600px wide with alt text, per Core 6; usually none.

## Layouts
1. **Letter** - header, greeting h1, one opener paragraph, 1-2 body paragraphs, one CTA, footer.
2. **Package** - header, opener, 2-4 boxes on bg (kicker + 1-3 lines each), one CTA, footer.
3. **Notice** - header, one h1 (what happened), one paragraph, one CTA or none, footer. For a formal notice add `adapters/quiet-tier.md`.

## Rules and gotchas
- All copy follows voice/voice-profile.md; run its quick test before calling it done.
- Shell placeholders: LANG, DIR, ALIGN (right for Hebrew, left for English), PREHEADER, HEADER_IMAGE_URL, BODY_HTML, FOOTER_LINE. Ready-made inline blocks (h1, paragraph, box, CTA, note) are listed in the shell's head comment. Body copy goes into BODY_HTML as inline-styled `<h1>`, `<p>` and `<table>` blocks only.
- Template variables of the sender (for example Supabase `{{ .ConfirmationURL }}`, `{{ .Data.first_name }}`) are kept exactly as written.
- Preheader: a hidden div, 40-90 characters, the first line the inbox shows; it also follows the voice.
- RTL emails: `dir="rtl"` on `<html>` and on the body cell, `text-align:right`; numbers, emails and Latin wrapped `dir="ltr"`.
- Links over attachments. Never a `<button>`, never JavaScript, never a background image under text.
- Dark-mode clients may invert colors: keep text on the solid surface color, never on the canvas tint alone.

## Drop from Core here
- Motion, glow, gradients (washes and the flow), inline SVG motifs, mono font, the dark theme, web type floors (email body is 16px).

## Usage prompt (copy-paste, attach with core.md, voice/voice-profile.md and templates/email-shell.html)
```text
Read core.md, adapters/email.md, voice/voice-profile.md and templates/email-shell.html. Write an email about: <topic>, for <audience>, with one call to action: <action and link>. Use layout <1 Letter | 2 Package | 3 Notice>. Write the copy in Hebrew in the official voice (or English per voice/voice-profile-en.md). Fill PREHEADER, LANG, DIR, ALIGN, FOOTER_LINE and BODY_HTML with inline-styled blocks using only the shell's colors; keep HEADER_IMAGE_URL as <url> unless I give it. Return the complete HTML file. Run the voice profile's quick test on every line, then the done-check below and the gate in core.md section 11, and list the results.
```

## Done-check
1. Every color in the HTML is one of the shell's values; no gradient, no shadow, radius 8px.
2. Tables only; every style inline; no `<button>`, no script, no SVG.
3. Body 16px, h1 24px, kickers 13px bold; preheader present.
4. Direction correct on `<html>` and the body cell; Latin and numbers in `dir="ltr"` islands.
5. One CTA (fill #20778A, text #FDFBF8); footer name line present.
6. Every line passed the voice quick test.
