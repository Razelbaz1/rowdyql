# 02 - Correction pass (run after extraction, before the interview)

Recycled as-is from the course's design-system-web skill, plus one motif rule. AI is excellent at part of extraction and predictably wrong at the rest. Run this pass every time.

## What's reliable vs. what to fix by hand

| Trait | Reliable? | Fix manually |
|---|---|---|
| Colors (hex) | Very reliable | Transparency / textures: confirm actual background colors |
| Mood / vibe | Reliable | Over-poetic description: translate into hard rules |
| Typography | Low | AI does not recognize commercial fonts and guesses line-height: confirm real Google Fonts by hand |
| Spacing / grid | Low | Invents random px (17, 23): force a 4 or 8px scale |
| Accessibility | Very low | AI never computes contrast: check every pair (formula below) |
| Motif count | Low | AI either lists 20 tiny shapes or none: force 5-8 named motifs with zones |

## The five correction moves

1. **Spacing: snap to scale.** Replace every random value with the nearest multiple of the chosen 4 or 8px base. State the base explicitly.
2. **Fonts: confirm real, open-source families.** Reject any commercial or hallucinated font name. Pick one expressive heading family + one legible body family from Google Fonts. Reject the lazy defaults (Inter / Roboto / Arial) unless the brand genuinely uses them. When the kit language includes Hebrew, both families must ship Hebrew glyphs.
3. **Accent hierarchy: one primary.** Keep exactly one primary accent. Secondary accents (max three) are allowed only if the reference clearly uses them; order them by weight and give each a role. Everything else is demoted to neutral or removed.
4. **Contrast: gate every text/background pair.** Compute the ratio (below) for every text color against every surface it sits on. If a pair fails, adjust the text or surface token until it passes and record the change.
5. **Motifs: 5-8, zoned.** Merge near-duplicates, drop shapes that appear once by accident, and give every survivor a placement zone. If fewer than 5 remain, propose candidates per protocol rule 5.

## WCAG contrast self-check (embedded, no external call needed)

Thresholds (WCAG 2.x AA):
- Normal text: ratio >= 4.5:1
- Large text (>= 24px, or >= 18.66px bold): ratio >= 3:1
- Graphical objects: ratio >= 3:1

Formula:
1. For each color, convert sRGB hex to channel values in [0,1]: `c = channel/255`.
2. Linearize: `c_lin = c/12.92` if `c <= 0.03928`, else `c_lin = ((c + 0.055)/1.055) ^ 2.4`.
3. Relative luminance: `L = 0.2126*R_lin + 0.7152*G_lin + 0.0722*B_lin`.
4. Ratio: `(L_lighter + 0.05) / (L_darker + 0.05)`.

Anchors: `#000` on `#fff` = 21:1; `#767676` on white = 4.54:1 (just passes); `#999` on white = 2.85:1 (fails).

Human-verifiable reference: WebAIM Contrast Checker, https://webaim.org/resources/contrastchecker/ . Treat WebAIM as the authority if values disagree.

## Lock checklist (before the interview)

- [ ] Every color has a semantic role; no color named by hue only.
- [ ] Every font is a real Google Fonts family with the needed scripts; weights listed.
- [ ] Every spacing value is a multiple of the base.
- [ ] Every text/background pair passes its threshold.
- [ ] Exactly one shadow model named.
- [ ] Mono rule stated: `none`, or `code only`, or (rare, only if the reference does it) `labels and code`.
- [ ] 5-8 motifs with zones, each marked extracted or proposed.

## Three traps

- Semantic names always: never `blue`, name by role, so the kit survives a rebrand.
- Dark variants by intentional mapping, not "invert colors".
- Logo flat and clean: never re-draw a logo, never approximate it in a prompt.
