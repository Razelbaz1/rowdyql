# Adapter - mascot / character

Template (add-on). Fill every `{{...}}` from kit.json. Recycled from the structure of Ben's Benjamin character contract (one-line law, identity lock, style lock, literal palette, locked rules, canonical range, verification checklist).

## Purpose and when to attach
A recurring character that appears across posts, videos, pages, and slides. Attach with `core.md` and the canon image when the request is "draw / generate / place the mascot ...". Requires a canon reference image at `source/{{mascot.canon}}`; without it, this adapter is `not defined` and the skill asks for one first.

## Format specs
- Canon image: one full-body reference, neutral pose, front view, at least 1024px on the short edge, at `source/{{mascot.canon}}`. It is law: every render reproduces it.
- Canonical range to build once: 3 expressions, 4 poses, 2 angles (front, three-quarter), talking-head pair (mouth closed / open) if used in video. Files under `assets/mascot-<set>-<n>.png`, plus cutouts `-cut.png` with transparent background.
- Delivery modes: A scene (character inside a described scene on the Core canvas), B cutout (transparent, clean edges, no decoration), C prompt only.

## Core in this medium
- Colors: the character carries the accent {{color.accent}} as its dominant garment or body color, depth {{color.depth}} for its hard shadow if the Core shadow model is offset, outlines {{color.ink}}; scene canvas {{color.bg}}; secondary accents only in scene decoration, in zones.
- Type: none in images.
- Tokens: shadow model of Core 4 applies to the character's ground shadow (offset = solid, blur = soft, none = none).
- Motifs: in scene mode, 1-2 motifs in zones around the character, never on the character.
- Logo: never on the character; may sit in the scene corner.
- Imagery: the character's rendering style is locked to the canon; if it differs from Core 6 (for example cel-shaded character in a flat-vector brand), this adapter states the exception explicitly: "{{exception or none}}".

## Layouts
1. **Scene** - character at 55-70% of the frame height, side-anchored, one motif behind, canvas bg, generous space for later text on the opposite side.
2. **Cutout** - character alone, transparent PNG, feet visible, no ground, no decoration, for compositing.
3. **Talking head** - shoulders up, two states (closed / open mouth), identical framing, for video lip-sync.

## Rules and gotchas
- Identity lock: face, proportions, hair, distinguishing marks, wardrobe. Write them as a bullet list of literal traits in this adapter after the first approved render: {{traits list}}.
- The reference sets the style, never a new face. If a render drifts (different face, wrong proportions, extra accessories), discard and regenerate; never retouch.
- No text anywhere in character images.
- Personality bible: 3-5 lines on gestures, resting expression, posture ({{from identity words}}), so poses stay in character.
- Judge renders by identity and style, not by exact hex.

## Drop from Core here
- Type rules, composition grids, print and email rules.

## Usage prompt (copy-paste, attach with core.md and the canon image)
```text
Read core.md and adapters/mascot.md, and look at the canon image source/<file>. Generate a prompt (or the image, if you have a generator) for the mascot in mode <A scene | B cutout | C prompt only>, pose <pose>, expression <expression>, for use in <medium>. Reproduce the canon identity exactly: list the locked traits from the adapter inside the prompt, inject the literal hex, add one motif in a zone for scene mode, no text in the image. Target path assets/mascot-<set>-<n>.png. Then run the done-check.
```

## Done-check
1. Every locked trait present; no new accessory, no changed proportions.
2. Style matches the canon (and the stated exception to Core 6, if any).
3. Accent color dominant on the character; canvas and shadow per Core.
4. Scene mode: 1-2 motifs in zones, none on the character. Cutout mode: transparent, no decoration.
5. No text in the image; target path recorded in ASSETS.md.
