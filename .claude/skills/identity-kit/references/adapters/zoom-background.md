# Adapter - Zoom / video-call background

Template (add-on). Fill every `{{...}}` from kit.json. Recycled from the structure of Ben's T2 Zoom backgrounds set (1920x1080, center free for the speaker, mirror variants, light-to-dark ladder).

## Purpose and when to attach
Virtual backgrounds for Zoom, Teams, Meet, and stream overlays. Attach with `core.md` when the request is "make me a Zoom background ...".

## Format specs
- 1920x1080 PNG. Export every design twice: normal and horizontally mirrored (`-mirror`), because many platforms flip the camera and mirrored text reads correctly only in the mirror file.
- The center 50% of the width and 70% of the height stays free of text and detailed motifs (the speaker sits there).
- Text, if any: brand name and one line, >= 40px, in one corner, inside the outer 25% of the width.
- Set of 4 formality levels: light, accent block, dark, warm/playful.

## Core in this medium
- Colors: light = {{color.bg}} canvas; accent block = a {{color.accent}} or {{color.accent_strong}} band on one side; dark = {{color.depth}} canvas with {{color.bg}} text; warm = {{color.accent_2}} plus one more secondary, on bg.
- Type: heading family only, 40-56px, corner placement.
- Tokens: bands and cards with the Core radius {{tokens.radius.xl}}px and the Core shadow model (offset reads well on camera; blur softens).
- Motifs: 1-2 large motifs in the outer thirds; never in the speaker zone; low contrast (30-50% opacity) on the light and warm versions so they do not compete with the face.
- Logo: one corner, height 8-10% of the canvas, on the same side as the text. Mono version on dark.
- Imagery: none, or one very soft photo per Core 7 at 20-30% opacity behind everything, only on the light variant.

## Layouts
1. **Light** - bg canvas, faint dot or line field (tiled motif at 15% opacity), one motif top corner, logo and name bottom corner.
2. **Accent block** - a vertical band 28-32% wide on one side in accent-strong with the logo and name on it; canvas plain on the speaker side.
3. **Dark** - depth canvas, two large motifs in opposite outer corners at 60% opacity, logo bottom corner in mono.
4. **Warm** - bg canvas with two secondary-accent shapes in the outer thirds, name top corner.

## Rules and gotchas
- Check the design against a face: nothing busy at eye level, no thin lines behind the head (they flicker with virtual-background edges).
- Contrast between the background and typical clothing: avoid a canvas that equals the speaker's usual shirt color (chroma bleed).
- Camera compression: no 1px details, no fine gradients; solid fills and bold shapes only.
- Deliver a gallery HTML that shows all variants for choosing, plus the PNG pairs.

## Drop from Core here
- Body text, floors for reading, print rules, tiled motifs in the center.

## Usage prompt (copy-paste, attach with core.md)
```text
Read core.md and adapters/zoom-background.md. Build the 4-variant Zoom background set (light, accent block, dark, warm) as self-contained HTML frames sized 1920x1080, tokens inlined, motifs from motifs/ inline, logo from source/, speaker zone kept clear. Give me the export instructions for normal and mirrored PNGs named assets/zoom-<variant>.png and assets/zoom-<variant>-mirror.png, and a gallery.html that shows all four. Then run the done-check.
```

## Done-check
1. Center 50% x 70% free of text and detailed motifs on every variant.
2. Every variant has a mirror export.
3. Text >= 40px in a corner; logo height 8-10% same side.
4. Motifs at reduced opacity on light and warm; solid shapes only.
5. Four formality levels present; gallery lists all.
