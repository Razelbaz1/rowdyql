# Adapter - booklet and print

## Purpose and when to attach
Long-form reading and anything that goes to paper or PDF: a practice booklet, a guide, a handout, a summary sheet. Attach with `core.md`, `voice/voice-profile.md` and `templates/booklet-shell.html` when the request is "make a booklet / handout / PDF ...". Formal documents (letters, certificates, official documents, invoices) also attach `adapters/quiet-tier.md`.

## Format specs
- Print size: A4 only. Portrait `@page{size:A4;margin:8mm 16mm}`; a certificate is `A4 landscape; margin:12mm`. 16mm sides is the safe office margin; printers need 3-5mm of non-printable clearance.
- Screen booklet: one scrolling HTML file, content column 760px (hero 860px), reading progress bar optional.
- Print floors: body 11pt, line-height 1.55; h1 24pt, h2 16pt, h3 13pt; captions and mono labels 9pt minimum.
- Bleed: none for office printing; for a print shop add 3mm and ask for their template.
- Export: browser Print to PDF, headers and footers off, background graphics on.

## Core in this medium
- Colors: page bg #F7F2EC on screen, white #FFFFFF in print; text and headings ink #373C44; muted #5F6670 for meta and captions; neon text tier #20778A for links and the one key figure; the flow gradient only as the 4px rule under the title; rule cards with a 3px inline-start bar in #2999B1. Dark theme on screen follows `design-tokens.css`; print is always light.
- Type: Rubik 800 headings, Heebo 400 body, IBM Plex Mono for code, tables and Latin eyebrows. The lead paragraph opens with its first words in Rubik 800 ink (no drop caps; they break Hebrew).
- Tokens: radius 0; borders 1px #DDD7CF; shadow none; glow off in print.
- Motifs: screen, the schema map (or the cover illustration) on the cover and the data line as the one section divider; print, at most 1 small motif per page, none behind text; quiet tier 0 (the quiet grid at most).
- Logo: screen top bar, lockup 28px tall; print header top start corner, 8mm tall, plus the footer name line. One inline copy of `logo/rowdyql-logo-light.svg` with fills `var(--ink)` and `var(--neon-l)` serves both themes; print shows the light version.
- Imagery: the cover illustration at 3:2 from `assets/cover-booklet.png` (pending in `assets/ASSETS.md`), or the schema map motif in its place; inside pages, images at column width with a 9pt caption.

## Layouts
1. **Reading booklet** - top bar (logo, title), hero (Latin eyebrow, title, deck, 4px flow rule at 38% width, meta), cover figure, article with h2 sections on a top hairline, callout and quote as rule cards, the data line divider, a takeaways panel, footer.
2. **A4 document, quiet tier** - white paper, hairline rules, one neon rule or number per page, tables with 1px borders, a footer with the name and the page number; `break-inside:avoid` on panels. Rules in `adapters/quiet-tier.md`.
3. **Certificate (A4 landscape)** - always quiet tier: see `adapters/quiet-tier.md` layout 3.

## Rules and gotchas
- All copy follows voice/voice-profile.md; run its quick test before calling it done.
- Every breakpoint is `@media screen and (...)`. Without `screen and`, Chromium prints the mobile layout.
- In print, drop fixed heights (`min-height:0; height:auto`) or the last 20mm spills onto a blank page.
- `break-after:page` between sheets; `break-inside:avoid` on panels, tables, quotes and figures.
- Hide screen-only parts in print (`.no-print{display:none}`): the top bar, the progress bar, the dark theme.
- Hebrew text is never justified; align to the start edge. Tables, expressions and diagrams stay LTR islands.
- Check at true print size by printing to PDF, not by resizing the browser.

## Drop from Core here
- Motion and hover, glow in print, tiled motifs in print, the dark theme in print, web floors (print uses the pt floors above).

## Usage prompt (copy-paste, attach with core.md, voice/voice-profile.md and templates/booklet-shell.html)
```text
Read core.md, adapters/booklet-print.md, voice/voice-profile.md and templates/booklet-shell.html. Build a <booklet | A4 document | certificate> titled "<title>" from this content: <paste or attach>. Use layout <1 Reading booklet | 2 A4 quiet tier | 3 Certificate>. Keep the shell's tokens and print CSS, put my content in the ARTICLE_HTML slot, keep the cover image path assets/cover-booklet.png (or put the schema map from motifs/ in its place if the image is not generated yet). Copy in Hebrew in the official voice. Return one self-contained HTML file and print it to an A4 PDF. Run the voice profile's quick test on every line, then the done-check below and the gate in core.md section 11, and list the results.
```

## Done-check
1. `@page` A4 and margins present; print body at or above 11pt.
2. Every breakpoint is `@media screen and`.
3. No glow and no tiled motif in print; at most 1 motif per printed page (0 in quiet tier, the quiet grid at most).
4. Logo in the print header and the footer name line present; no Hebrew justified.
5. Panels, tables and quotes carry `break-inside:avoid`.
6. Printed to PDF once; the page count matches the intent (no blank trailing page); every line passed the voice quick test.
