# Adapter - image (single generated image)

## Purpose and when to attach
Any single raster image: booklet cover, landing hero, share-image background, article header, section illustration. Attach with `core.md` and `image-style-block.md` when the request is "make me an image for ...". The kit never generates the image; this adapter produces the prompt and the target path. Anything letter- or color-exact (the logo, motifs, titles, diagrams with real data) is built in SVG or HTML, never generated.

## Format specs
- Generator: Gemini (Nano Banana). Prompt language: English, full descriptive sentences (image models mangle Hebrew).
- Aspect ratios by use: landing hero 16:9 · booklet cover 3:2 · share image 16:9, cropped to 1200x630 afterwards · square post 1:1 · portrait post 4:5 · story 9:16. Set the same ratio in Gemini and say it in words in the prompt.
- Resolution: 1K while iterating, 2K for deliverables, 4K only for print larger than A4.
- File type: PNG (flat fills). Target path always `assets/<purpose>-<subject>.png`, recorded in `assets/ASSETS.md`.

## Core in this medium
- Colors: the style block carries the literal hex from Core 2: canvas #F7F2EC, panels #FDFBF8, structure #DBD7D4 and #DDD7CF, ink #373C44, neon #5CC3D9 (line #2999B1) on the one result element, at most two secondary soft hues (#FD977A, #FAA670, #E6C792, #8CBDDA). Never green, red or amber (states are reserved).
- Type: none. No text, letters or numbers inside images (Core 3 floors cannot be enforced in a render). Words are added later in HTML.
- Tokens: shadow model none, written as "no shadows of any kind"; corner language "square hairline panels"; glow at most one small soft glow on the single result point, digital only.
- Motifs: name at most 2 from Core 5, by description, each in a zone ("one schema map as the big visual on the left half"). Check marks are never used in images.
- Logo: never rendered by the generator (Core 9). Composite the file from `logo/` afterwards.
- Imagery: Core 6 (illustration). Core 7 photo is not used.

## Layouts
1. **Anchored subject** - the subject on one side, 40% or more of the frame empty off-white on the other side for text added later (for Hebrew text, keep the right side empty).
2. **Field** - a quiet grid field behind a single simple subject (one table card, one progress ring), nothing else.
3. **Data scene** - a schema-map style scene fills the frame; one plain off-white band of 20% of the height along one edge stays empty for a later headline.

## Rules and gotchas
- Fixed prompt order: the style block's look paragraph, the subject, the palette paragraph, the composition, at most two motif descriptions, the constraints, the format hint, the Avoid line last.
- Subjects are concrete ("three table cards joined by gray routes into one result table outlined in sea blue"), never mood words ("modern", "techy", "clean").
- Images meant for print: no glow, light canvas only. Dark canvas only when the output itself is dark (use the dark variant in the style block).
- Theme sets: lock the whole style block and the composition rule; vary only the subject. Generate one, judge it, then the rest.
- Judge results by family of colors and style, not exact hex. Reject any image with text artifacts, a globe, a network web, isometric objects or a glossy look.
- Any automated generation needs Raz's approval per image.
- Symbols such as σ π ⋈ γ ÷ may be drawn by the generator when they come out clean (Raz, 2026-10-07). Use the Nano Banana Pro wording and check every symbol.
- The area kept free for text that is added later (the headline, the logo, the url) stays empty. Say so in the prompt, and reject an image that puts anything there, or that piles on elements nobody asked for. Example: version B of the share background added a second result panel under the headline.

## Drop from Core here
- Type scale and floors, logo rendering, motion, the voice (no words in images), states, layout grids.

## Usage prompt (copy-paste, attach with core.md and image-style-block.md)
```text
Read core.md sections 2, 5 and 6 and image-style-block.md. Write one complete Gemini (Nano Banana) image prompt for: <subject, concrete>. Use layout <1 Anchored subject | 2 Field | 3 Data scene>. Aspect <16:9 | 3:2 | 1:1 | 4:5 | 9:16>, size <1K | 2K | 4K>, for <screen | print>. Paste the style block verbatim (use its dark variant only if the output is dark), add the subject and the composition, name at most two motifs by description with their zones, end with the Avoid line. Then give me the target path assets/<purpose>-<subject>.png and the new entry for assets/ASSETS.md with status pending. Run the done-check below and the gate in core.md section 11 and list the results.
```

## Done-check
1. Every hex in the prompt exists in Core 2; no green, red or amber.
2. "No shadows of any kind" present; at most one small glow, and none for print.
3. At most 2 motifs named, each with a zone; no check marks.
4. Illustration rules from Core 6 present; no photo language.
5. No text requested inside the image; the Avoid line is last.
6. Target path under `assets/` and the ASSETS.md entry written.
