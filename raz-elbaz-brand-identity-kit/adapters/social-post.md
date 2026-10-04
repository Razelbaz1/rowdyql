# Adapter - social post and share image

## Purpose and when to attach
Single-image posts (Instagram, LinkedIn, Facebook, WhatsApp status) and the site's share image (og image). Attach with `core.md`, `voice/voice-profile.md` and `design-tokens.css` when the request is "make a post about ..." or "make the share image".

## Format specs
- Sizes: square 1080x1080 (1:1) · portrait 1080x1350 (4:5, feed default) · story 1080x1920 (9:16) · LinkedIn 1200x627 · share image 1200x630.
- Safe zones: text and logo inside the middle 90% of the width; on 9:16 keep the top 250px and the bottom 300px free of text.
- Floors at 1080 wide: headline 48px (Rubik 800), body 32px (Heebo 400), caption and mono eyebrow 26px. At most 3 text sizes per post.
- Export PNG from a single HTML file sized exactly to the format (screenshot at 1x or 2x). One idea per post.

## Core in this medium
- Colors: canvas bg #F7F2EC or one one-hue wash (wash-sky by default; wash-flow only when the post shows a source and a result); dark posts on #11161B or a dark wash. Diagrams sit on a surface panel #FDFBF8 (dark #182027) with a 1px #DDD7CF rule, never straight on a wash. Neon on at most 10% of the area, on the result only. Text on a wash is ink #373C44 or muted #5F6670.
- Type: headline Rubik 800, at most 15 characters per line in Hebrew; body Heebo 400; a Latin eyebrow in IBM Plex Mono 500 uppercase +0.14em as an LTR island ("RowdyQL · 01 / 12"). Hebrew aligns right; diagrams and the url stay LTR.
- Tokens: radius 0; border 1px #DDD7CF; shadow none; glow only on the one result point (digital).
- Motifs: 1-2 from Core 5: the schema map as the big visual, a data line, a progress ring, or a legend strip at the foot. Never behind the headline.
- Logo: bottom corner opposite the reading start (Hebrew post: bottom-left), lockup height 65px at 1080 (6% of the short edge), on the foot row. Light canvas: `logo/rowdyql-logo-light.svg`; dark canvas: `logo/rowdyql-logo-dark.svg` (digital, glossy). The url `rowdyql.com` in mono on the same foot row.
- Imagery: optional; a generated illustration (Core 6) takes one half of the canvas, text the other (layout 3).

## Layouts
1. **Statement** - eyebrow, one headline (max 8 words) on a one-hue wash, one motif in the free zone, foot row (1px rule, url, logo).
2. **Diagram post** - eyebrow, headline, the schema map (or a data line diagram) on a surface panel filling the middle, foot row with the url, a short Hebrew line and the logo. This is the board's post.
3. **Split** - a generated illustration on the left half (data flows toward the text), headline and one line of body on the right half on bg; no motif on the image half.
4. **Share image (1200x630)** - the share background from `assets/share-bg.png` (or bg #F7F2EC), headline on the right in Rubik 800 at 56px or more, the light logo bottom-left, the url in mono.

## Rules and gotchas
- All copy follows voice/voice-profile.md; run its quick test before calling it done.
- One idea per post; a second idea is a second post.
- Charts in a post follow the chart modes in Core 5 and sit on bg or surface.
- Hebrew: no letter-spacing, no all-caps; numbers, SQL and table names in LTR islands; no number, colon and inline code side by side in one sentence.
- Hashtags and captions live in the caption field, never on the image.
- Never put text inside a generated image; set it in HTML over the image.

## Drop from Core here
- Print floors and print rules, email constraints, motion (posts are still images; the GIF top bar is the only animated logo allowed outside the site).

## Usage prompt (copy-paste, attach with core.md, voice/voice-profile.md and design-tokens.css)
```text
Read core.md, adapters/social-post.md, voice/voice-profile.md and design-tokens.css. Build a <1:1 | 4:5 | 9:16 | share 1200x630> post about: <topic>. Headline: "<text>" (or write one in Hebrew in the official voice, max 8 words). Use layout <1 Statement | 2 Diagram post | 3 Split | 4 Share image>. Output one self-contained HTML file sized exactly to the format, tokens copied from design-tokens.css into :root, motifs inlined from motifs/, the logo inlined from logo/ (light or dark file per the canvas), ready to screenshot. Run the voice profile's quick test on every line, then the done-check below and the gate in core.md section 11, and list the results.
```

## Done-check
1. Canvas size matches the chosen format exactly.
2. Headline at or above 48px at 1080; at most 3 text sizes; every line passed the voice quick test.
3. 1-2 motifs, in their zones, none behind text; any diagram sits on a surface panel.
4. Logo in its Core 9 position, the right file for the canvas, url on the foot row.
5. Text on the canvas is ink or muted and passes contrast; neon only on the result.
6. One idea; nothing inside the safe-zone margins.
