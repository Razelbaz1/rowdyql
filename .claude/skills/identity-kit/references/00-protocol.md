# 00 - Protocol (the law of this skill)

Adapted from Ben's brand-skill build protocol (session 5 kit). Every step of identity-kit obeys these rules.

## 1. Gather before asking

Search what the student gave you, in this order, and record exact file paths:
1. Reference image(s) - required.
2. Logo - image or SVG, if any.
3. Existing materials - a design-system file, tokens, fonts list, old posts, a website.
4. Liked examples and notes.

From these extract concrete values: numbers over adjectives. Hex by role, font family names, spacing and corner style, the logo file path, and whether the content is Hebrew and right-to-left.

## 2. Never invent, never summarize

There are only two legal ways to move a value into the kit:
1. **Point at the source and inject verbatim** - when the value lives in a file (logo path, an existing tokens file), reference the path and copy the exact value.
2. **Copy byte-faithful, then diff-check** - when a value must be transcribed, copy it as found and confirm every value survived.

Never a summarizing copy. Re-describing a brand in your own words silently drops constraints.

A value that is not in the reference and not answered by the student is written as `not defined`. The one exception is motifs: the kit always carries motifs (see rule 5).

## 3. When something is missing, ask - one question at a time

Ask in Hebrew, short, one question per message. Do not ask about anything you already found. Do not batch ten questions. Rich input means fewer questions, not zero questions.

## 4. Literal values, no substitution (the no-replace rule)

Every hex and font goes into every file as a literal string: `#1A1A1A`, `Rubik`. A short descriptor may accompany a value ("#1A1A1A, warm charcoal"). The ban is on substitution ("warm charcoal" instead of the hex), not on description.

## 5. Motifs: propose, render, iterate

If the reference has fewer than 5 recurring decorative shapes, propose candidates that follow the reference's shape language (radius, line weight, fill logic). Render each one (an inline SVG, or an HTML/CSS shape) and show the set. Ask "which stay, which go, what to change". Repeat until the student approves 5-8. Approved motifs are saved as `motifs/<name>.svg` or documented as CSS recipes in core.md section 5. Motifs are never left `not defined`.

## 6. Right tool for precision

Never spend an image generator on a mark, type, or exact geometry. Logos, motifs, title cards, anything color-exact or letter-exact is built as SVG or HTML/CSS. Image generation is only for organic imagery code cannot make: scenes, characters, backgrounds, textures.

## 7. The assets loop

For every raster image the kit needs, write: purpose, the ready prompt (with the image-style-block inlined), the exact target path `assets/<name>.<ext>`, the aspect ratio and size. Record it in `assets/ASSETS.md` with status `pending`. The student generates it in their generator and drops it at that path; on the next run, or when told, mark it `done`. Judge a generated image by family of colors and style, never by exact hex (JPEG compression shifts fills).

## 8. Test contract

A kit is alive when one output produced from `core.md` + one adapter passes the Core gate (core.md section 11) with every check yes. Run this mentally on each adapter's usage prompt before reporting done.

## 9. Diff before overwrite

Existing file in the target folder: show the diff, wait for yes. No silent regeneration. Core files are never regenerated in add-adapter mode.
