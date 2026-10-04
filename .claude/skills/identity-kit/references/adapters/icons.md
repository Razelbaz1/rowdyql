# Adapter - icons and pictograms

Template (add-on). Fill every `{{...}}` from kit.json. Recycled from Ben's TailorPlayed pictogram style-lock and prompt-template (canvas, fixed color directions, subject slot, universal forbidden list).

## Purpose and when to attach
Icon sets, pictograms, app icons, favicons, section markers. Attach with `core.md` when the request is "make icons for ...". Two paths: a UI icon library for interfaces (pick one library, never mix), and generated brand pictograms for marketing.

## Format specs
- UI icons: one library only, pinned: {{icon library, e.g. Tabler icons webfont 3.34.0 | Lucide | Phosphor}}; stroke {{1.5 | 2}}px; sizes 16 / 20 / 24 / 32px.
- Pictograms: 1:1 canvas, rounded square with corner radius {{4.6}}% of the side; subject occupies 60-70% of the canvas, centered; must read at 64x64px. Export SVG when built in code, PNG 1024 when generated.
- Favicons: 32, 64, 180 (apple-touch), 512 (PWA) from the same mark.

## Core in this medium
- Colors: exactly two per pictogram. Direction A (default): subject {{color.accent or accent_2}} on background {{color.accent_strong or depth}}. Direction B (inverse): subject {{color.accent_strong}} on background {{color.bg or accent_2}}. No third color, ever.
- Type: none inside icons.
- Tokens: corner radius of the container from Core 4 (xl for pictograms); no shadow unless Core 4 model is offset, then one 2px offset in depth is allowed on marketing pictograms only.
- Motifs: a pictogram may reuse one Core 5 motif as its subject or frame; no decoration around the subject.
- Logo: the mark is a logo, not an icon; never regenerate it (Core 9).
- Imagery: none; icons are flat silhouettes or line art, matching Core 6 line logic ({{line weight}}).

## Layouts
1. **Silhouette** - solid fill subject, no outline, no shading, on the rounded square.
2. **Line** - {{line weight}}px stroke in the subject color, round caps and joins, no fill, on the rounded square.
3. **Badge** - subject inside a circle or the primary motif shape, used as section markers at 24-40px.

## Rules and gotchas
- Pure silhouette or pure line; never mixed within a set.
- Same optical size across the set: normalize subjects to fit a 60-70% box, not to equal pixel bounds.
- Forbidden in every pictogram prompt: text, lettering, numbers, photorealism, textures, drop or cast shadows, gloss, highlights, third colors, outlines on silhouettes, detailed faces, hands, 3D or isometric views, sparkles, motion lines, multiple subjects, backgrounds beyond the container, watermarks.
- Prompt slots: SUBJECT_NAME (3-6 words), SUBJECT_DESCRIPTION (2-4 sentences, noun phrase, no colors or style words), EXTRA_FORBIDS (comma-prefixed, optional). Everything else in the scaffold is fixed.

## Drop from Core here
- Type scale, floors, composition rules for layouts, illustration shading, photo rules.

## Usage prompt (copy-paste, attach with core.md)
```text
Read core.md and adapters/icons.md. I need <N> <pictograms | UI icons> for: <list of concepts>. Use layout <1 Silhouette | 2 Line | 3 Badge> and color direction <A | B>. For UI icons: pick them from the pinned library and list the icon names. For pictograms: write one fixed scaffold (canvas, the two hex colors, style, the forbidden list) and then one variant block per concept that changes only SUBJECT_NAME and SUBJECT_DESCRIPTION; end with a one-line recommendation of the most on-brand variant. Target paths assets/icon-<concept>.png. Then run the done-check.
```

## Done-check
1. One library or one scaffold for the whole set; nothing mixed.
2. Exactly two colors per pictogram, from the chosen direction.
3. Subjects normalized to the 60-70% box; legible at 64px.
4. Forbidden list present in every prompt; no text in any icon.
5. Logo never regenerated; favicon sizes derived from the real mark.
