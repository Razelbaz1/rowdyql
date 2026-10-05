# Adapter - deck (slides for class)

## Purpose and when to attach
Slides for class (presented live, with presenter mode), workshops and talks; HTML slides, PowerPoint or Google Slides. Attach with `core.md`, `voice/voice-profile.md` and `design-tokens.css` when the request is "build slides / a deck / a presentation ...".

## Format specs
- Canvas 16:9: 1920x1080 for HTML and Google Slides, 1280x720 for PowerPoint (same proportions).
- At 1080p: body at or above 26px (absolute floor 24px); code and tables at or above 24px; kickers and labels at or above 20px; headlines 48-72px; a big number 160px or more.
- Safe margin: 5% of each edge free of text. Logo corner mark 4% from the edges, 5-6% of the canvas height.
- Presenter notes for every slide (the class deck is presented live).

## Core in this medium
- Colors: slide canvas bg #F7F2EC, or a one-hue wash on section openers; cover and closing slides on the dark canvas #11161B with ink #E6EAEE and the dark tiers (#5CC3D9); diagrams, tables and code on surface panels #FDFBF8 with a 1px #DDD7CF rule; neon for the one emphasized value, row or result per slide.
- Type: Rubik 800 headings, Heebo 400 body, Heebo 500 for Hebrew kickers; IBM Plex Mono 400/500 for code, tables and Latin eyebrows only. Hebrew slides are RTL; SQL, tables, expressions and diagrams are LTR islands.
- Tokens: radius md 10 on cards and chips, lg 14 on large panels; border 1px; shadow none; glow only on the one data point, active line or progress ring of a slide (projected, so allowed; off in printed handouts). Spacing on the 4px scale.
- Motifs: at most 2 decorative per slide (the quiet grid behind a panel counts as one), in corners, a foot rail or as the big visual; never behind text; none on dense slides. Diagrams that explain are content.
- Logo: the icon as a corner mark at the physical top-left of every content slide (fixed with `left`, not `inset-inline-start`, so RTL does not push it onto the kicker); the full lockup on cover and closing. Dark slides on screen: `logo/rowdyql-logo-dark.svg`; light slides: `rowdyql-logo-light.svg`; a printed or PDF handout uses the flat files. The top-bar GIF may sit on a closing slide.
- Imagery: one visual per slide at most (a diagram, a number, a table or an illustration per Core 6 at 2K, 16:9).

## Layouts (slide types; pick per idea)
1. **Cover** - dark canvas, Latin eyebrow, headline, one line under it, full logo.
2. **Concept** - kicker, headline, up to 5 short lines OR one visual, never both dense; one motif at most.
3. **Big number** - one number at 160px or more in neon text tier, one line of context.
4. **Query and result** - an expression chip or SQL on a surface panel, the source table, a data line, the result table outlined in neon; check marks on the result rows when checking an answer.
5. **Two-column compare** - two panels of equal width, headline above.
6. **Steps** - 3-5 numbered panels in a row; data flows left to right with a data line, even on Hebrew slides.
7. **Do vs Don't** - two columns; the marks in the state colors (correct, wrong), the text in ink.
8. **Recap and closing** - key points, then a closing slide on the dark canvas with the full logo and the url.

## Rules and gotchas
- All copy follows voice/voice-profile.md; run its quick test before calling it done. Slide text is spoken, plural and short like the site, not a paper; presenter notes follow the voice too.
- One idea per slide; two ideas, two slides.
- Hebrew kickers and labels are never in mono (the font has no Hebrew); a Latin eyebrow may be mono 500 uppercase at 20px or more.
- A running example (the same tables, for example Students, Enroll, Courses) stays the same across a multi-step explanation.
- Charts follow the chart modes in Core 5 and sit on bg or surface.
- Entrance and exit animation only, short, staggered; nothing idle; off under `prefers-reduced-motion`.
- PowerPoint and Google Slides: map tokens to roles (background bg, titles Rubik 800, accents neon, dividers #DDD7CF) and override the tool's default theme; set a 10px corner radius and remove default shadows.

## Drop from Core here
- The web body floor (slides use the slide floor), print rules, email constraints.

## Usage prompt (copy-paste, attach with core.md, voice/voice-profile.md and design-tokens.css)
```text
Read core.md, adapters/deck.md, voice/voice-profile.md and design-tokens.css. Build a <N>-slide deck titled "<title>" from this outline: <outline or attached notes>. Target <HTML 1920x1080 | PowerPoint | Google Slides>. For each slide pick a layout by number from the adapter, keep one idea per slide, body at or above the slide floor, at most 2 decorative motifs in zones, the logo corner mark on every content slide, cover and closing on the dark canvas. Write the slide text and presenter notes in Hebrew in the official voice. Run the voice profile's quick test on every slide, then the done-check below and the gate in core.md section 11, and list the results.
```

## Done-check
1. Every slide body at or above 26px (never under 24); kickers at or above 20px; no Hebrew in mono.
2. One idea per slide; each slide names its layout.
3. At most 2 decorative motifs per slide, none behind text; any chart sits on bg or surface.
4. Logo mark at the physical top-left on every content slide; full logo on cover and closing, the right file for the canvas.
5. Dark canvas only on the cover and the closing slide; section openers on a one-hue wash.
6. Presenter notes exist for every slide, and every line passed the voice quick test.
