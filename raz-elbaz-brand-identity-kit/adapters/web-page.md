# Adapter - web page (site and landing)

## Purpose and when to attach
The RowdyQL site, landing and lessons alike (the whole site follows this kit), plus one-off pages: a landing, a one-pager, a sign-up page. Attach with `core.md`, `voice/voice-profile.md` and `design-tokens.css` when the request is "build / restyle a page ...". Not a component library. The site's source is `src/page.html` in the repo, built by `python build.py`, which also runs the voice gate.

## Format specs
- A one-off page is a single self-contained HTML file: tokens copied into `:root` from `design-tokens.css`, CSS and JS inline, Google Fonts the only external request (plus images from `assets/`).
- Content max width 1180px; side gutter 16px, 32px from 760px. Root font size 18px at every width: body never under 18px. h1 `clamp(2.1rem,4.8vw,3.4rem)` (38-61px); h2 1.5rem; eyebrows .72rem (13px); tables .82rem (15px).
- Mobile first; breakpoints as on the board: 760px (gutter), 820-900px (two or three columns). No horizontal scroll at 360px.
- Two themes: light default; dark via `prefers-color-scheme` and a toggle that sets `data-theme` on `<html>` (a segmented pill, the only rounded element; the pressed button is ink with bg text).
- Accessibility: landmarks, the focus ring `2px solid` neon line tier with a 2px offset, contrast per Core 2, `prefers-reduced-motion` honored, `lang` and `dir` set (Hebrew `dir="rtl"`), logical CSS only (`margin-inline`, `inset-inline`, `padding-inline-start`).

## Core in this medium
- Colors: page bg; sections separated by a 1px top rule; panels on surface with a 1px rule; the hero on a one-hue wash (wash-sky by default; wash-flow only when the hero shows a source and a result); neon for links, focus, the result, the selected row and the one value that matters. Filled call to action: fill #20778A, text #FDFBF8 (dark: fill #5CC3D9, text #11161B), md corners (10px).
- Type: Rubik 800 for h1-h3; Heebo for paragraphs, buttons and UI (500 for buttons); IBM Plex Mono for code, tables, expressions and Latin eyebrows, always as LTR islands.
- Tokens: radius from the scale (sm 6 chips and inputs, md 10 buttons and cards, lg 14 panels and dialogs, xl 18 the hero panel, pill for toggles and status pills; table cells square inside a rounded frame); borders 1px; shadow none (hover changes color or underline only, never a lift or a shadow); glow only on data points, active lines and progress.
- Motifs: the hero gets one big visual (the schema map or a data-line diagram, inline SVG; `role="img"` with a label when it explains, `aria-hidden` when it decorates); the quiet grid behind lesson panels; body text areas get none.
- Logo: top bar start edge, 32-40px tall, the top-bar SVG inline with its sheen once on load and on hover or keyboard focus (light file in light, dark file in dark; suffix the ids of both copies). Optional: the intro (`logo/rowdyql-logo-intro-dark.svg`) once on first load in dark. Footer name line.
- Imagery: the landing hero illustration from `assets/hero-landing.png` (16:9, pending), or the schema map in its place; never both.

## Layouts
1. **Landing** - top bar (logo, theme toggle, one CTA), hero on a wash (Latin eyebrow, h1, lede, CTA, the hero illustration or the schema map), three panels, one lesson sample panel, a closing CTA, footer.
2. **Lesson** - top bar, a panel on the quiet grid: eyebrow, heading with its operator, muted lede, the expression chip, the source table, a data line, the result table outlined in neon with check marks, notes with state marks, a legend strip.
3. **One-pager** - top bar, hero, one article column (h2 on a top hairline, rule cards for callouts), footer.

## Rules and gotchas
- Glow is never clipped (Core 4): no `overflow:hidden` on a parent of a glowing element, and SVGs that glow keep their room (use the logo files as they are; do not crop their viewBox). The filled CTA never glows (Core 10).
- All copy follows voice/voice-profile.md; run its quick test before calling it done. Site strings also pass `voice/scripts/voice_check.py` (`python build.py` runs it and stops on new errors).
- Every color is a token; no raw hex in component CSS outside `:root`.
- Tables: header on the neutral tint (source) or the result header (result, 1px neon line outline); a selected row on #E3F2F3 with ink text; NULL cells with the hatch and a knock-out label.
- Motion: theme transitions .3s; optional entrance (opacity and transform, under .4s); nothing idle, nothing blinking; none under reduced motion.
- Images: `loading="lazy"` below the fold, width and height attributes, alt text always.
- The fallback stack is system-ui; never Inter, Roboto or Arial as the visible face.

## Drop from Core here
- Print rules (unless the page has a print stylesheet), email constraints, slide floors.

## Usage prompt (copy-paste, attach with core.md, voice/voice-profile.md and design-tokens.css)
```text
Read core.md, adapters/web-page.md, voice/voice-profile.md and design-tokens.css. Build a <landing | lesson page | one-pager> for: <purpose>, with these sections: <list>. Use layout <1 Landing | 2 Lesson | 3 One-pager>. One self-contained HTML file, tokens copied into :root with both themes, Hebrew RTL with logical CSS and LTR data islands, motifs inlined from motifs/, the top-bar logo inlined from logo/ with its sheen, the hero image path assets/hero-landing.png as a placeholder if it is not generated yet. Write the copy in Hebrew in the official voice. Run the voice profile's quick test on every string, then the done-check below and the gate in core.md section 11, and list the results.
```

## Done-check
1. Every color used is a token from `:root`; both themes work; fonts from the Core stacks only.
2. Body 18px at every width; h1 within the clamp; contrast passes in both themes.
3. One big visual in the hero; motifs only in their zones; none behind body text; no shadows or hover lifts.
4. Direction and logical CSS correct; focus ring visible; reduced motion honored; no horizontal scroll at 360px.
5. Logo at the top bar start edge with the right file per theme; footer name line present.
6. Every string passed the voice quick test (and `voice_check.py` for site strings).
