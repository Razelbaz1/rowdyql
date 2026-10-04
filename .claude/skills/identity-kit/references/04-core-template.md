# 04 - core.md template and fill rules

`core.md` is the medium-agnostic DNA. Every adapter, every prompt, every future output reads it. Skeleton recycled from Ben's Benefits DS contract (de-branded), plus three new sections (1, 6, 7) and the Do/Don't table format from the Deep Chrome design spine.

Fill rules apply to every section:
- Exact values only. Hex, px, font names, weights, ratios.
- A missing value is the literal text `not defined` (except section 5, which is never empty).
- Write for an LLM: rules, not moods. "Use #E10514 on max 5% of any composition" beats "a touch of red".
- Language: the kit language. Token names and hex stay English/ASCII. If Hebrew, the file is written RTL with LTR islands for code and hex (wrap with `<span dir="ltr">` only when punctuation breaks).
- No emojis. No em-dashes.

Copy the skeleton below into `core.md` and replace every `{{...}}`.

---

```markdown
# {{brand}} - Identity Core

> The one file to attach to any request. Everything visual for {{brand}} is derived from the values below. Adapters in `adapters/` say how each medium uses them. Machine view: `kit.json`. Tokens: `design-tokens.css`. Image prompts: `image-style-block.md`.
> Style family: {{style_classification}} ({{evidence in one line}}). Generated {{date}} from `source/{{reference file}}`.

## 1 - Identity

{{who}} {{what}} for {{audience}}.
Personality: **{{word1}}**, **{{word2}}**, **{{word3}}**.
Never looks like: {{never_looks_like}}.
Language: {{language}}, direction {{rtl|ltr}}.

## 2 - Color

| Role | Hex | Usage ratio | Where it goes |
|---|---|---|---|
| bg (page canvas) | {{hex}} | {{%}} | {{...}} |
| surface (cards, panels) | {{hex}} | {{%}} | {{...}} |
| soft (optional third light canvas) | {{hex or not defined}} | | alternate section background; omit the row if the reference has none |
| ink (headings, hard borders) | {{hex}} | {{%}} | {{...}} |
| text (body) | {{hex}} | | |
| muted (captions, meta) | {{hex}} | | |
| border | {{hex}} | | |
| accent (the one primary accent) | {{hex}} | {{%}} | {{...}} |
| accent-strong (hover, pressed, depth) | {{hex}} | | |
| accent-2 | {{hex or not defined}} | | |
| accent-3 | {{hex or not defined}} | | |
| accent-4 | {{hex or not defined}} | | |
| accent-5 | {{hex or not defined}} | | |
| depth (shadow color) | {{hex}} | | |
| extended (charts, SVG fills only) | {{list or not defined}} | | never on text or surfaces |

Canvases allowed: {{list, e.g. bg / surface / dark}}. Never invent a fourth.
Accent rule: {{e.g. one or two accents per composition, never all four}}.
Forbidden pairs: {{e.g. accent-2 text on bg (fails contrast); accent on accent-strong}}.
Contrast: body text on bg = {{ratio}}; ink on surface = {{ratio}}; all pairs pass AA.

## 3 - Typography

- Heading: **{{family}}** weights {{list}}. Used for headings, big numbers, kickers, labels, chips.
- Body: **{{family}}** weight {{n}}. Used for paragraphs and buttons.
- Mono: {{family, or "none"}}. Rule: {{"code and kbd only" | "none in this identity"}}.
- Google Fonts: `{{url}}` (weights pinned as listed; fetched {{date}}).
- Scale (px): {{e.g. 14 / 16 / 18 / 22 / 28 / 36 / 48}}. Ratio about {{1.25}}.
- Size floors: slide body >= {{26}}px (absolute floor 24) · web body >= {{18}}px · print body >= {{11}}pt · post headline >= {{48}}px at 1080 · caption >= {{14}}px.
- Letter-spacing: {{e.g. -0.02em on 36px and above; 0 on body}}. Case: {{e.g. sentence case; uppercase kickers}}.
- Hebrew/RTL: {{families with Hebrew glyphs confirmed}}; numbers and Latin tokens sit in LTR islands; letter-spacing never applied to Hebrew.

## 4 - Foundation tokens

- Spacing base {{4|8}}px. Scale: {{4 · 8 · 12 · 16 · 24 · 32 · 48 · 64}}.
- Radius: sm {{n}} · md {{n}} · lg {{n}} · xl {{n}} · pill 999.
- Borders: {{e.g. 2px solid ink | 1px solid border | none}}.
- Shadow model: **{{offset | blur | none}}**. Values: {{e.g. sm 3px 3px 0 0 ink · md 5px 5px 0 0 ink · lg 8px 8px 0 0 ink}} or {{e.g. 1: 0 1px 2px rgba(...) · 2: ... · 3: ... · 4: ...}}. Only this model exists in this identity.
- Motion character: {{e.g. entrance and press only, ease cubic-bezier(.34,1.56,.64,1), no idle motion}}. Respect prefers-reduced-motion.
- Texture: {{none | paper grain 4% | ...}}.

## 5 - Motif vocabulary ({{n}} approved)

| # | Name | Description | Zone | Scale | Frequency | Colors | File / recipe |
|---|---|---|---|---|---|---|---|
| 1 | {{name}} | {{one sentence geometry}} | {{corner / edge rail / behind text / between sections / full-bleed}} | {{s/m/l}} | {{once / 2-3 / tiled}} | {{hex list}} | `motifs/{{name}}.svg` or CSS: {{recipe}} |
| ... | | | | | | | |

Library: {{"none" | "motifs/<file>.svg holds N more approved motifs; the table above names the primary ones"}}.
Placement law: motifs live in zones, never scattered. Max {{2}} motifs per composition. Few big shapes beat many small ones. Every motif needs a role (highlight, divider, anchor, background field, celebration).

## 6 - Illustration style

{{not used}} or:
- Technique: {{flat vector | cel-shaded | line art | isometric | hand-drawn | 3D}}.
- Line: {{none | thin | thick}} {{hex}}. Fill: {{flat | gradient | textured}}. Shading: {{none | hard offset | soft}}. Perspective: {{flat | isometric | camera}}.
- Subjects: {{people / objects / abstract; how simplified}}. Detail level: {{low | medium | high}}.
- Palette inside illustrations: {{which roles from section 2, in which order}}.
- Forbidden: {{e.g. photoreal, 3D render, glossy highlights, gradients, text inside the image}}.

## 7 - Photo and imagery

{{not used}} or:
- Subjects: {{...}}. Lighting: {{natural daylight | studio | dramatic}}. Color treatment: {{natural | warm grade | desaturated | duotone hex+hex}}.
- Crop: {{tight | wide | centered | thirds}}. Overlay: {{none | tint hex at n% | grain}}.
- Forbidden: {{e.g. stock-photo poses, hands close-up, text in image, cold blue grade}}.

## 8 - Composition rules

- Density: {{generous | compact}}; whitespace share about {{%}}.
- Alignment: {{right (RTL) | left | centered | grid}}. Hierarchy by {{size, weight, color, boxes}}.
- Structure: {{e.g. hero + body; cards; full-bleed image + caption}}.
- Decoration and text: {{e.g. motifs in corners and rails, never behind body text; one large shape may sit behind a heading}}.
- One idea per composition. {{other habits}}.

## 9 - Logo and name

{{no logo yet}} or:
- Files: `source/{{logo}}` ({{color version}}), `source/{{logo-mono}}` ({{mono version}}). Never redraw or approximate.
- Clear space: {{n}} x {{feature}} on all sides. Minimum size: {{px / mm}}.
- Placement per medium: post {{corner}} · email {{header}} · print {{...}} · deck {{...}} · web {{...}}.
- Backgrounds allowed: {{bg, surface, accent-strong}}. Forbidden: {{...}}.
- Name protection: "{{brand}}" is never translated, split, or restyled.

## 10 - Do / Don't

| Do | Don't |
|---|---|
| {{rule}} | {{opposite or trap}} |
| {{rule}} | {{...}} |
| {{rule}} | {{...}} |
| {{rule}} | {{...}} |
| {{rule}} | {{...}} |
| {{rule}} | {{...}} |

## 11 - Non-negotiables gate (run before calling any output done)

1. Every color on the output is a role from section 2. Yes / no.
2. Only the canvases listed in section 2. Yes / no.
3. Heading and body fonts are exactly section 3; mono rule respected. Yes / no.
4. Size floors of section 3 respected for this medium. Yes / no.
5. Shadow model is the one in section 4, nowhere else. Yes / no.
6. Motifs from section 5 only, in zones, max {{2}} per composition. Yes / no.
7. Illustration or photo follows section 6 / 7 (or is absent if not used). Yes / no.
8. Logo untouched, name intact (section 9). Yes / no.
9. Nothing from the Don't column. Yes / no.
10. No emojis, no em-dashes, text legible at the medium's floor. Yes / no.
```

---

## Section-by-section fill notes

- **1 Identity**: from Q2-Q4. The counter-example is a real sentence ("never looks like a bank brochure"), not a mood word.
- **2 Color**: from extraction Part 2 after correction. Ratios are approximations that guide composition; write them. Contrast ratios come from the correction pass.
- **3 Typography**: only Google Fonts families with confirmed scripts. Floors: keep the defaults in the skeleton unless the reference clearly demands larger.
- **4 Tokens**: exactly one shadow model. If the reference is ambiguous, choose the one the primary CTA or card uses and state it.
- **5 Motifs**: from Q6, approved only. SVG file per motif when geometry matters; CSS recipe when it is a simple shape (circle, stripe, dot grid via radial-gradient).
- **6 / 7**: `not used` is valid and common. Never invent an illustration style for a photo-only brand.
- **8 Composition**: observed habits, written as rules.
- **9 Logo**: `no logo yet` is valid; then write the name-protection line only.
- **10 Do/Don't**: 6-10 rows. Each row is one observable rule. Pull the Don'ts from extraction Part 3 item 7 (forbidden by evidence).
- **11 Gate**: keep the ten checks; adjust numbers in braces only.
