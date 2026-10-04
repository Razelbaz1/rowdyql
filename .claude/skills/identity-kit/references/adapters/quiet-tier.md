# Adapter - quiet tier (formal variant)

Template (add-on). Fill every `{{...}}` from kit.json. Recycled from Ben's design-system spec section H decision ("same tokens, decoration off") and its realization in the A4 proposal and syllabus documents.

## Purpose and when to attach
Formal outputs sent to clients or institutions: proposals, quotes, syllabi, contracts, official letters, certificates when the brand wants restraint. Attach with `core.md` AND the medium's adapter (document-pdf, booklet-print, email) when the request says "formal", "quiet", "client-facing", "official". This adapter overrides the medium adapter's decoration rules; everything else stays.

## Format specs
- Same formats as the medium adapter it modifies. Nothing changes in sizes or floors.
- Decoration budget: 0 motifs. Borders 1-1.5px. No colored block shadows. No tiled backgrounds. Whitespace up 20-30% versus the playful tier.

## Core in this medium
- Colors: page white or {{color.bg}}; text {{color.text}}; headings {{color.depth or color.ink}}; accent {{color.accent}} only as a hairline rule, a page number, one key figure, or the recommended option's border. No secondary accents.
- Type: unchanged families and floors; weights capped at 700; no highlighted words, no rotated stamps.
- Tokens: radius capped at {{tokens.radius.md}}px; shadow model replaced by `none` (offset) or by `--shadow-1` only (blur); borders 1-1.5px in {{color.border}} or {{color.ink}} at 60% opacity.
- Motifs: none. The h2 marker becomes a plain rule or a small accent square.
- Logo: unchanged position, smaller (height 8mm print / 28px screen); mono version preferred.
- Imagery: none, or one cover image per Core 7 if photography is part of the identity; no illustration scenes.

## Layouts
1. **Quiet document** - the medium adapter's layout with all decoration removed, one accent rule under the title, tables with 1px borders, footer with name and page number.
2. **Quiet email** - the email shell with border 1px, no shadow, no header image (a text header with the logo mark and name instead), one accent link color.
3. **Quiet certificate** - white field, thin accent frame 1.5px, name large, one accent line under it, logo small, no side band.

## Rules and gotchas
- "Minimal, clean, not busy, but still designed": restraint is achieved by whitespace and hierarchy, not by removing the fonts or the colors.
- Keep the Core gate; the only checks that change are motif count (must be 0) and shadow (must be none or level 1).
- Numbers and money in LTR islands, tabular alignment, one decimal convention.
- Never mix tiers in one document.

## Drop from Core here
- Motifs (section 5) entirely, secondary accents, highlighted words, block shadows, illustration scenes, playful motion.

## Usage prompt (copy-paste, attach with core.md, the medium adapter, and this file)
```text
Read core.md, adapters/<medium>.md and adapters/quiet-tier.md. Build <the output> as in the medium adapter, but apply the quiet tier: zero motifs, 1-1.5px borders, no block shadows, accent only as a hairline or one key figure, 20-30% more whitespace, logo small and mono. Then run the medium's done-check, this file's done-check and the Core gate, and list results.
```

## Done-check
1. Zero motifs anywhere.
2. Borders 1-1.5px; no colored offset shadows; blur at most level 1.
3. Accent appears only as rule, number, page number, or recommended-option border.
4. Fonts and floors unchanged; weights <= 700; no highlights or stamps.
5. Logo small and mono; whitespace visibly larger than the playful tier.
