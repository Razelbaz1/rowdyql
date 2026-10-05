# Adapter - quiet tier (formal variant)

## Purpose and when to attach
Formal outputs: official letters, certificates, official documents (syllabus, grade sheets, forms), invoices and receipts. Attach with `core.md`, `voice/voice-profile.md`, this file AND the medium's adapter (`booklet-print.md`, `email.md` or `web-page.md`) when the request says "formal", "official", "certificate", "invoice". This adapter overrides the medium adapter's decoration rules; everything else stays.

## Format specs
- Same formats and floors as the medium adapter it modifies (print A4, certificates A4 landscape with a 12mm margin).
- Decoration budget: logo flat, ink and one blue, no glow, no gradients (no washes, no flow rule, no progress ring), no motifs except the quiet grid at most. Whitespace up 20-30% compared to the regular tier.

## Core in this medium
- Colors: page white #FFFFFF in print or bg #F7F2EC on screen; text and headings ink #373C44; muted #5F6670 for meta; the one blue only: neon text tier #20778A for one key figure, the page number or a link, and the line tier #2999B1 for a single hairline rule or a frame. No other brand hue, no state colors, no tints except the neutral table header #ECE8E3.
- Type: unchanged families and floors: Rubik 800 headings, Heebo 400/500/700 body, IBM Plex Mono for amounts, codes and dates (tabular by design, LTR). No highlighted words, no stamps.
- Tokens: radius 4px; borders 1px #DDD7CF, or 1px ink for a signature line; shadow none; glow none.
- Motifs: none. The quiet grid #EDE9E4 at most, behind a certificate field or a cover, never behind body text.
- Logo: flat files only: `logo/rowdyql-logo-light.svg` (on white or bg) or `logo/rowdyql-logo-dark-flat.svg` (on a dark canvas). Small: 8mm tall in print, 28px on screen. Never the glossy file, the intro, the top-bar sheen or a GIF.
- Imagery: none.

## Layouts
1. **Quiet document** - logo at the top start corner, the title in Rubik 800, one #2999B1 hairline under the title, body text, tables with 1px borders and a neutral header, a footer with "RowdyQL · rowdyql.com" and the page number in #20778A.
2. **Quiet email** - the email shell unchanged (logo header, no motifs, no gradients), one link color #20778A, the CTA as a text link or the standard CTA cell.
3. **Quiet certificate (A4 landscape)** - white field, a 1px #2999B1 frame inset 12mm, the recipient's name large in Rubik 800 ink (60-88px), one #2999B1 hairline under it, the course line in Heebo, a signature line in 1px ink, the logo small at the bottom; the quiet grid optional behind the field.
4. **Invoice or receipt** - logo and sender block, a table with 1px borders and a neutral header, amounts in IBM Plex Mono aligned to one edge, the total with one #2999B1 hairline above it, payment details in muted.

## Rules and gotchas
- All copy follows voice/voice-profile.md; run its quick test before calling it done. Formal does not mean form register: Don't 1 of the voice (נקלט, הנך, ניתן, במידה ו) still applies. Official or legal wording that must stay exact is quoted as given.
- Numbers, amounts, dates and IDs are LTR islands with one decimal convention.
- Never mix tiers in one document.
- Keep the Core gate; the checks that change are motif count (0, or the quiet grid only), glow (none) and gradients (none).

## Drop from Core here
- Motifs (section 5) except the quiet grid, the secondary hues, washes and the flow gradient, glow, the glossy logo and its motion, the chart modes' colors (a chart in a formal document uses ink and the neon line only).

## Usage prompt (copy-paste, attach with core.md, voice/voice-profile.md, adapters/<medium>.md and this file)
```text
Read core.md, adapters/<booklet-print | email | web-page>.md, adapters/quiet-tier.md and voice/voice-profile.md. Build <the output: letter | certificate | official document | invoice> as in the medium adapter, but apply the quiet tier: logo flat and small, ink and one blue only, no glow, no gradients, no motifs except the quiet grid at most, 20-30% more whitespace. Use quiet layout <1 Document | 2 Email | 3 Certificate | 4 Invoice>. Copy in Hebrew in the official voice; wording that must stay exact: <paste>. Run the voice profile's quick test on every line, then the medium's done-check, this file's done-check and the gate in core.md section 11, and list the results.
```

## Done-check
1. Zero motifs (the quiet grid at most); no washes, no flow gradient, no glow.
2. Colors are ink, muted, the page color and the one blue (#20778A text, #2999B1 hairline) only.
3. Borders 1px; radius 4px; shadow none.
4. Logo is a flat file at 8mm print or 28px screen.
5. Amounts, dates and IDs in mono LTR islands; whitespace visibly larger than the regular tier.
6. Every line passed the voice quick test.
