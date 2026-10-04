---
name: identity-kit
description: Builds a student's personal, cross-media brand identity kit from a reference image. Extracts palette, typography, shapes, motifs, illustration and imagery style, composition rules; interviews the student in Hebrew (one question at a time); then emits a folder "<brand>-brand-identity-kit" with core.md (medium-agnostic DNA), kit.json, design-tokens.css, image-style-block.md, showcase.html, and short adapters per output type (image, social post, email, booklet/print, plus add-ons). Never invents brand facts; never builds UI component libraries. Also re-runs on an existing kit to add a missing adapter. Trigger on: "identity kit", "identity-kit", "brand kit from image", "my visual identity", "build my identity kit", "add adapter", and Hebrew cues "ערכת זהות", "ערכת מותג", "תבנה לי ערכת זהות", "הזהות הוויזואלית שלי", "מערכת עיצוב מתמונה", "תוסיף אדפטר", "בסגנון שלי".
---

# identity-kit - personal cross-media identity from one reference image

You turn a student's reference image into a folder of files that any LLM can read and then produce on-brand output in any medium, with no further explanation. The folder has one medium-agnostic **Core** and short **adapters** per output type. This is NOT a UI design system: no buttons, no menus, no component library, no Storybook.

Primary reader of every file you generate is an LLM. Write explicit rules and exact values (hex, px, font names, weights). No vague mood prose.

## Environment check (first thing)

- **Claude Code / filesystem available:** write real files into the output folder (section 5).
- **claude.ai chat / no filesystem:** deliver every file as its own code block, headed by its relative path (for example `core.md`, `adapters/email.md`). Same content, same order. The student saves them into a folder with that structure.

## Hard rules (read `references/00-protocol.md`, they are the law)

1. **Never invent brand facts.** Extract from the reference, or ask. A field you cannot fill is written as `not defined`, except motifs (rule 4).
2. **One question per message**, Hebrew, plain language. Do not ask what the materials already answer.
3. **Literal values, no substitution.** A hex is written as `#1A1A1A`, a font as `Rubik`. A short descriptor may accompany a value; it never replaces it.
4. **Motifs always exist.** If the reference shows no recurring shapes, propose 5-8 candidates, render them (SVG or HTML/CSS), show them, and iterate until the student approves.
5. **Image is mandatory.** No reference image, no kit. Named styles without an image are refused politely.
6. **You never generate raster images.** For every non-SVG visual you write a ready prompt plus the exact target path under `assets/`; the student generates it and drops it there.
7. **One shadow language and one mono rule per kit.** Whatever the reference shows, pick one and state it.
8. **Never blend two styles.** One reference set, one identity.
9. **Never overwrite an existing kit file** without showing a diff and getting an explicit yes.
10. No emojis in generated files. No em-dashes; use hyphens or commas.

## Runtime procedure

### Step A - Gather
Ask for: the reference image(s) (required), a logo file if one exists, any existing materials, and where to save. Accept attachments or a folder path.
If the target folder already contains `core.md` and `kit.json`, switch to **Add-adapter mode** (section 6).
Copy every original into `source/` untouched.

### Step B - Extract
Run `references/01-extraction-prompt.md` on the reference: Part 1 style classification with evidence, Part 2 tokens, Part 3 decoration pass (shapes as decoration, motif candidates, illustration style, imagery mood, composition habits, density, motion character), Part 4 logo read (if a logo was given).
Then run `references/02-correction-pass.md` (snap spacing, real Google Fonts with Hebrew support when the kit language includes Hebrew, one accent hierarchy, WCAG contrast on every text/background pair).
Hold the result as a draft `kit.json` in memory. Mark every unknown leaf `not defined`.

### Step C - Interview
Follow `references/03-interview-script.md`. Pre-fill from Step B. Tier 1 (max 7 questions), then the refinement gate, then optional tier 2. Rich input (image + logo + materials) usually needs only questions 1, 4, 6, 7.
Question 6 is the motif loop: show the extracted or proposed motifs rendered, ask for approval or corrections, repeat until approved.

### Step D - Plan gate (STOP)
Show the student, in Hebrew: the identity paragraph, the palette table (role, hex), the fonts, the approved motif list, the shadow model and mono rule you chose, and the list of files you will create (fixed base + the add-ons their answers turned on). Wait for an explicit yes.

### Step E - Emit
Generate in this order, each file from its template in `references/` or `templates/` plus the draft kit.json only:
1. `core.md` from `references/04-core-template.md`
2. `kit.json` per `references/05-kit-schema.json`
3. `design-tokens.css` per `references/06-tokens-contract.md`
4. `image-style-block.md` from `templates/image-style-block.template.md`
5. `motifs/*.svg` for every approved motif that is an SVG (CSS-recipe motifs are documented in core.md section 5 instead)
6. `adapters/image.md`, `adapters/social-post.md`, `adapters/email.md`, `adapters/booklet-print.md` from `references/adapters/` (fixed base), then every add-on adapter the interview turned on
7. `templates/` filled shells, only when the matching add-on is on (email shell is part of the fixed base)
8. `assets/ASSETS.md` manifest: every image the kit expects, its purpose, its ready prompt, its target path, status `pending`
9. `showcase.html` from `templates/showcase.template.html`
10. `README.md` from `references/08-readme-template.md`

### Step F - Verify
- Run the Core gate (core.md section 11) as a checklist against each adapter's usage prompt: every adapter must be satisfiable under the gate.
- Open `showcase.html` (Claude Code: `Start-Process showcase.html` on Windows, `open` on macOS). Confirm fonts load, swatches match kit.json, motifs render, RTL/LTR direction is correct.
- Print the list of `not defined` fields and the list of `pending` assets with their prompts, in Hebrew, so the student knows what to fill next.
- Report done with the folder path.

## Fixed base vs add-ons

Fixed base, always: `README.md core.md kit.json design-tokens.css image-style-block.md showcase.html motifs/ assets/ASSETS.md adapters/{image,social-post,email,booklet-print}.md templates/email-shell.html source/`.
Add-ons, only when the interview turns them on: `adapters/{deck,carousel,web-page,document-pdf,icons,video,zoom-background,mascot,quiet-tier}.md` and `templates/booklet-shell.html`.

## Add-adapter mode

Triggered when the target folder already holds `core.md` + `kit.json`, or when the student says "add adapter" / "תוסיף אדפטר".
1. Read `core.md` and `kit.json`. Do not re-extract, do not re-interview beyond the one question the new adapter needs (for example print sizes for `booklet-print`, generator name for `image`).
2. Generate only the missing `adapters/<name>.md` (and its `templates/` shell if it has one) from the reference template.
3. Append the new adapter to `README.md`'s file list, showing the diff first and waiting for yes.
4. Never touch `core.md`, `kit.json`, `design-tokens.css`, or `showcase.html`.

## Language rules

- Conversation with the student: Hebrew, simple, one idea per line.
- Generated kit content: the language chosen in question 1 (Hebrew RTL, English, or bilingual: English token names, descriptions in the chosen language).
- Internal instructions in this skill: English.

## Knowledge map (`references/` and `templates/`)

| File | Use it for |
|---|---|
| `references/00-protocol.md` | the never-invent / one-question / literal-value / test-contract law |
| `references/01-extraction-prompt.md` | Step B, parts 1-4 |
| `references/02-correction-pass.md` | Step B correction + WCAG formula |
| `references/03-interview-script.md` | Step C questions, tiers, branching |
| `references/04-core-template.md` | core.md section template + fill rules |
| `references/05-kit-schema.json` | kit.json shape |
| `references/06-tokens-contract.md` | design-tokens.css names and shadow-model rule |
| `references/07-adapter-skeleton.md` | the 8-part adapter skeleton and writing rules |
| `references/08-readme-template.md` | student README + 4 usage prompts |
| `references/adapters/*.md` | one template per adapter (fixed + add-ons) |
| `templates/showcase.template.html` | showcase page |
| `templates/email-shell.template.html` | table-based email chrome with token placeholders |
| `templates/booklet-shell.template.html` | scroll booklet shell with A4 print recipe |
| `templates/image-style-block.template.md` | reusable image-prompt style block |
| `examples/marko/` | a complete kit generated from Marko Memphis values (regression reference, never a source of values for other kits) |

## Boundaries

- Never edit source repos or other skills. Copy, never modify.
- Never pull values from `examples/marko/` into a student's kit.
- Never produce UI component inventories.
- Never send, publish, or upload anything.
