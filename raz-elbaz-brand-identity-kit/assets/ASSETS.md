# Assets - images the kit expects

The kit never generates raster images (skill rule 6). Each entry below has its purpose, a ready prompt with `image-style-block.md` inlined verbatim, the target path, the aspect ratio and the size. Generator: Gemini (Nano Banana). Generate, save the file at the target path, then change its status to `done` here and in `kit.json` (`assets`). Any automated generation needs Raz's approval per image. Judge a result by its family of colors and its style, never by exact hex.

| File | Purpose | Aspect | Size | Status |
|---|---|---|---|---|
| `assets/cover-booklet.png` | Booklet cover illustration | 3:2 | 2K | pending |
| `assets/hero-landing.png` | Landing hero illustration | 16:9 | 2K | pending |
| `assets/share-bg.png` | Social share background | 16:9 (crop to 1200x630) | 2K | pending |
| `assets/email-logo-light.png` | Email header logo | 457:112, the light logo's own viewBox (480x118) | 480px wide, shown at 240px | done 2026-10-05 |

## 1. `assets/cover-booklet.png`

- Purpose: Booklet cover illustration (adapters/booklet-print.md layout 1; the cover figure of templates/booklet-shell.html). Printed on A4, so no glow.
- Target path: `assets/cover-booklet.png`
- Aspect ratio: 3:2 · Size: 2K
- Status: pending

Prompt:

```text
Flat vector illustration in a Swiss data design style, like a clean infographic panel: thin hairline rules in warm light gray #DDD7CF and quiet data lines in slate gray #5F6670, flat matte fills, no shadows of any kind, a perfectly flat straight-on view with no perspective, medium detail, and generous warm off-white #F7F2EC negative space.

Subject: a calm data scene for a course on relational databases. On the left, three small near-white table cards with soft coral, apricot and sun header bands and short rounded gray bars for rows. Quiet thin gray right-angle routes lead from them to the right, through one small square node, into a single result table card on the right outlined in deep sea blue #2999B1, its rows tinted pale sea blue.

Color palette: background warm off-white #F7F2EC; panels near-white #FDFBF8; a pale sea canvas #E7F2F4 where the result sits; structure in light warm grays #DBD7D4 and #DDD7CF; primary accent neon sea blue #5CC3D9 with its deeper line #2999B1, used only on the one result element; secondary accents used sparingly as small marks, at most two per image: coral #FD977A and apricot #FAA670 on the source side, sky blue #8CBDDA toward the result, soft sun #E6C792 only for a middle stage; outlines and dark elements slate #373C44.

Composition organized in clear zones like a Swiss grid, not scattered: hairline panels, data that flows left to right from the warm source side to the cool result side, compact detail inside the panels and calm space between them; at most two large shapes; about 70% of the frame left as quiet off-white negative space; the subject anchored to one side so the other side stays empty for text that is added later. Wide 3:2 cover: the scene fills the lower two thirds; the top third stays empty off-white for the title added later; data flows left to right.

Motifs, at most two: schema map: three small table cards with soft colored header bands, joined by quiet gray right-angle routes into one result table outlined in neon sea blue (the one big visual); quiet grid: a very faint square grid, barely darker than the background, with no numbers, behind the panels (full-bleed background).

No text, letters, numbers, labels or logos anywhere in the image; table rows are drawn as short rounded gray bars instead of words. Flat and matte: no 3D, no photorealism, no glossy highlights, no gradients except one soft background wash of a single hue fading from the off-white. Glow: at most one small soft glow on the single result point in digital images, and none in images meant for print. Green, red and amber never appear (they are reserved for marking answers). Friendly and professional, calm and clear, never childish, never generic stock. This image is printed: no glow at all.

Format: wide 3:2 cover illustration, set the aspect ratio to 3:2 in Gemini, 2K, PNG.

Avoid: glowing network constellations, node-and-link webs, particle fields, floating isometric servers or cubes, holographic graphs, globes and world maps, 3D render, isometric perspective, photorealism, glossy or glowing tubes, lens flare, drop shadows, bevels, green, red or amber marks, people and characters, hands and fingers, text artifacts, letters, numbers, watermark, logos, gradients beyond the one background wash, decorative clutter, a second style.
```

## 2. `assets/hero-landing.png`

- Purpose: Landing hero illustration (adapters/web-page.md layout 1), digital, light theme.
- Target path: `assets/hero-landing.png`
- Aspect ratio: 16:9 · Size: 2K
- Status: pending

Prompt:

```text
Flat vector illustration in a Swiss data design style, like a clean infographic panel: thin hairline rules in warm light gray #DDD7CF and quiet data lines in slate gray #5F6670, flat matte fills, no shadows of any kind, a perfectly flat straight-on view with no perspective, medium detail, and generous warm off-white #F7F2EC negative space.

Subject: a student's first look inside a database. A large near-white panel holds one source table card with a soft coral header band and short rounded gray row bars; one quiet thin gray line with right-angle turns leaves it, passes one small square filter node, and its last segment turns neon sea blue and enters a result table card outlined in sea blue; the entry point is one small dot with a soft glow.

Color palette: background warm off-white #F7F2EC; panels near-white #FDFBF8; a pale sea canvas #E7F2F4 where the result sits; structure in light warm grays #DBD7D4 and #DDD7CF; primary accent neon sea blue #5CC3D9 with its deeper line #2999B1, used only on the one result element; secondary accents used sparingly as small marks, at most two per image: coral #FD977A and apricot #FAA670 on the source side, sky blue #8CBDDA toward the result, soft sun #E6C792 only for a middle stage; outlines and dark elements slate #373C44.

Composition organized in clear zones like a Swiss grid, not scattered: hairline panels, data that flows left to right from the warm source side to the cool result side, compact detail inside the panels and calm space between them; at most two large shapes; about 70% of the frame left as quiet off-white negative space; the subject anchored to one side so the other side stays empty for text that is added later. Wide 16:9 banner: the scene is anchored on the left 55% of the frame; the right 45% stays empty off-white for the Hebrew headline added later.

Motifs, at most two: schema map: three small table cards with soft colored header bands, joined by quiet gray right-angle routes into one result table outlined in neon sea blue (the one big visual); quiet grid: a very faint square grid, barely darker than the background, with no numbers, behind the panels (full-bleed background).

No text, letters, numbers, labels or logos anywhere in the image; table rows are drawn as short rounded gray bars instead of words. Flat and matte: no 3D, no photorealism, no glossy highlights, no gradients except one soft background wash of a single hue fading from the off-white. Glow: at most one small soft glow on the single result point in digital images, and none in images meant for print. Green, red and amber never appear (they are reserved for marking answers). Friendly and professional, calm and clear, never childish, never generic stock.

Format: wide 16:9 banner, set the aspect ratio to 16:9 in Gemini, 2K, PNG.

Avoid: glowing network constellations, node-and-link webs, particle fields, floating isometric servers or cubes, holographic graphs, globes and world maps, 3D render, isometric perspective, photorealism, glossy or glowing tubes, lens flare, drop shadows, bevels, green, red or amber marks, people and characters, hands and fingers, text artifacts, letters, numbers, watermark, logos, gradients beyond the one background wash, decorative clutter, a second style.
```

## 3. `assets/share-bg.png`

- Purpose: Social share background (og image, adapters/social-post.md layout 4): the headline, the logo and the url are set in HTML on top, then exported at 1200x630.
- Target path: `assets/share-bg.png`
- Aspect ratio: 16:9 (crop to 1200x630) · Size: 2K
- Status: pending

Prompt:

```text
Flat vector illustration in a Swiss data design style, like a clean infographic panel: thin hairline rules in warm light gray #DDD7CF and quiet data lines in slate gray #5F6670, flat matte fills, no shadows of any kind, a perfectly flat straight-on view with no perspective, medium detail, and generous warm off-white #F7F2EC negative space.

Subject: a quiet field: a very faint square grid over warm off-white, and in the left third a small group of two near-white table cards with soft warm header bands, joined by one thin quiet gray line whose last segment turns neon sea blue and ends in a small dot with a soft glow.

Color palette: background warm off-white #F7F2EC; panels near-white #FDFBF8; a pale sea canvas #E7F2F4 where the result sits; structure in light warm grays #DBD7D4 and #DDD7CF; primary accent neon sea blue #5CC3D9 with its deeper line #2999B1, used only on the one result element; secondary accents used sparingly as small marks, at most two per image: coral #FD977A and apricot #FAA670 on the source side, sky blue #8CBDDA toward the result, soft sun #E6C792 only for a middle stage; outlines and dark elements slate #373C44.

Composition organized in clear zones like a Swiss grid, not scattered: hairline panels, data that flows left to right from the warm source side to the cool result side, compact detail inside the panels and calm space between them; at most two large shapes; about 70% of the frame left as quiet off-white negative space; the subject anchored to one side so the other side stays empty for text that is added later. Wide 16:9, later cropped to 1200x630 from the center: the right 60% and the bottom 15% stay empty for the headline, the logo and the url added later.

Motifs, at most two: quiet grid: a very faint square grid, barely darker than the background, with no numbers, behind the panels (full-bleed background); data line: one thin quiet gray line with right-angle turns; only its last segment turns neon sea blue and ends in a small dot (between zones).

No text, letters, numbers, labels or logos anywhere in the image; table rows are drawn as short rounded gray bars instead of words. Flat and matte: no 3D, no photorealism, no glossy highlights, no gradients except one soft background wash of a single hue fading from the off-white. Glow: at most one small soft glow on the single result point in digital images, and none in images meant for print. Green, red and amber never appear (they are reserved for marking answers). Friendly and professional, calm and clear, never childish, never generic stock.

Format: wide 16:9 background, set the aspect ratio to 16:9 in Gemini, 2K, PNG.

Avoid: glowing network constellations, node-and-link webs, particle fields, floating isometric servers or cubes, holographic graphs, globes and world maps, 3D render, isometric perspective, photorealism, glossy or glowing tubes, lens flare, drop shadows, bevels, green, red or amber marks, people and characters, hands and fingers, text artifacts, letters, numbers, watermark, logos, gradients beyond the one background wash, decorative clutter, a second style.
```

## 4. `assets/email-logo-light.png`

- Purpose: Email header logo (templates/email-shell.html, HEADER_IMAGE_URL). Not a generator job: rendered from the approved SVG so the letters stay exact.
- Target path: `assets/email-logo-light.png`
- Aspect ratio: 457:112, the light logo's own viewBox (480x118) · Size: 480px wide, shown at 240px
- Status: done 2026-10-05. Rendered by `rowdyql/tools/emaillogolight.js` and hosted at https://rowdyql.com/email-logo-light.png

How to make it:

```text
Not a generator job (skill rule 6: never generate a logo). Render logo/rowdyql-logo-light.svg to PNG at 480px wide on a solid #FDFBF8 background (the email header cell color), for example with headless Chrome: an HTML page whose body is #FDFBF8 and holds the SVG at width 480px, screenshot at 480x109. Host it at an absolute https URL and put that URL in HEADER_IMAGE_URL.
```
