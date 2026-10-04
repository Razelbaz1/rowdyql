# 01 - Extraction prompt (run on the reference image)

Recycled from the course's image-to-DS prompt (Steps 0-1) and the design-system-web extraction prompts (screenshot path, logo path). The UI build step of the original is dropped on purpose. Part 3 is new and is the reason this skill exists.

Run all four parts on the attached reference. Report the result back before any planning. Every value is exact (hex, px, font name, weight). Anything you cannot see is `not defined`.

---

## Part 0 - Language

Already asked in the interview (question 1). Apply the answer to every human-facing description. Token names stay English.

## Part 1 - Style classification (with evidence)

Classify the visual style against known design languages. Name the closest match, or an explicit blend, and justify it in 3-6 short bullets citing concrete evidence from the image. Consider at least:

- Glassmorphism: translucent frosted panels, background blur, thin light borders, layered depth.
- Neumorphism: soft monochrome surfaces, dual light + dark extruded or inset shadows, very low contrast.
- Brutalism / Neubrutalism: raw high contrast, hard 2-4px borders, zero or low radius, solid offset drop shadows, oversized bold type.
- Claymorphism: puffy rounded 3D shapes, large radius, soft inner + outer shadows, pastel palette.
- Minimalism / Swiss: generous whitespace, monochrome + one accent, hairline borders, type-led hierarchy.
- Flat / Material: solid fills, subtle elevation shadows, bold accent, geometric.
- Skeuomorphism: realistic textures, gradients, bevels, physical metaphors.
- Bento: modular rounded card grid with varied tile sizes.
- Editorial / Luxury: serif display type, dramatic imagery, refined restraint, high contrast.
- Dark / Developer: near-black surfaces, a single neon accent, monospace accents, subtle glows.
- Memphis / Postmodern: bold geometric shapes as decoration, squiggles, dot grids, hard ink outlines, solid offset shadows, playful color cast.
- Retro / Y2K, Playful / Colorful: vibrant multi-color, organic shapes, pill-shaped components.
- Hand-drawn / Organic: visible strokes, imperfect lines, paper or grain texture.

This classification is vocabulary for the rest of the extraction. It never brings preset tokens with it.

## Part 2 - Tokens

**Palette** (hex): background, surface(s), primary ink, muted text, border, ONE primary accent, up to three secondary accents in order of visual weight, and any depth or shadow color. For each color state its role and an approximate usage ratio (for example "bg 60%, surface 25%, ink 10%, accent 5%").

**Typography**: serif / sans / mono / display; weight range; letter-spacing character; case habits (uppercase kickers, sentence case). Pick matching Google Fonts: a heading face and a body face; a monospace face only if the reference genuinely uses one. If the kit language includes Hebrew, every chosen family must have Hebrew glyphs on Google Fonts (Rubik, Assistant, Heebo, Varela Round, Frank Ruhl Libre, Secular One, Alef, Noto Sans Hebrew, David Libre). Note the type scale you observe (approximate ratio) and size floors per medium you would recommend.

**Shape language**: border-radius scale, border weight, and the shadow or elevation model. Name exactly one model: `offset` (solid, no blur), `blur` (soft layered), or `none`. Give its values.

**Motion character** (observable, not adjectives): smooth fades, snappy near-instant, springy bounce, restrained, none.

**Density**: generous or compact; approximate base spacing unit (4 or 8) and the visible rhythm.

**Logo read** (only if a logo was supplied): geometric traits, clear-space you would set (in multiples of a logo feature), which color versions exist in the file, what backgrounds it sits on in the reference.

## Part 3 - Decoration pass (the gap the UI extractors miss)

1. **Shapes as decoration.** List every shape that appears as decoration rather than as a component: squiggles, dots, grids, blobs, stars, arcs, stripes, frames, rules, corners, confetti, hand marks. For each: name, geometry in one sentence, stroke or fill, colors used (hex), typical size relative to the canvas, where it sits (corner, edge rail, behind text, between sections, full-bleed), and how often (once per composition, repeated, tiled).
2. **Motif candidates.** From item 1 derive 5-8 named motifs. If the reference has fewer, propose candidates that share the reference's shape language and mark them `proposed`. Every motif gets: name, description, placement zone, scale (small / medium / large relative to the canvas), frequency (once / 2-3 / tiled), and whether it will be an SVG file or a CSS recipe.
3. **Illustration style.** If illustrations exist: technique (flat vector, cel-shaded, line art, isometric, collage, hand-drawn, 3D), line (none / thin / thick, color), fill (flat / gradient / textured), shading (none / hard offset / soft), perspective (flat / isometric / camera), level of detail, subject treatment (people, objects, abstract). If none: `not used`.
4. **Photo and imagery mood.** If photography exists: subject type, lighting (natural daylight, studio, dramatic), color treatment (natural, warm grade, desaturated, duotone with which hex), crop habits (tight, wide, centered, rule of thirds), overlays (none, tint with hex, grain). If none: `not used`.
5. **Composition habits.** Density, alignment (left / right / centered / grid), whitespace share, hierarchy mechanics (size, weight, color, boxes), how decoration and text coexist (zones, behind, framing), typical canvas structure (hero + body, cards, full-bleed).
6. **Texture and surface.** Paper, grain, noise, gradients, none.
7. **Forbidden by evidence.** Things the reference clearly avoids (for example no gradients, no photos, no thin type, no pure black). State them; they become Don'ts.

## Part 4 - Report format

Return, in this order: classification with evidence; palette table (role, hex, ratio); typography block; shape block with the ONE shadow model; motion; density; logo read; decoration list; motif candidates (marked extracted or proposed); illustration; photo; composition; texture; forbidden-by-evidence. Then stop and hand over to the correction pass.
