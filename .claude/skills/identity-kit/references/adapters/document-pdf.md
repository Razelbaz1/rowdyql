# Adapter - document / PDF (learner and reference documents)

Template (add-on). Fill every `{{...}}` from kit.json. Recycled from the structure of Ben's T9 document family (shared shell, sticky top bar, Markdown export) and the md-viewer conventions. For long-form reading and paper use `adapters/booklet-print.md`; this adapter covers structured documents: guides, how-tos, tool sheets, tip sheets, summaries, proposals.

## Purpose and when to attach
Documents that people read on screen and sometimes save as PDF or paste into Notion/Docs. Attach with `core.md` when the request is "write a guide / summary / proposal / spec ...".

## Format specs
- HTML: content column 760px, body >= {{typography.floors.web}}px, line-height 1.7. Markdown twin of the same content offered as a download or copy block.
- PDF: `@page A4; margin 8mm 16mm`; body 11pt; headings 16-24pt; tables 10pt; `break-inside: avoid` on cards and tables.
- Structure: title block (kicker, title, one-line summary, meta strip), numbered h2 sections, callouts, one summary card at the end.
- Quiet tier for client-facing documents (proposals, syllabi): decoration off, thin 1px rules, accent as a hairline or one number per page.

## Core in this medium
- Colors: page {{color.bg}} on screen, white in print; headings {{color.depth or color.ink}}; callouts on {{color.surface}} with {{tokens.border.width_px}}px border; one accent {{color.accent}} on section markers and links.
- Type: heading family for title, h2, h3, kickers, table headers; body family for text; mono per Core 3 rule (code blocks only, LTR islands).
- Tokens: callout radius {{tokens.radius.md}}px; shadow model on screen for the summary card only; none in print.
- Motifs: one small motif as the h2 marker (a diamond, a dash, a dot), consistent through the document; none elsewhere. Quiet tier: none.
- Logo: top bar start edge at 32-40px height; footer name line.
- Imagery: optional figure at column width with a caption; screenshots get a 1px border in {{color.border}}.

## Layouts
1. **How-to** - steps as numbered cards: what, why, tool, ready prompt (copy button), result, tips.
2. **Knowledge doc** - concept, one callout that connects it to daily life, "what to remember" card, further reading.
3. **Tips sheet** - numbered tip cards, 3-7, each one idea and one example.
4. **Proposal (quiet tier)** - what, structure, packages table, dates, contact; A4, 1-2 pages.

## Rules and gotchas
- Every ready prompt or code block gets a copy button on screen and stays a fenced block in the Markdown twin.
- Hebrew documents: no justified text, no letter-spacing, numbers in LTR islands, English terms inline without backticks unless they are real code.
- Headings are sentence case; kickers may be uppercase only in Latin.
- Tables: header row in heading family 700, 1px borders, no zebra fills darker than surface.
- Print check: print to PDF once; no trailing blank page; all breakpoints `@media screen and`.

## Drop from Core here
- Large hero motifs, dark canvas bands (except one pull-quote), motion, social floors.

## Usage prompt (copy-paste, attach with core.md)
```text
Read core.md and adapters/document-pdf.md. Write a <how-to | knowledge doc | tips sheet | proposal> titled "<title>" from: <content or attached notes>. Use layout <1 | 2 | 3 | 4>. Deliver one self-contained HTML file with the document shell (top bar with logo, title block, numbered sections, callouts, summary card, print CSS) plus a clean Markdown version of the same content in a fenced block at the end. Kit language. Then run the done-check and the Core gate and list results.
```

## Done-check
1. Title block complete (kicker, title, summary, meta).
2. h2 marker is one consistent motif; no other decoration in the body (none at all in quiet tier).
3. Body >= web floor on screen, 11pt in print; tables 10pt.
4. Copy buttons on prompts; Markdown twin present and identical in content.
5. Print CSS present; `break-inside: avoid` on cards and tables; breakpoints `screen and`.
6. Logo top bar and footer line present.
