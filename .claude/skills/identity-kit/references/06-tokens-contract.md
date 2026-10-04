# 06 - design-tokens.css contract

`design-tokens.css` is a single `:root{}` block. Block 1 keeps the exact token names of Ben's brand-studio plugin, so its carousel and landing-page skills can read this file unchanged. Block 2 adds what a cross-media identity needs. Every value is a literal from kit.json; no invention, no blending.

## Block 1 - brand-studio compatible names (always present)

```css
:root{
  /* colors */
  --bg: {{color.bg}};
  --surface: {{color.surface}};
  --ink: {{color.ink}};
  --muted: {{color.muted}};
  --accent: {{color.accent}};
  --accent-strong: {{color.accent_strong}};
  --border: {{color.border}};
  --success: {{color.success or accent}};
  --warning: {{color.warning or accent_2 or accent}};
  --danger: {{color.danger or accent_3 or accent_strong}};
  /* typography  (Google Fonts: {{typography.google_fonts_url}}  fetched {{meta.fonts_fetched}}) */
  --font-head: '{{typography.heading.family}}', system-ui, sans-serif;
  --font-body: '{{typography.body.family}}', system-ui, sans-serif;
  /* radius */
  --radius-sm: {{tokens.radius.sm}}px;
  --radius: {{tokens.radius.md}}px;
  --radius-lg: {{tokens.radius.lg}}px;
  --radius-pill: 999px;
  /* shadow ramp, ONE model */
  --shadow-1: {{tokens.shadow.values.1}};
  --shadow-2: {{tokens.shadow.values.2}};
  --shadow-3: {{tokens.shadow.values.3}};
  --shadow-4: {{tokens.shadow.values.4}};
  /* layout */
  --maxw: {{1080}}px;
}
```

Status colors: if the reference defines none, map them from the accent family as shown in the placeholders and add the comment `/* derived from accents, not extracted */`.

## Block 2 - identity additions

```css
:root{
  --text: {{color.text}};
  --depth: {{color.depth}};
  --accent-2: {{color.accent_2 or "var(--accent)"}};
  --accent-3: {{color.accent_3 or "var(--accent)"}};
  --accent-4: {{color.accent_4 or "var(--accent)"}};
  --accent-5: {{color.accent_5 or "var(--accent)"}};
  --font-mono: {{"'family', ui-monospace, monospace" or "none"}};
  --border-w: {{tokens.border.width_px}}px;
  --border-line: var(--border-w) {{tokens.border.style}} var(--{{tokens.border.color}});
  --radius-xl: {{tokens.radius.xl}}px;
  --space-1: 4px; --space-2: 8px; --space-3: 12px; --space-4: 16px;
  --space-5: 24px; --space-6: 32px; --space-7: 48px; --space-8: 64px;
  --ease: {{tokens.motion.ease}};
  --focus-ring: 3px solid var(--accent);
  --floor-web: {{typography.floors.web}}px;
  --floor-slide: {{typography.floors.slide}}px;
  --floor-caption: {{typography.floors.caption}}px;
}
```

## The shadow-model rule

`tokens.shadow.model` decides all four ramp values. Only one model exists per kit:

| model | --shadow-1 | --shadow-2 | --shadow-3 | --shadow-4 |
|---|---|---|---|---|
| offset | `2px 2px 0 0 var(--depth)` | `4px 4px 0 0 var(--depth)` | `6px 6px 0 0 var(--depth)` | `8px 8px 0 0 var(--depth)` |
| blur | two-layer tinted, sub-0.1 alpha, rising | ... | ... | ... |
| none | `none` | `none` | `none` | `none` |

Offset values above are defaults; if the reference shows its own offsets (for example 3/5/8), use those. Blur values are tinted toward `--depth` or `--ink`, never pure black.

## Rules

- Names in Block 1 never change (contract with brand-studio consumers).
- `--font-mono: none` is a legal value; consumers must not use mono when it is `none`.
- Every hex is copied literally from kit.json. Any derived value carries an inline comment saying so.
- The same block is inlined into `showcase.html`, the email shell, and the booklet shell, so each stays a single self-contained file.
