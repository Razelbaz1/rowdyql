# Raz Elbaz / RowdyQL - Brand Identity Kit

Your visual identity as files any LLM can read. Attach one or two files to any request and get output in your style, no re-explaining. The kit files are in English; outputs are Hebrew first (RTL, with LTR islands for tables, expressions, code and diagrams) or English.

## What is in the folder

| File | What it is | When to attach |
|---|---|---|
| `core.md` | the DNA: color, type, shapes, motifs, illustration, photo, composition, logo, do/don't, the gate | always |
| `kit.json` | the same data, machine view (light theme in `color`, dark in `x_dark`) | when a tool wants JSON |
| `design-tokens.css` | tokens as CSS, light and dark | anything built in code |
| `image-style-block.md` | style block for image prompts (Gemini, Nano Banana) | when generating an image |
| `showcase.html` | a page that renders the identity in light and dark, open in a browser | to show, check, share |
| `motifs/` | the 8 approved motif SVGs (theme-aware when inlined) | when building in code |
| `logo/` | the approved logo files: light, dark glossy, dark flat, intro, icons, top bar SVG and GIF | every output with the logo |
| `voice/` | the official voice: `voice-profile.md` (Hebrew), `voice-profile-en.md` (English) and `scripts/voice_check.py`; moved in from the repo root | every output with text |
| `assets/` | images you generate per `assets/ASSETS.md` | as needed |
| `adapters/image.md` | single image | with core.md |
| `adapters/social-post.md` | social post and share image | with core.md |
| `adapters/email.md` | branded email | with core.md |
| `adapters/booklet-print.md` | booklet and print (A4) | with core.md |
| `adapters/deck.md` | slides for class | with core.md |
| `adapters/web-page.md` | the site (landing and lessons) and one-off pages | with core.md |
| `adapters/quiet-tier.md` | formal letters, certificates, university documents, invoices | with core.md and the medium's adapter |
| `templates/` | ready HTML shells with your tokens: `email-shell.html`, `booklet-shell.html` (A4) | when building an email or booklet |
| `source/` | your original references (reference image, direction board, old site screenshots), untouched | never attach |

## Four usage prompts

**1. Produce an output in my style** (attach `core.md` + the adapter, and `voice/voice-profile.md` when the output has text)
```text
Read core.md and adapters/<medium>.md, and voice/voice-profile.md if the output has text. Build <what you want> using layout <number or name> from the adapter. Every color, font and motif only from these files; every line of copy in the official voice. Finish by running the adapter's done-check and the gate in core.md section 11, and list the results.
```

**2. Write an image prompt** (attach `image-style-block.md`)
```text
Write a complete image-generator prompt for: <subject>. Use the style block from image-style-block.md verbatim; add only the subject, the composition and the aspect ratio <ratio>. No text inside the image.
```

**3. Restyle an existing file** (attach `core.md`, `design-tokens.css`, the file)
```text
Read core.md and design-tokens.css. Restyle the attached file to live inside this identity. Content stays, look changes. Every color is a token, every font from the stack, every spacing on the scale. Before changing anything, show what will change and wait for approval. End with a before/after list.
```

**4. Check an output against the identity** (attach `core.md` + the output)
```text
Read core.md section 11. Review the attached output and answer each check yes or no with a one-line reason. Summarize: pass, partial, fail. If fail, list the three smallest fixes that get it to pass.
```

## Add an adapter later
Open a chat with the identity-kit skill, give it this folder's path, and say "add adapter <name>". It reads core.md and adds only the missing file.

## Images not yet generated
See `assets/ASSETS.md`: each image has a ready prompt and a target path (booklet cover, landing hero, share background, and the email header logo rendered from the SVG). Generate, save at the path, mark done.

Generated 2026-10-05 from `source/reference.jpg` and the approved direction board `source/direction-board.html`.
