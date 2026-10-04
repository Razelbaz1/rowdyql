# Adapter - deck (slides)

Template (add-on). Fill every `{{...}}` from kit.json. Recycled from Ben's toy-deck slides recipe (deck arc, slide anatomy, hard rules, anti-patterns) and the design-system-ppt token-to-slide-role mapping.

## Purpose and when to attach
Any presentation: class deck, pitch, workshop, webinar. HTML slides or PowerPoint/Google Slides. Attach with `core.md` when the request is "build a deck / presentation ...".

## Format specs
- Canvas 16:9, 1920x1080 for HTML and Google Slides, 1280x720 for PowerPoint (same proportions).
- Body text >= {{typography.floors.slide}}px (absolute floor {{typography.floors.slide_absolute}}px) at 1080p; kickers and labels >= 20px; headline 48-72px.
- Safe margin: 5% of each edge free of text. Logo corner mark at 4% from the edges, height 5-6% of canvas.
- Presenter notes for every slide when the deck is presented live.

## Core in this medium
- Colors: slide canvas {{color.bg}}; section dividers and closing slide on {{color.depth}} with {{color.bg}} text; accent {{color.accent}} for the one emphasized word, number or bar per slide; {{color.accent_2}} as highlighter behind a single word when allowed.
- Type: headings {{typography.heading.family}} {{heaviest weight}}; body {{typography.body.family}}; mono {{typography.mono.rule}}. Hebrew always RTL; Latin tokens and numbers in LTR islands.
- Tokens: cards radius {{tokens.radius.lg}}px, border {{tokens.border.width_px}}px, shadow per Core 4 model, one level. Spacing rhythm {{tokens.spacing.base}}px.
- Motifs: max 2 per slide, in corners or a bottom rail; never behind text; none on dense slides.
- Logo: corner mark on every content slide at the physical top-left (fixed with `left`, not `inset-inline-start`, so RTL does not push it onto the kicker); full logo on cover and closing slides.
- Imagery: one visual per slide at most (image, number, diagram); illustration per Core 6, photo per Core 7, at 2K.

## Layouts (slide types; pick per idea)
1. **Title / cover** - dark canvas, kicker pill, headline with one highlighted word, tagline, full logo.
2. **Concept** - kicker + headline + up to 5 bullets OR one visual, never both dense; one motif in a corner.
3. **Big number** - one number at 160px+ in accent, one line of context.
4. **Two-column compare** - two cards side by side, equal width, headline above.
5. **Quote** - dark canvas, quote in heading family 40-56px, attribution 24px.
6. **Steps / process** - 3-5 numbered cards in a row, arrows in accent (RTL: next is to the left).
7. **Do vs Don't** - two columns, accent vs muted.
8. **Recap / closing** - key points, then a closing slide with full logo and the brand line.

## Rules and gotchas
- One idea per slide; two ideas, two slides.
- Slide body register: formal, full sentences, third person. Direct address lives in presenter notes.
- Kickers and labels never in mono.
- A running example stays the same across a multi-step framework; never swap metaphors mid-deck.
- Entrance and exit animation only, staggered; nothing idle; off under `prefers-reduced-motion`.
- PowerPoint / Slides: map tokens to roles (background = bg, titles = heading family and weight, accents = accent, dividers = border) and override the tool's default theme explicitly.

## Drop from Core here
- Web body floor (slides use the slide floor), print rules, email constraints, tiled background motifs (too busy at projection distance).

## Usage prompt (copy-paste, attach with core.md)
```text
Read core.md and adapters/deck.md. Build a <N>-slide deck titled "<title>" from this outline: <outline or attached notes>. Target <HTML 1920x1080 | PowerPoint | Google Slides>. For each slide pick a layout by number from the adapter, keep one idea per slide, body >= the slide floor, max 2 motifs in zones, logo corner mark on every content slide, cover and closing slides on the dark canvas. Add presenter notes per slide. Then run the done-check and the Core gate and list results.
```

## Done-check
1. Every slide body >= slide floor; kickers >= 20px; no mono on labels.
2. One idea per slide; each slide names its layout.
3. Max 2 motifs per slide, none behind text.
4. Logo mark on every content slide at the physical top-left; full logo on cover and close.
5. Dark canvas only on cover, dividers, quote, closing.
6. Presenter notes exist for every slide (if presented live).
