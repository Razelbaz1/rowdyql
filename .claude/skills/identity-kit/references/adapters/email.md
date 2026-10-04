# Adapter - email

Template. Fill every `{{...}}` from kit.json. Recycled from Ben's Benefits Mailer shell (720px table card, inline styles), with every hex turned into a token. Pairs with `templates/email-shell.template.html`.

## Purpose and when to attach
Any branded email: newsletter, onboarding, follow-up, announcement. Attach with `core.md` and `templates/email-shell.html` when the request is "write / build an email ...".

## Format specs
- Container width 720px (range 600-720), centered on a full-width canvas table; collapses to 100% under 740px.
- Table-based layout, all styles inline, `role="presentation"` on every table. No flexbox, no grid, no external CSS, no web fonts guaranteed: font stack is `'{{typography.heading.family}}','Helvetica Neue',Arial,sans-serif` with the Google Fonts link as progressive enhancement.
- Header: one hosted image, 720px wide, height 150-220px, PNG or JPG, absolute https URL. Alt text = brand name + tagline.
- Body text 16-17px, line-height 1.6-1.65. Section kickers 13px, weight 700, letter-spacing 1px only in Latin.
- One primary link style; buttons are table cells, not `<button>`.

## Core in this medium
- Colors: outer canvas {{color.bg}}; card {{color.surface}}; card border {{tokens.border.width_px}}px solid {{color.ink}}; shadow per Core 4 model: offset becomes `8px 8px 0 0 {{color.depth}}`, blur becomes `0 8px 24px rgba(...)`, none stays none. Body text {{color.text}}; kickers and links {{color.accent}}; footer text {{color.depth}}.
- Type: heading family for everything (email clients ignore a second family); weights 400/600/700 only.
- Tokens: card radius {{tokens.radius.lg}}px; inner callout boxes radius {{tokens.radius.md}}px with a {{tokens.border.width_px}}px border on bg color.
- Motifs: 0-1, only inside the header image (rendered once, hosted). No SVG inline in email bodies.
- Logo: in the header image; footer carries the name line in text.
- Imagery: header image only; body images optional, 720px wide, always with alt text.

## Layouts
1. **Letter** - header image, one opener paragraph, 2-3 body paragraphs, one CTA table-button, footer line.
2. **Package** - header image, opener, 3-4 kicker + box sections (each a bordered table on bg color), closer, footer.
3. **Announcement** - header image, one big headline (28px, heading family, weight 700), one paragraph, one CTA, footer.

## Rules and gotchas
- Placeholders in the shell: LANG, DIR, PREHEADER, HEADER_IMAGE_URL, BODY_HTML. Body copy goes into BODY_HTML as inline-styled `<p>` and `<table>` blocks only.
- Preheader is a hidden div, 40-90 characters, first line the inbox shows.
- RTL emails: `dir="rtl"` on `<html>` and on the body cell; numbers and Latin wrapped `dir="ltr"`.
- Links over attachments. Never a `<button>` element, never JavaScript, never background images for anything that carries text.
- Dark-mode clients may invert: keep text on solid surface color, never rely on canvas tint for legibility.

## Drop from Core here
- Motion, blur shadows on text elements, inline SVG motifs, mono font, web-only type floors (email uses 16-17px body).

## Usage prompt (copy-paste, attach with core.md and templates/email-shell.html)
```text
Read core.md, adapters/email.md and templates/email-shell.html. Write an email about: <topic>, for <audience>, with one call to action: <action>. Use layout <1 Letter | 2 Package | 3 Announcement>. Fill PREHEADER, LANG, DIR, and BODY_HTML with inline-styled table/paragraph blocks using only the shell's colors. Leave HEADER_IMAGE_URL as <url>. Return the complete HTML file, then run the done-check and the Core gate and list results.
```

## Done-check
1. Every color in the HTML is one of the shell's token values.
2. Tables only; every style inline; no `<button>`, no script.
3. Body 16-17px; kickers 13px bold; preheader present.
4. Card border, radius and shadow match Core 4 model.
5. Direction correct on `<html>` and body cell; Latin islands `dir="ltr"` in RTL.
6. One CTA; footer name line present.
