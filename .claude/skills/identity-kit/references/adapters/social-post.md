# Adapter - social post

Template. Fill every `{{...}}` from kit.json. Written new for identity-kit (no source adapter existed).

## Purpose and when to attach
Single-image posts for Instagram, LinkedIn, Facebook, WhatsApp status. Attach with `core.md` when the request is "make a post about ...". Carousels use `adapters/carousel.md` instead.

## Format specs
- Sizes: square 1080x1080 (1:1) · portrait 1080x1350 (4:5, feed default) · story 1080x1920 (9:16) · LinkedIn 1200x627 (1.91:1).
- Safe zones: keep text and logo inside 90% of width; on 9:16 keep the top 250px and bottom 300px free of text (UI overlays).
- Headline floor: {{typography.floors.post_headline}}px at 1080 wide; body floor 32px; caption floor 26px.
- Export PNG; JPG only for photo-based posts. One idea per post.

## Core in this medium
- Colors: bg {{color.bg}} or accent-strong {{color.accent_strong}} as the canvas (dark variant), surface {{color.surface}} for a text card. Accent {{color.accent}} on at most 10% of the area.
- Type: heading {{typography.heading.family}} {{heaviest weight}}, body {{typography.body.family}}. Alignment {{composition.alignment}}; Hebrew RTL.
- Tokens: radius {{tokens.radius.lg}}px on cards; border {{tokens.border.width_px}}px {{tokens.border.color}}; shadow per Core 4 model, one level only.
- Motifs: exactly 1-2 from Core 5, in a corner or an edge rail; never behind the headline.
- Logo: {{logo.placement.post or "bottom corner opposite the reading start, height 6% of the short edge"}}; on dark canvas use the mono version.
- Imagery: optional; when used, it takes one half of the canvas, text the other (layout 3).

## Layouts
1. **Statement** - one headline (max 8 words) centered on canvas, one large motif in one corner, logo bottom corner.
2. **Card on canvas** - a surface card with {{tokens.radius.lg}}px radius and the Core shadow holds headline + 2 lines body; canvas shows 1 motif in an edge rail.
3. **Split** - image (illustration per Core 6 or photo per Core 7) on one half, solid accent-strong band with the headline on the other; no motif on the image half.

## Rules and gotchas
- One idea per post; if a second idea appears, it is a second post or a carousel.
- Max 3 text sizes per post. Headline never smaller than the floor.
- Contrast: text on canvas passes 4.5:1 (Core 2 contrast table); on photo, add a solid band, not a gradient, unless Core 7 allows overlays.
- Hebrew: no letter-spacing, no all-caps; numbers in LTR islands.
- Hashtags and captions live in the caption field, never on the image.

## Drop from Core here
- Print floors, email constraints, motion.

## Usage prompt (copy-paste, attach with core.md)
```text
Read core.md and adapters/social-post.md. Build a <1:1 | 4:5 | 9:16> post about: <topic>. Headline: "<text>" (or write one, max 8 words, in the Core language). Use layout <1 Statement | 2 Card on canvas | 3 Split>. Output a single self-contained HTML file sized exactly to the format, tokens inlined from design-tokens.css, motifs from motifs/ inline, ready to screenshot. Then run the done-check and the Core gate and list results.
```

## Done-check
1. Canvas size matches the chosen format exactly.
2. Headline >= floor; max 3 text sizes.
3. 1-2 motifs only, in a corner or rail, not behind text.
4. Logo in its Core 9 position, correct version for the canvas.
5. Text/canvas contrast passes.
6. One idea; nothing in the safe-zone margins.
