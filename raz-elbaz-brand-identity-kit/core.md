# Raz Elbaz / RowdyQL - Identity Core

> The one file to attach to any request. Everything visual for Raz Elbaz and RowdyQL is derived from the values below. Adapters in `adapters/` say how each medium uses them. Machine view: `kit.json`. Tokens: `design-tokens.css`. Image prompts: `image-style-block.md`. Logo files: `logo/`. Voice: `voice/`.
> Style family: Swiss data design, flat and matte, glow only on data (a modular grid of hairline panels on a warm off-white canvas; color lives only in thin data lines, node dots, rings and bars, about 1% of the reference). Generated 2026-10-05 from `source/reference.jpg` and the approved direction board `source/direction-board.html`.

## 1 - Identity

Raz Elbaz builds RowdyQL, an interactive learning environment for databases and SQL, from zero: SQL, relational algebra with visualizers, exercises and a self test. For students and self-learners who start from zero.
Personality: **friendly** (ידידותי), **short and to the point** (קצר וקולע), **at eye level** (בגובה העיניים).
Never looks like: a form, a paper or a machine, or generic AI imagery (glowing network constellations, floating isometric servers).
Language: the kit files are English. Outputs are Hebrew first (direction RTL, with LTR islands for tables, expressions, SVG diagrams, code and mono labels) or English (LTR).
Voice: voice/voice-profile.md (Hebrew, official) and voice/voice-profile-en.md (English). Every text in every medium follows them.
Brand and platform: the brand is the person, Raz Elbaz; RowdyQL is his platform. The whole site (landing and lessons) follows this kit.

## 2 - Color

Two themes. Light is the default; dark is an intentional mapping, not an inversion. Every hex below is literal.

| Role | Light hex | Dark hex | Usage ratio (reference) | Where it goes |
|---|---|---|---|---|
| bg (page canvas) | #F7F2EC | #11161B | 43% | page canvas, every wash start, post and slide canvas |
| surface (panels, tables, cards) | #FDFBF8 | #182027 | 1% (larger in product) | every panel, table, card, booklet cover |
| soft (cool canvas, bg-cool) | #E7F2F4 | #0F1A20 | 27% | alternate section background, end of the sky wash |
| ink (headings, body, hard text) | #373C44 | #E6EAEE | 7% with muted | all headings and body text |
| text (body) | #373C44 | #E6EAEE | | same as ink |
| muted (captions, meta, quiet lines) | #5F6670 | #9AA4AE | | captions, meta, eyebrows, quiet data lines, axes, routes |
| border (table and panel rule) | #DDD7CF | #2E3943 | 4% | 1px rule on every panel, table cell, card and frame |
| accent (neon, text tier) | #20778A | #5CC3D9 | brand hues together 1% | type in the one blue: a link, the one value that matters, the result label |
| accent-strong | not defined | not defined | | the board has no hover or pressed shade |
| accent-2 (coral, text tier) | #C3401B | #FD977A | | source |
| accent-3 (apricot, text tier) | #AD551B | #FAA670 | | source, join |
| accent-4 (sun, text tier) | #89682F | #E6C792 | | middle stage, filter |
| accent-5 (sky, text tier) | #3F7392 | #8CBDDA | | result, margin notes |
| depth (shadow color) | not defined | not defined | | the shadow model is none |
| extended (charts, SVG fills only) | soft tier: #FD977A, #FAA670, #E6C792, #5CC3D9, #8CBDDA | same | | fills, tints, glow; never text or thin lines on light canvases |

### One blue: the neon

The neon #5CC3D9 is the brand's signature blue: the logo, the glow, the result, the selected row, focus. It replaced the board's aqua #72C8D7 everywhere (Raz, 2026-10-04). On light canvases it works in three tiers; on dark it is #5CC3D9 for all three.

### Brand hues, three tiers each

| Hue | Role | Soft (fills, tints, glow) | Line (strokes, chart marks, 3:1) | Text (type, 4.5:1) | Dark (all tiers) |
|---|---|---|---|---|---|
| neon (primary) | result, selected, focus, the one value that matters, the logo | #5CC3D9 | #2999B1 | #20778A | #5CC3D9 |
| coral | source, charts | #FD977A | #E56541 | #C3401B | #FD977A |
| apricot | source, join | #FAA670 | #DD6D25 | #AD551B | #FAA670 |
| sun | middle stage, filter | #E6C792 | #AF853C | #89682F | #E6C792 |
| sky | result, margin notes | #8CBDDA | #5793B7 | #3F7392 | #8CBDDA |

Warm (coral, apricot) is the source or raw data; cool (neon, sky) is the result; sun is the middle stage. Five hues is an approved owner decision (one primary plus four secondary).

### States (reserved for marking, never decoration)

| State | Meaning | Mark | Text light | Line light | Tint light | Text dark | Tint dark |
|---|---|---|---|---|---|---|---|
| correct | correct answer, convention | check | #276B43 | | #DCEFE3 | #6BD09A | #12321F |
| note | note, attention | ! | #966212 | #C07D16 | #FFF1D6 | #F2B75A (line too) | #3A2B0C |
| wrong | error, delete, forbidden | cross | #B23A2E | | #FBE3E0 | #F28B7E | #3D1712 |
| neutral | not checked, disabled | short bar | #5F6670 | | #ECE8E3 | #9AA4AE | #232B33 |
| selected | selected row, result row | dot | ink only | #2999B1 | #E3F2F3 | ink only | #233A43 |

- Selected tint = `color-mix(in srgb,#5CC3D9 16%,surface)`. Text on a selected row is always ink: the neon text tier is 4.49 there.
- Wrong rows: the text is muted and struck through in the wrong color.
- Marks are drawn as geometry (Rubik, Heebo and IBM Plex Mono lack the check and the cross). In live text use an SVG mark.
- Brand hues never mean a state; coral never means error. States never decorate.

### Neutrals and table colors

| Name | Light | Dark | Use |
|---|---|---|---|
| grid (ink at 5%) | #EDE9E4 | #1C2126 | the quiet background grid; always lighter than the border |
| hatch (ink at 14%) | #E1E0DF | #394047 | the NULL hatch |
| fill | #DBD7D4 | #2A333C | progress ring track, schema-map row stubs |
| bar | #DDDCDB | #3D444B | quiet bars in a highlight chart |
| source table header | #ECE8E3 | #232B33 | header row of a source table (the neutral tint) |
| result table header | #CDEAEF | #2C515C | header row of the result table; derived: `color-mix(in srgb,#5CC3D9 30%,surface)` |
| result table outline | #2999B1 | #5CC3D9 | 1px outline around the result table |

### Washes (backgrounds)

A background is one hue fading from off-white, left to right. The full warm-to-cool wash only where a screen has a source and a result. Text on every wash is ink or muted.

| Wash | Light | Dark | Use |
|---|---|---|---|
| wash-sky | `linear-gradient(90deg,#F7F2EC 0%,#E7F2F4 100%)` | `linear-gradient(90deg,#11161B 0%,#25313A 100%)` | default one-hue wash, cool |
| wash-coral | `linear-gradient(90deg,#F7F2EC 0%,#F8E0D5 100%)` | `linear-gradient(90deg,#11161B 0%,#322828 100%)` | warm, a beginning |
| wash-apricot | `linear-gradient(90deg,#F7F2EC 0%,#F8E1D1 100%)` | `linear-gradient(90deg,#11161B 0%,#322A27 100%)` | warm |
| wash-sun | `linear-gradient(90deg,#F7F2EC 0%,#F2E6D3 100%)` | `linear-gradient(90deg,#11161B 0%,#2F2F2C 100%)` | middle |
| wash-cool | `linear-gradient(90deg,#F7F2EC 0%,#DCEAE8 100%)` | `linear-gradient(90deg,#11161B 0%,#1F2F35 100%)` | cool; the board's sea wash, kept as approved |
| wash-flow | `linear-gradient(90deg,#F8E0D5 0%,#F7F2EC 50%,#E7F2F4 100%)` | `linear-gradient(90deg,#322828 0%,#11161B 50%,#25313A 100%)` | when the screen has a source and a result, and the light part of the landing (see "The light flow wash" below) |

### The flow gradient

`linear-gradient(90deg,#FD977A 0%,#FAA670 28%,#E6C792 50%,#5CC3D9 74%,#8CBDDA 100%)`, the same in both themes. Warm is the source, cool is the result, read left to right like a relational expression.

**Where it lives:**
- Bands: a 4px rule, a legend band.
- Backgrounds: the washes.
- A few deliberate thin accents (Raz, 2026-10-05): the 3px track under the site's top bar and the 56 × 3px accent under section headings. On a thin line the flow can be elegant, but only as a considered accent. Never on a hairline (1px), and never on a line that carries data.

**Progress:**
- The progress ring is one solid neon #5CC3D9, with no flow.
- Some progress bars carry the flow, as approved: the top-bar track and the "My progress" stat bars. The onboarding and sign-up bars run neon to good.
- A gradient fill on a gradient track can stop reading as progress. So a new progress element is one solid neon on a neutral track, unless Raz approves otherwise.

### The light flow wash: Raz's tone (approved 2026-10-05)

wash-flow, `#F8E0D5` (peach) to `#F7F2EC` (cream) to `#E7F2F4` (pale sky), is the tone Raz chose for large light areas. It works for three reasons:
- Its two ends are pale tints of the flow's warm and cool hues, so neither end takes over.
- The cream in the middle softens the meeting of two contrasting hues.
- The content stays on the kit's light tokens: cards #FDFBF8 with a 1px #DDD7CF rule, ink #373C44, muted #5F6670, neon text tier #20778A, and the filled CTA #20778A.

**On the landing:** the hero and the story stay dark. Every section after them lives on this wash, horizontal and warm at the reading start (right in Hebrew, left in English). It is painted in as it scrolls into view:
- The sweep starts once the section's top passes about 72% of the screen.
- It is a soft-edged sweep from the reading start that takes 1.7s.
- The content turns from the dark colors to the light ones 0.5s later.
- It resets once the section is below the screen again.
- There is no sweep under reduced motion.

New landing sections follow the same approach.

### Wash tools: supporting tools for future content (Raz, 2026-10-05)

Four washes, chosen by Raz from a board of six (`--wash-flow`, `--wash-flow-diag`, `--wash-mesh`, `--wash-mesh-calm` in design-tokens.css). They are tools for creativity that still follow everything above:
- the same pale tints (peach #F8E0D5, sand #F2E6D3, pale sky #E7F2F4, mint #DCEAE8);
- every meeting of hues passes through cream #F7F2EC, or a near-white center, so no hue takes over and no two hues meet with a hard edge;
- text on them is ink or muted, and content sits on the light tokens.

| Tool | What it is | Good for |
|---|---|---|
| wash-flow | horizontal, warm to cool | long scroll sections (in use: the light part of the landing) |
| wash-flow-diag | diagonal, warm at the reading-start top corner, cool at the opposite one | a banner, a panel that leads to a CTA, a slider |
| wash-mesh | four hues, one per corner, met in cream | a central block, a banner, a booklet cover |
| wash-mesh-calm | the four corners around a near-white center | a block with a lot of content, a slide |

**Where to use them:** small blocks, secondary and tile buttons, banners, sliders, dividers, and more.
- On a button the text is ink. The filled CTA stays #20778A.
- A divider is a band, never a hairline.

The values are written for LTR. Mirror them in RTL so the warm corner sits at the reading start. The landing is one look for every visitor; the dark values exist only for the app's night mode (home and lessons).

Looked at and not taken: soft spots placed freely in space, and a vertical wash with several stops.

Canvases allowed: bg, surface, soft, the six washes and the wash tools above; white paper in print; the dark equivalents in the dark theme. Never invent another.
Accent rule: color only where it means something. Neon marks the result, the selected row, focus and the one value that matters; warm hues mark the source; sun is the middle stage. A diagram line is one quiet color and changes only for a reason (the segment that reaches the result). At most one neon element that glows per composition.
Forbidden pairs:
- soft tier as text or thin lines on any light canvas (1.46-1.98:1).
- line tier as a stroke on soft, a wash end or the neutral tint (2.93-2.95:1). Charts and diagrams sit on bg or surface; on a wash, strokes switch to the text tier (4.06 or more).
- brand-colored text on a wash or on the result header (4.08-4.21:1): text on a wash is ink or muted; the result header carries ink only.
- neon text on the selected tint (4.49:1): ink only.
- muted on the dark result header (3.40:1): the result header carries ink only, in both themes.
- the NULL label over a hatch line (4.40 light, 4.15 dark): the hatch stops under the label.
- a quiet bar carrying a value alone (1.23 light, 1.84 dark): every quiet bar gets a thin muted top line or a printed value.
- light line or text tiers on any dark canvas: in dark every tier is the soft tier.
- the light logo blue #2999B1 on soft or a wash (below 3:1).
Contrast (tools/wcag.py, both themes): ink on bg 9.97 (dark 15.05); ink on surface 10.74 (13.63); muted on bg 5.21 (7.19); muted on surface 5.61 (6.51); ink on every wash stop at least 8.78 (11.00); muted on every light wash stop at least 4.59 (5.25); neon text tier 4.64 on bg, 5.00 on surface, 5.16 on white; line tiers 3.00-3.02 on bg, 3.23-3.26 on surface; state text on its own tint 4.64-5.35 light, 5.66-7.64 dark; ink on the schema-map header bands 7.65-8.86 light, 5.67-6.55 dark. Every text pair in use passes AA. Rule, grid, hatch, fill and bar are decorative structure by design (1.02-1.84) and never carry meaning alone.

## 3 - Typography

- Heading: **Rubik** weight 800 for every heading, big number and title; **Rubik 900** only for the wordmark (already outlined in `logo/`). Line height 1.12.
- Body: **Heebo** weight 400 for paragraphs; 500 for buttons, toggles, table header text, Hebrew kickers and small UI; 700 for strong. Line height 1.6.
- Mono: **IBM Plex Mono** weights 400 (tables, data, legends, captions) and 500 (eyebrows, table captions, the expression chip). Rule: code, data and labels only; Latin only; no Hebrew inside mono (the font has no Hebrew glyphs). Mono runs are LTR islands (`direction:ltr; unicode-bidi:isolate`).
- Operators: **Noto Sans Math** 400 as the fallback in every stack, for σ, ⋈, ∪, ∩, ∧, ρ (missing from Rubik, Heebo and IBM Plex Mono; Plex Mono has π). In graphics, operators and marks are drawn as SVG geometry.
- Stacks: head `'Rubik','Noto Sans Math',system-ui,sans-serif` · body `'Heebo','Noto Sans Math',system-ui,sans-serif` · mono `'IBM Plex Mono','Noto Sans Math',ui-monospace,monospace`.
- Google Fonts: `https://fonts.googleapis.com/css2?family=Rubik:wght@800;900&family=Heebo:wght@400;500;700&family=IBM+Plex+Mono:wght@400;500&family=Noto+Sans+Math&display=swap` (weights pinned as listed; fetched 2026-10-05). Only these weights load; never ask for another (the browser fakes it).
- Scale (px, web, root 18px): 13 eyebrow (.72rem) · 15 table (.82rem) · 18 body (1rem) · 19 lede (1.08rem) · 23 small heading (1.3rem) · 27 h2 (1.5rem) · 29 lesson heading (1.6rem) · 38-61 h1 (`clamp(2.1rem,4.8vw,3.4rem)`). Ratio about 1.25 in the upper steps.
- Size floors: slide body >= 26px (absolute floor 24) · web body >= 18px · print body >= 11pt · post headline >= 48px at 1080 · caption >= 14px · mono labels on web >= 12px · email body 16px (mail clients, `adapters/email.md`).
- Letter-spacing: headings -0.01em (also on Hebrew headings, as on the approved board); body 0. Latin mono eyebrows uppercase +0.14em; Latin table captions uppercase +0.12em. Hebrew is never uppercased and never gets positive letter-spacing. Case: sentence case everywhere else.
- Hebrew/RTL: Rubik and Heebo carry Hebrew. Numbers, Latin terms, SQL keywords, table and column names sit in LTR islands. A Hebrew sentence never puts a number, a colon and inline code side by side (bidi flips them): move the code to its own line or rephrase.

Hebrew sample, heading in Rubik 800: כל מערכת שהשתמשתם בה היום יושבת על טבלאות.
Mono sample, an LTR island: `SELECT name FROM Students WHERE year >= 2;`

## 4 - Foundation tokens

- Spacing base 4px. Scale: 4 · 8 · 12 · 16 · 24 · 32 · 48 · 64. Generous between sections (32-48), compact inside data (table cell padding 4 by 8).
- Radius (softly rounded, Raz 2026-10-05): sm 6 · md 10 · lg 14 · xl 18 · pill 999. Chips, tags and inputs sm; buttons and cards md; panels, dialogs and post panels lg; large frames (the hero panel, covers) xl. A table gets a rounded outer frame and square cells inside. The rowdy row keeps the logo's own small rounding (about 15% of its height). The pill is for segmented toggles and status pills. Print boxes sm; quiet-tier documents 4px; email 8px. Round line caps only on the progress arc and schema-map row stubs.
- Borders: 1px solid #DDD7CF (dark #2E3943) on every panel, table cell, card and frame. Rule cards: a 3px inline-start bar in the neon line tier (#2999B1) or the apricot line tier (#DD6D25); a state rule card uses the correct color. Result table: 1px neon line outline. Diagram strokes: quiet 1.5, active 2.5, leader 1.
- Shadow model: **none**. Values: 1 none · 2 none · 3 none · 4 none. Flat and matte: no drop shadows, no elevation, no glass, no blur. Only this model exists in this identity.
- Glow is never clipped: a glow must fade out freely and never look boxed in an invisible square. Give every glowing element room: an SVG viewBox or filter region with at least 3 times the blur radius on every side (the logo intro: 30 units around the ignition bloom), and no `overflow:hidden` on a parent that cuts a glow. A glow with a hard edge is a bug.
- Glow (a data highlight, not a shadow): only on a data point, an active line or progress; small radius; never behind text; off in print; stronger in dark.
  - Point: `filter:drop-shadow(0 0 2px rgba(92,195,217,A)) drop-shadow(0 0 7px rgba(92,195,217,A*.7))`.
  - Ring: `filter:drop-shadow(0 0 3px rgba(92,195,217,A*.9)) drop-shadow(0 0 10px rgba(92,195,217,A*.45))` (neon only, Raz 2026-10-05).
  - A = .55 light, .85 dark. Other hues use their soft-tier RGB: coral 253,151,122; apricot 250,166,112; sky 140,189,218.
  - Print: `@media print{ filter:none }` on every glow.
  - Exception: the logo intro and the top-bar sheen may be glossy (digital, dark only; section 9).
- Motion character: restrained. Color and background transitions .3s on theme change; no idle motion; the glow is static. Ease: not defined (the CSS default). The logo has its own motion (section 9). Respect `prefers-reduced-motion`: no transitions, the logo shows its still end frame.
- Texture: none. Gradients only as one-hue washes, the flow band and 4px flow rule, the progress ring and a thin chart baseline.

## 5 - Motif vocabulary (8 approved)

Colors are listed light (dark). Every SVG uses CSS custom properties with the `--rq-` prefix and the light hex as fallback; `design-tokens.css` maps them to the current theme. Inline an SVG to get theme colors; as an `<img>` it shows the light fallbacks.

| # | Name | Description | Zone | Scale | Frequency | Colors | File / recipe |
|---|---|---|---|---|---|---|---|
| 1 | quiet-grid | A square grid at 5% ink, no numbers, no coordinates; always lighter than the table rule | full-bleed (behind panels, slides, covers; never behind body text) | l | tiled | #EDE9E4 (#1C2126) | CSS: `background-image:linear-gradient(var(--grid) 1px,transparent 1px),linear-gradient(90deg,var(--grid) 1px,transparent 1px);background-size:48px 48px`; preview `motifs/quiet-grid.svg` |
| 2 | data-line | One quiet line (muted, 1.5) with right-angle turns; only the segment that reaches the result turns neon line tier at 2.5, and its end point glows | between-sections, or inside a diagram | m | once | #5F6670, #2999B1, #5CC3D9 (#9AA4AE, #5CC3D9) | `motifs/data-line.svg` |
| 3 | annotation-leader | A thin elbow line (muted, 1) from a clause to a small square end in the sky line tier; a margin note for one part of a query | edge-rail | s | 2-3 | #5F6670, #5793B7 (#9AA4AE, #8CBDDA) | `motifs/annotation-leader.svg` |
| 4 | null-hatch | A soft 45 degree hatch at 14% ink in a cell with no value, always with the word NULL; the hatch stops under the word | badge (inside a table cell) | s | 2-3 | #E1E0DF, #5F6670 (#394047, #9AA4AE) | CSS: `td.null{background-image:repeating-linear-gradient(135deg,var(--hatch) 0 1px,transparent 1px 6px);color:var(--muted);font-style:italic} td.null>span{background:var(--cell-bg,var(--surface));padding:0 .25em}`; preview `motifs/null-hatch.svg` |
| 5 | check-marks | Correct, note, wrong marks on the checked row itself, each row on its state tint; the wrong row is struck through in muted | badge (on a row) | s | 2-3 | state colors only (dark states) | `motifs/check-marks.svg` |
| 6 | legend-strip | Named color squares under a hairline rule at the foot of an output; says what each color means; every square has a name | between-sections (foot) | s | once | #DDD7CF, soft tier, #5F6670 (dark equivalents) | `motifs/legend-strip.svg` |
| 7 | progress-ring | How much of a chapter is done: a ring, the arc solid light neon #5CC3D9 (no gradient, Raz 2026-10-05) with the neon ring glow, the rest in fill gray, the percentage always printed inside in ink | badge | m | once | #FAA670, #E6C792, #5CC3D9, #DBD7D4, #373C44 (#2A333C, #E6EAEE) | `motifs/progress-ring.svg` |
| 8 | schema-map | The big visual: tables as regions with soft header bands, relations as quiet muted routes, a join node and a selection node, the result table outlined in neon with a glowing entry point | full-bleed (the one big visual of a post or cover) | l | once | surface, rule, coral, apricot, sun, neon, muted, fill, hatch, sky line (dark equivalents) | `motifs/schema-map.svg` |

Accessibility built into the files (approved 2026-10-04): the NULL label sits on a knock-out, not on the hatch; the schema-map header bands are .45 (result .5) in light and .35 in dark (`--rq-band-a`, `--rq-band-res-a`), so ink stays at 5.67 or more; the progress ring always prints its percentage in ink; table names on bands are ink.
Library: none. Chart examples are rules, not motifs (below).
Placement law: motifs live in zones, never scattered. Max 2 decorative motifs per composition; few big shapes beat many small ones. A motif used as content (the diagram that explains, the NULL cells and check marks inside a table, the legend that keys a chart) follows the data and does not count as decoration. The schema map counts as one motif even though it contains a data line, a leader and a NULL hatch. Every motif has a role: the quiet grid gives order, the data line and the schema map explain, the leader annotates, the hatch and marks label data, the legend names colors, the ring shows progress.

### Charts: three modes, chosen by the question

Charts sit on bg or surface, never on a wash. Never force the warm-to-cool flow into a chart.

| Mode | When | How (light; dark) |
|---|---|---|
| highlight | one or a few values matter | quiet bars #DDDCDB (#3D444B), each with a 1.5px muted top line (#5F6670, 5.21:1) or a printed value; the important bars in neon line #2999B1 (#5CC3D9) with their value in neon text #20778A (#5CC3D9) and a glowing cap; muted baseline |
| compare | every category matters equally | each category its own brand hue at line tier (#E56541, #DD6D25, #AF853C, #2999B1, #5793B7; dark soft tier), up to five; a legend below in the same line tier with a name per square; no glow |
| sequence | values ordered small to large | one hue darkening with the value: `color-mix(in srgb,#20778A p%,surface)` at p = 22, 38, 54, 70, 86, 100 (light #CCDEE0, #A9C9CE, #86B4BD, #629FAB, #3F8999, #20778A; dark with #5CC3D9: #27444E, #325E6B, #3D7887, #4892A4, #52ACC0, #5CC3D9); a 1px neon line-tier outline on every bar (3.00 light, 8.89 dark) |

## 6 - Illustration style

Derived from the reference: a flat, matte data-graphic illustration in the Swiss infographic manner.
- Technique: flat vector. Line: thin, 1-1.5px at 1080 wide, quiet lines in #5F6670 and rules in #DDD7CF; one active line in neon. Fill: flat. Shading: none. Perspective: flat, straight-on (never isometric, never a camera angle).
- Subjects: the course itself: tables and rows, primary and foreign keys, joins, relational algebra as shapes, query plans, ER notation, schema maps (tables as regions, relations as routes) instead of world maps, charts, progress rings. People and characters: not defined (none in the reference).
- Detail level: medium (an infographic panel, not an icon, not a poster).
- Palette inside illustrations, in this order: bg #F7F2EC as the canvas with 40% or more negative space; soft #E7F2F4 or one one-hue wash; neutral structure #DBD7D4, #DDD7CF, #EDE9E4; brand hues in the soft tier as small marks, warm (#FD977A, #FAA670) on the source side and cool (#8CBDDA) toward the result; neon #5CC3D9 for the one result element. Dark images: canvas #11161B, structure #2A333C and #2E3943, the same soft hues.
- Glow: at most one small soft glow, on the single result point, in digital images only; none in anything printed.
- Forbidden: 3D, photoreal, glossy highlights, node constellations and glowing network lines, floating isometric servers, holographic graphs, globes and world maps, text, letters, numbers or logos inside the image, drop shadows, green, red or amber used as decoration.

## 7 - Photo and imagery

Not used.

## 8 - Composition rules

- Learning first: a diagram must read first. Diagram lines are one quiet color; color changes only with a real reason, and only the segment that reaches the result gets the accent and the glowing end point. The concept is never forced.
- Density: generous between sections, compact inside data; whitespace about 70% of the canvas (reference).
- Alignment: Hebrew outputs align to the right (start edge), English to the left. Data islands stay LTR inside RTL: tables, expressions, SVG diagrams, code and mono labels. Data flows left to right, source to result, in both languages.
- Grid: Swiss modular. A title block at the start edge, content in hairline panels, a legend at the foot. Hierarchy by size, weight and color; boxes only as hairline panels and tables, never boxes inside boxes beyond panel and table.
- Structures: post 1080: mono eyebrow, Rubik 800 headline of at most 15 characters per line, one big diagram on a surface panel, a foot rule with the url and a short line. A4 cover: eyebrow, headline, muted sub line, a 4px flow rule at 38% width, the schema map, a four-swatch legend band. Lesson: a panel on the quiet grid, an expression chip, the source table, a data line, the result table outlined in neon with check marks, notes with state marks, a legend.
- Decoration and text: glow never behind text; the quiet grid sits behind panels, never behind body text; an annotation leader ties a note to its clause; motifs in zones.
- Quiet grid at 5% ink, always lighter than the table rules, no numbered coordinates. NULL hatch at 14% ink.
- One idea per composition. Every color on it is named in a legend or obvious from a label.
- Hebrew sentences avoid a number, a colon and inline code side by side.

## 9 - Logo and name

The logo is "the rowdy row": three rounded rows of a table, the middle one kicked out of line (in the lockup `translate(10,-7) rotate(-8)`), next to the wordmark "Rowdy" + "QL" in Rubik 900 outlines. "Rowdy" is rows plus unruly. The kicked row and "QL" carry the neon. Final, approved by Raz on 2026-10-04.
- Files (in `logo/`; never redraw, re-space, recolor or approximate):

| File | What it is | Use |
|---|---|---|
| `rowdyql-logo-light.svg` | rows and "Rowdy" ink #373C44, middle row and "QL" #2999B1, flat, no glow | every light canvas, print on white |
| `rowdyql-logo-dark.svg` | rows and "Rowdy" #E6EAEE with a soft white glow; middle row and "QL" glossy neon (gloss gradient #CFF5FC, #5CC3D9, #2E9FB8 plus a 55% white highlight) with glow | digital dark only; the end frame of the intro |
| `rowdyql-logo-dark-flat.svg` | #E6EAEE and #5CC3D9, flat, no glow, no gloss | dark print, dark quiet tier |
| `rowdyql-logo-intro-dark.svg` | the animated intro, one self-contained SVG, about 1.6 s, plays once | site load on dark, logo reveals |
| `rowdyql-icon-light.svg`, `rowdyql-icon-dark.svg` | the three rows alone | favicon, avatar, small corner marks |
| `rowdyql-topbar-light.svg`, `rowdyql-topbar-dark.svg` | the lockup with the "Rowdy" sheen, triggered by script | the site's top bar |
| `rowdyql-topbar-light.gif`, `rowdyql-topbar-dark.gif` | the sheen as a 3.8 s loop | email signatures, slides, social; never on the site |

- Light uses #2999B1 and no glow. Dark digital is glossy; dark print is flat. The gloss colors #CFF5FC and #2E9FB8 exist only inside the logo files.
- Intro: rows grow and letters rise in white; at 0.62 s the middle row and "QL" ignite together in glossy neon with a bloom, the row kicks, and a wet sunrise-to-sea sheen (#FD977A, #FAA670, #E6C792, #5CC3D9, #8CBDDA, white leading streak) sweeps "Rowdy" from R to y and leaves it white with a soft glow. The end frame is `rowdyql-logo-dark.svg`. Reduced motion: no animation, the end frame shows.
- Top bar: the sheen plays once on load and again on hover or keyboard focus (start it with `beginElement()` on the two `<animate>` elements; wait at least 1.1 s between runs). On light the sheen runs in the line tiers (#E56541, #DD6D25, #AF853C, #2999B1, #5793B7) and the letters return to ink. Reduced motion: a still logo. Inline SVG only; when two copies share a page, suffix every id and scope every style rule.
- One inline copy for two themes: `rowdyql-logo-light.svg` with its fills set to `var(--ink)` and `var(--neon-l)` renders exactly the light version in light and the dark flat version in dark.
- Clear space: one row height on all sides, measured from the drawn shapes (13 units in the lockup's 96-unit-high frame, about 14% of the file height; 14 units of the icon's 100).
- Minimum size: lockup 28px tall on screen (file height) and 8mm in print; below that use the icon. Icon at least 16px (checked at 64, 32 and 16).
- Placement per medium: post, bottom corner opposite the reading start, lockup height 6% of the short edge (65px at 1080) · email, header cell on surface, light lockup 240px wide · print, header top start corner at 8-10mm height plus a footer name line · deck, the icon as a corner mark at the physical top-left on content slides, the full lockup on cover and closing slides · web, top bar start edge, 32-40px tall, the top-bar SVG.
- Backgrounds allowed: light logo on bg #F7F2EC, surface #FDFBF8 or white; dark logo on #11161B or #182027. Forbidden: washes, soft, any brand hue, the flow gradient, images, gloss or glow on light or in print, a rotated or re-spaced lockup, the middle row moved, "QL" separated from "Rowdy", the logo inside a generated image (composite it afterwards).
- Name protection: "RowdyQL" is one word with capital R, Q and L, never translated, split or restyled. The person's name is "Raz Elbaz" (Hebrew: רז אלבז).

## 10 - Do / Don't

| Do | Don't |
|---|---|
| Color only where it means something: neon #20778A / #2999B1 / #5CC3D9 for the result and the one value that matters, warm hues for the source | Coloring every line; the warm-to-cool gradient on hairlines or data lines, or on a new progress bar without approval |
| Diagram lines in one quiet color, muted #5F6670 (dark #9AA4AE) at 1.5; only the segment that reaches the result in neon at 2.5, with the glowing end point | Rainbow routes; a color change without a reason |
| Glow (two-layer drop-shadow, alpha .55 light, .85 dark) only on data points, active lines and progress; off in print | Glow behind text, on panels or buttons; any drop shadow or elevation |
| State colors only to mark: correct #276B43 on #DCEFE3, note #966212 on #FFF1D6, wrong #B23A2E on #FBE3E0, neutral #5F6670 on #ECE8E3, selected #E3F2F3 with ink text | States as decoration; a brand hue as a state (coral never means error) |
| A one-hue wash from off-white #F7F2EC as the background | The full warm-to-cool wash unless the screen shows a source and a result |
| Quiet grid #EDE9E4 (5% ink), always lighter than the table rule #DDD7CF; NULL hatch #E1E0DF (14% ink) | Numbered grids, coordinates, loud hatching |
| Softly rounded corners (6 to 18px), 1px hairline rules #DDD7CF, flat matte fills | Big pill-shaped cards, thick borders, shadows, glass or blur |
| Brand hues by tier: soft for fills and glow, line for strokes and chart marks, text for type; dark uses the soft tier for all three | Soft tier as text or thin lines on light canvases; line tier on washes |
| IBM Plex Mono for code, data and labels as LTR islands; operators as geometry in graphics, Noto Sans Math in live text | Hebrew in mono; uppercase or letter-spaced Hebrew; operators left to system fallback fonts |
| The course itself as subject: tables, rows, keys, joins, relational algebra, query plans, schema maps | Glowing cyan networks, isometric server racks, holographic graphs, particle constellations, globes |
| The logo files as they are: light flat with #2999B1, dark glossy on screen, dark flat in print | Redrawing, recoloring or approximating the logo; gloss or glow on the light logo or in print |

Voice rows, copied verbatim from `voice/voice-profile.md` (Do 3; Do 6 vs Don't 2; Do 4 vs Don't 7; Do 8 vs Don't 8; Do 13 vs Don't 3). Evidence tags: [R] Raz's own drafts or rejections, [W] the Walla columns, [R+W] both.

| Do | Don't |
|---|---|
| **Open on something concrete**: a number, an object, the question the student actually has. [R+W] | Don't open on a definition or an announcement. (not "ברוכים הבאים לקורס המקיף...") |
| **Turn with "אבל" or a dash, not a colon.** The dash ( - ) is Raz's natural joint between a setup and its point (13 per 1,000 words in his writing, 0 on the site today). "אבל" is the columnists' hinge. [R+W]<br>"כולם מדברים באותה שפה - SQL." | **Colons as slogan structure**: "לומדים SQL כמו שכותבים אותו: חי, על טבלאות, עם תשובה מיד." (Raz rejected this one) and "X: Y." explanations. The site uses 27 colons per 1,000 words, against 4 in the columns and 3 in Raz's writing. Keep colons for UI labels, before code, and before a quote. |
| **Build, then land.** After a longer sentence, a short verdict of two to five words. This is the strongest instinct in both sources. [R+W]<br>Raz: "האדם הוא צוואר בקבוק בסיפור." / Walla technique: "הוא הבוס." / site: "אותו מספר עמודות, טיפוס אחר." | **Summary endings**: לסיכום, בשורה התחתונה, כפי שראינו, אם כך. |
| **The site takes the joke, never the student.** Humor here is reassurance: the site pokes fun at itself, at the jargon or at the situation. [R+W]<br>"הג'יבריש שלמעלה יהיה בקרוב שפת האם שלכם." / "פעם אחרונה, מבטיחים." (both live) | **Sarcasm or snark** at the student or anyone else. The columnists do it to celebrities. RowdyQL has no one to mock. |
| **Cut every sentence the student wouldn't miss.** This is Raz's most repeated note. [R] | **Stating what the student already knows.** "ההתקדמות נשמרת מכל מכשיר" (Raz: "זה ברור... הרי"). |

## 11 - Non-negotiables gate (run before calling any output done)

1. Every color on the output is a role from section 2, at the right tier for its job (soft, line, text). Yes / no.
2. Only the canvases listed in section 2 (bg, surface, soft, the six washes, white in print, or their dark equivalents). Yes / no.
3. Headings Rubik 800 (900 only in the wordmark), body Heebo, mono IBM Plex Mono for code, data and labels only, no Hebrew in mono. Yes / no.
4. Size floors of section 3 respected for this medium. Yes / no.
5. No shadows anywhere; glow only on data points, active lines and progress, off in print (the logo intro and top-bar sheen excepted). Yes / no.
6. Motifs from section 5 only, in zones, max 2 decorative motifs per composition. Yes / no.
7. Illustration follows section 6; no photos. Yes / no.
8. Logo untouched, the right file for the canvas, name intact (section 9). Yes / no.
9. Nothing from the Don't column; states only mark, brand hues never mean a state. Yes / no.
10. No emojis, no em-dashes, text legible at the medium's floor, every text pair at 4.5:1 and every meaningful graphic at 3:1. Yes / no.
11. Every text passes the quick test at the end of voice/voice-profile.md (English: voice/voice-profile-en.md), and text that goes to the site passes voice/scripts/voice_check.py. Yes / no.
