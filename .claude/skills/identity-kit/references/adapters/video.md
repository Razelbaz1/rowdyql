# Adapter - video

Template (add-on). Fill every `{{...}}` from kit.json. Recycled from the header rules of Ben's pixar brand.css (video canvas overrides: two fonts, explicit color per element, minimum on-screen size, self-hosted fonts).

## Purpose and when to attach
Title cards, lower thirds, intro and outro frames, explainer scenes, reels, thumbnails. Attach with `core.md` when the request is "make a title card / intro / thumbnail / video scene ...".

## Format specs
- Canvas 1920x1080 (16:9) for YouTube and explainers; 1080x1920 (9:16) for reels and stories; thumbnails 1280x720.
- On-screen text minimum 42px at 1080p (about 4% of height); lower thirds 36-48px; titles 72-120px. Safe area: 5% each edge; on 9:16 keep top 15% and bottom 20% clear.
- Fonts self-hosted (woff2) when rendering in a video engine; CDN fonts fail in headless renders. Every text element sets `color` explicitly (inherited color can render invisible in MP4).
- Duration rhythm: title card 2-3s, lower third 4-6s, outro 4-5s. Frame rate 30fps.
- Thumbnails: one face or one object, one headline of max 4 words, one accent shape.

## Core in this medium
- Colors: canvas {{color.bg}} for light scenes, {{color.depth}} for intro/outro; text {{color.ink}} on light, {{color.bg}} on dark; accent {{color.accent}} for underline bars, progress, highlighted word; at most one secondary accent per scene.
- Type: heading family for titles, lower-third names, labels; body family for captions and subtitles. No mono in video, even for code; code shows as a chip in heading family.
- Tokens: chips radius {{tokens.radius.pill}}; cards radius {{tokens.radius.lg}}px; shadow model translated to motion: offset becomes a solid 2D drop that sinks on press-like beats, blur becomes a soft glow, none stays flat.
- Motifs: 1 motif per scene, animated once on entrance (draw-on, slide-in), then static. Never looping decoration.
- Logo: intro 1.5s reveal, outro static with the brand line; corner watermark optional at 3% height, 60% opacity.
- Imagery: illustration scenes per Core 6 as flat layers (parallax allowed); photo per Core 7 with the locked treatment; never mixed within one video.

## Layouts
1. **Title card** - dark canvas, kicker pill, title with one highlighted word, one motif entering from a corner, logo bottom corner.
2. **Lower third** - name in heading family 44px on a surface card with the Core border, role below in body family 32px, accent bar on the start edge, slides in from the start edge.
3. **Outro** - dark canvas, full logo centered, brand line, one CTA chip, one motif static in a corner.
4. **Thumbnail** - subject on one half, headline on the other in 96-120px, accent shape behind the headline, logo small in a corner.

## Rules and gotchas
- Subtitles: body family 40-44px, {{color.bg}} text on a {{color.ink}} 70% band, bottom safe area; Hebrew RTL with LTR islands for numbers.
- Motion: entrance and exit only; ease {{tokens.motion.ease}}; 300-600ms; no idle bounce.
- Export a still of every layout as PNG to `assets/video-<layout>.png` for reuse.
- Music and voice are outside this kit.

## Drop from Core here
- Web and print floors, tiled motifs, mono font, multi-column layouts.

## Usage prompt (copy-paste, attach with core.md)
```text
Read core.md and adapters/video.md. Build a <title card | lower third | outro | thumbnail | scene> for: <content>, canvas <16:9 | 9:16>. Use layout <1 | 2 | 3 | 4>. Deliver as <HTML/CSS scene sized to the canvas with the entrance animation | a Remotion/After Effects spec: elements, positions, sizes, colors, timings>. All text >= 42px at 1080p, every element with an explicit color, one motif with a single entrance. Then run the done-check and the Core gate and list results.
```

## Done-check
1. Every text >= 42px at 1080p; inside the safe area.
2. Every element sets its color explicitly; fonts self-hosted or embedded.
3. One motif per scene, entrance only.
4. Logo per layout rules; brand line on the outro.
5. No mono anywhere; subtitles on the band in body family.
6. Stills exported to assets/.
