# Raz Elbaz / RowdyQL - Image style block

Paste this block, verbatim, into every image-generation prompt. Add only the subject, the composition for this image, and the aspect ratio. The generator cannot read the kit, so the prompt carries the brand inside it. Generator: Gemini (Nano Banana). Write the prompt in English, as full sentences; Gemini follows a described scene better than a list of keywords.

## The look (one paragraph, always first)

Flat vector illustration in a Swiss data design style, like a clean infographic panel: thin hairline rules in warm light gray #DDD7CF and quiet data lines in slate gray #5F6670, flat matte fills, no shadows of any kind, a perfectly flat straight-on view with no perspective, medium detail, and generous warm off-white #F7F2EC negative space.

## Palette (literal hex)

Color palette: background warm off-white #F7F2EC; panels near-white #FDFBF8; a pale sea canvas #E7F2F4 where the result sits; structure in light warm grays #DBD7D4 and #DDD7CF; primary accent neon sea blue #5CC3D9 with its deeper line #2999B1, used only on the one result element; secondary accents used sparingly as small marks, at most two per image: coral #FD977A and apricot #FAA670 on the source side, sky blue #8CBDDA toward the result, soft sun #E6C792 only for a middle stage; outlines and dark elements slate #373C44.

## Composition

Composition organized in clear zones like a Swiss grid, not scattered: hairline panels, data that flows left to right from the warm source side to the cool result side, compact detail inside the panels and calm space between them; at most two large shapes; about 70% of the frame left as quiet off-white negative space; the subject anchored to one side so the other side stays empty for text that is added later.

## Motif flavor (pick at most 2 per image, by description)

- quiet grid: a very faint square grid, barely darker than the background, with no numbers, behind the panels (full-bleed background)
- data line: one thin quiet gray line with right-angle turns; only its last segment turns neon sea blue and ends in a small dot (between zones)
- annotation leader: a thin gray elbow line ending in a tiny sky-blue square, pointing into the margin (edge rail)
- null hatch: a soft diagonal hatch filling one empty table cell (inside a table)
- legend strip: a short row of small flat color squares under a hairline (foot of the image)
- progress ring: a thick ring, part of it a soft apricot to sun to sea-blue arc, the rest light gray (badge)
- schema map: three small table cards with soft colored header bands, joined by quiet gray right-angle routes into one result table outlined in neon sea blue (the one big visual)

## Constraints

No text, letters, numbers, labels or logos anywhere in the image; table rows are drawn as short rounded gray bars instead of words. Flat and matte: no 3D, no photorealism, no glossy highlights, no gradients except one soft background wash of a single hue fading from the off-white. Glow: at most one small soft glow on the single result point in digital images, and none in images meant for print. Green, red and amber never appear (they are reserved for marking answers). Friendly and professional, calm and clear, never childish, never generic stock.

## Avoid line (always last)

Avoid: glowing network constellations, node-and-link webs, particle fields, floating isometric servers or cubes, holographic graphs, globes and world maps, 3D render, isometric perspective, photorealism, glossy or glowing tubes, lens flare, drop shadows, bevels, green, red or amber marks, people and characters, hands and fingers, text artifacts, letters, numbers, watermark, logos, gradients beyond the one background wash, decorative clutter, a second style.

## Dark variant (only when the output is dark)

Replace the canvas sentence with: background deep slate #11161B; panels #182027; structure #2A333C and hairlines #2E3943; light elements #E6EAEE. Keep the soft hues (#FD977A, #FAA670, #E6C792, #5CC3D9, #8CBDDA) exactly as they are; the one result glow may be slightly stronger.

## Format hint

State the orientation in words ("wide 16:9 banner", "3:2 cover") and set the same aspect ratio in Gemini (it accepts 1:1, 3:2, 2:3, 4:3, 3:4, 4:5, 5:4, 9:16, 16:9 and 21:9). Drafts 1K, deliverables 2K, print 4K when the model offers it. Save PNG (flat fills). Judge the result by its family of colors and its style, never by exact hex.

## Theme sets

To make several images that read as one family: keep this whole block identical, keep the same composition rule, vary only the subject line. Generate one, judge it, then run the rest.
