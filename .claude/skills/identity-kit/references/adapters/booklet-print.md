# Adapter - booklet and print

Template. Fill every `{{...}}` from kit.json. Recycled from Ben's T4 scroll-booklet shell, the T11 A4 print recipe, the quiet-tier rule (same tokens, decoration off), and the T19 print gotcha. Pairs with `templates/booklet-shell.template.html`.

## Purpose and when to attach
Long-form reading and anything that goes to paper or PDF: booklet, guide, handout, proposal, certificate, one-pager. Attach with `core.md` and the booklet shell when the request is "make a booklet / handout / PDF ...".

## Format specs
- Screen booklet: single scrolling HTML, content column 720-860px, reading progress bar optional.
- Print: `@page { size: A4; margin: 8mm 16mm; }` portrait (or `A4 landscape; margin: 12mm` for certificates). Sizes in use: {{print.sizes or "A4"}}. Printers need 3-5mm non-printable clearance; 16mm sides is the safe professional margin.
- Print body {{typography.floors.print_pt}}pt minimum (about 15px), line-height 1.5-1.7; headings 20-28pt; captions 9pt minimum.
- Bleed: none for office printing. For a print shop, add 3mm bleed and ask them for their template.
- Export: browser Print to PDF, headers and footers unchecked, background graphics on.

## Core in this medium
- Colors: page {{color.bg}} on screen, white in print (`@media print body{background:#fff}`); text {{color.text}}; headings {{color.depth or color.ink}}; accent {{color.accent}} on rules, numbers, one highlight per spread.
- Type: heading {{typography.heading.family}}, body {{typography.body.family}}; first word of the lead paragraph bold in accent instead of a drop cap (drop caps break Hebrew).
- Tokens: borders {{tokens.border.width_px}}px on callouts; shadow model {{tokens.shadow.model}} on screen only, removed in print; radius {{tokens.radius.md}}px on callouts.
- Motifs: screen, 1-2 in the hero and section dividers; print, at most 1 small motif per page, none behind text. Quiet tier (formal documents): 0 motifs, thin 1-1.5px borders, accent only as a hairline or a number.
- Logo: header top corner at {{logo.placement.print or "height 10mm"}}, plus footer name line; certificates carry the logo large in a side band.
- Imagery: cover image per Core 6/7 at 3:2, `assets/cover-<name>.jpg`; inside pages, images at column width with a caption at 9-10pt.

## Layouts
1. **Reading booklet** - sticky top bar (logo + title), hero (kicker, title with one highlighted word, deck, meta strip), cover image, article body with h2 markers, pull-quote on dark canvas, takeaways card, footer.
2. **A4 document, quiet tier** - white paper, hairline rules, one accent number or line per page, tables with thin borders, page footer with name and page number; 2 pages max per section, `break-inside: avoid` on cards.
3. **Certificate (A4 landscape)** - side band in accent-strong with logo and name, white field with recipient name at 60-88px, one motif line under the name, signature line; single page.

## Rules and gotchas
- Breakpoints must be `@media screen and (max-width: ...)`. Without `screen and`, Chromium applies the mobile layout when printing and the page prints stacked.
- In print, drop fixed heights (`min-height: 0; height: auto`) or the last 20mm spills to a blank page.
- `break-after: page` between sheets; `break-inside: avoid` on cards, tables, quotes.
- Hide screen-only controls in print (`.no-print{display:none}`).
- Hebrew justified text is banned; align to the start edge.
- Verify at true print width by printing to PDF, not by resizing the browser.

## Drop from Core here
- Motion and hover states, blur shadows in print, tiled background motifs in print, web floors (print uses pt floors above).

## Usage prompt (copy-paste, attach with core.md and templates/booklet-shell.html)
```text
Read core.md, adapters/booklet-print.md and templates/booklet-shell.html. Build a <booklet | A4 document | certificate> titled "<title>" from this content: <paste or attach>. Use layout <1 Reading booklet | 2 A4 quiet tier | 3 Certificate>. Keep the shell's tokens and print CSS, put my content in the article slot, add the cover image path assets/cover-<name>.jpg as a placeholder if not yet generated. Return one self-contained HTML file. Then run the done-check and the Core gate and list results.
```

## Done-check
1. `@page` size and margins present; print body >= {{typography.floors.print_pt}}pt.
2. Every breakpoint is `@media screen and`.
3. Shadows and tiled motifs removed in print; at most 1 motif per printed page (0 in quiet tier).
4. Logo and footer name line present; no text justified in Hebrew.
5. Cards, tables and quotes carry `break-inside: avoid`.
6. Printed to PDF once and the page count matches the intent (no blank trailing page).
