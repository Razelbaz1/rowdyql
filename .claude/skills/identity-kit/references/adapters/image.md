# Adapter - image (single generated image)

Template. Fill every `{{...}}` from kit.json. Recycled from Ben's toy-art prompt scaffold and the point-to-power visual-prompt rules. The skill never generates the image; it writes the prompt and the target path.

## Purpose and when to attach
Any single raster image: cover, hero, article header, background, section illustration. Attach with `core.md` and `image-style-block.md` when the request is "make me an image for ...".

## Format specs
- Aspect ratios by use: wide banner 16:9 · document cover 3:2 · square 1:1 · story 9:16 · post 4:5.
- Resolution: 1K while iterating, 2K for most deliverables, 4K only for print above A4.
- File type: PNG for anything with flat fills or that will be cut out; JPG for photographic. Target path always `assets/<purpose>-<subject>.<ext>`.
- Generator: {{meta.generator or "any"}}. Prompt language: English (image models mangle Hebrew).

## Core in this medium
- Colors: inject literal hex from Core 2 into every prompt: bg {{color.bg}}, accent {{color.accent}}, depth {{color.depth}}, ink {{color.ink}}, plus at most two secondary accents. The generator cannot read the kit; the prompt carries it.
- Type: none. No text inside images (Core 3 floors cannot be enforced in a render). Overlay words later in HTML or the design tool.
- Tokens: shadow model {{tokens.shadow.model}} translates to "{{'solid offset shadows, no blur' | 'soft diffused shadows' | 'no cast shadows'}}"; radius language "{{rounded | sharp}} corners".
- Motifs: name at most {{motif_rules.max_per_composition}} from Core 5, by description, placed in a zone ("one {{motif}} anchoring the lower edge").
- Logo: never rendered by the generator (Core 9); composite afterwards.
- Imagery: Core 6 when illustration, Core 7 when photo. Never mix the two in one image.

## Layouts
1. **Anchored subject** - subject centered or edge-anchored, one large motif in the opposite corner, 40%+ negative space in bg color.
2. **Field** - a tiled motif (dot grid, stripes) as a quiet background field behind a single simple subject, no other decoration.
3. **Full-bleed mood** - photo or illustration fills the frame, one solid band in accent-strong along one edge reserved for later text overlay (safe zone 20% of height).

## Rules and gotchas
- Order of the prompt is fixed: medium + style, subject, palette (hex), composition, motif flavor, constraints, format hint, `Avoid:` line.
- Subjects are concrete ("a desk lamp casting a warm circle over an open notebook"), never mood words ("cool", "modern", "clean").
- No hands or fingers unless requested. No physically impossible states. One moment per image; sequences become panels.
- Theme sets: lock palette, line, shadow, canvas and composition rule; vary only the subject. Generate one, judge, then the rest.
- Judge results by family of colors and style, not exact hex.

## Drop from Core here
- Type scale, floors, logo rendering, motion, layout grids.

## Usage prompt (copy-paste, attach with core.md and image-style-block.md)
```text
Read core.md sections 2, 5, 6, 7 and image-style-block.md. Write one complete image-generator prompt for: <subject, concrete>. Use layout <1 Anchored subject | 2 Field | 3 Full-bleed mood>. Aspect <ratio>, size <1K|2K|4K>. Paste the style block verbatim, add the subject and the composition, name at most two motifs by description, end with the Avoid line. Then give me the target path assets/<name>.<ext> to save the result and add the entry to assets/ASSETS.md.
```

## Done-check
1. Every hex in the prompt exists in Core 2.
2. Shadow wording matches Core 4's single model.
3. At most {{motif_rules.max_per_composition}} motifs named, each with a zone.
4. Illustration or photo rules from Core 6/7 present, never both.
5. No text requested inside the image; `Avoid:` line present.
6. Target path and ASSETS.md entry written.
