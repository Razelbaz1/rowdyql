# Adapter - web page

Template (add-on). Fill every `{{...}}` from kit.json. Recycled from brand-studio's token-driven landing-page template (tokens copied into `:root`, RTL-first, entrance motion) and the structure of Ben's patterns.css (canvas, deco placement, print and email flags).

## Purpose and when to attach
Landing pages, one-pagers, simple sites, GitHub Pages. Attach with `core.md` and `design-tokens.css` when the request is "build a page / site / landing ...". Not for app UI; no component library.

## Format specs
- Single self-contained HTML file: tokens inlined in `:root`, CSS and JS inline, Google Fonts the only external request (plus images from `assets/`).
- Content max width {{--maxw or 1080}}px; body >= {{typography.floors.web}}px; h1 clamp(34px, 5vw, 58px).
- Responsive: one breakpoint at 720px; mobile first; images with width/height attributes.
- Accessibility: semantic landmarks, focus ring {{--focus-ring}}, contrast per Core 2, `prefers-reduced-motion` honored.
- RTL when the kit is Hebrew: `dir="rtl"`, logical CSS only (`margin-inline`, `inset-inline`).

## Core in this medium
- Colors: page {{color.bg}}; sections alternate bg / surface; one dark band ({{color.depth}}) for a quote or CTA; accent on links, buttons, one highlighted word per hero.
- Type: heading family for h1-h3, kickers, labels; body family for paragraphs and buttons; mono per Core 3 rule.
- Tokens: cards radius {{tokens.radius.lg}}px with {{tokens.border.width_px}}px border and the Core shadow model; buttons radius {{tokens.radius.pill or md}}px, shadow model on hover; spacing scale for all gaps.
- Motifs: hero gets 1-2 large motifs in corners (absolute, `aria-hidden`); section dividers may use one; body text areas get none. Tiled motifs only as a faint background field at low opacity.
- Logo: header start edge, height 40px; footer name line.
- Imagery: hero image per Core 6/7 at 16:9 or 3:2 from `assets/`; cards may carry icons or small illustrations in the same style.

## Layouts
1. **Landing** - sticky header (logo, one CTA), hero (kicker, h1 with highlighted word, deck, CTA, hero image or motif composition), 3 benefit cards, one dark quote band, CTA section, footer.
2. **One-pager** - header, hero, a single long article column with h2 markers and callouts, contact card, footer.
3. **Gallery / catalog** - header, intro, responsive card grid (2-4 columns), filter chips optional, footer.

## Rules and gotchas
- Every color is a token; no raw hex in component CSS beyond the `:root` block.
- Hover: lift 2px and raise one shadow level; press: sink; nothing idle, nothing blinking.
- Reveal-on-scroll with IntersectionObserver, staggered 60-90ms, transform + opacity only.
- Images: `loading="lazy"` below the fold; alt text always.
- Never Inter/Roboto/Arial fallbacks as the visible face; system-ui is the fallback stack.

## Drop from Core here
- Print rules (unless the page has a print stylesheet), email constraints, slide floors.

## Usage prompt (copy-paste, attach with core.md and design-tokens.css)
```text
Read core.md, adapters/web-page.md and design-tokens.css. Build a <landing page | one-pager | gallery> for: <purpose>, with these sections: <list>. Use layout <1 | 2 | 3>. One self-contained HTML file, tokens copied into :root, RTL-correct if the kit is Hebrew, motifs from motifs/ inline as SVG in the hero corners only, hero image path assets/<name>.jpg as a placeholder if not generated yet. Copy in the kit language. Then run the done-check and the Core gate and list results.
```

## Done-check
1. Every color used is a token from `:root`; fonts from the Core stack only.
2. Body >= web floor; h1 within the clamp; contrast passes.
3. Motifs only in hero corners and dividers; none behind body text.
4. Direction and logical CSS correct; focus ring visible; reduced motion honored.
5. Logo in header start edge; footer name line present.
6. Page validates as a single file with no external CSS or JS.
