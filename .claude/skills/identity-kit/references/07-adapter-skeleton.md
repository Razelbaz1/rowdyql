# 07 - Adapter skeleton and writing rules

An adapter is a short file (30-50 lines) that says how the Core lands in one medium. It never repeats the Core; it points to Core sections and adds only what the medium changes. The student attaches `core.md` + one adapter to any request.

Every adapter, fixed or add-on, uses this exact skeleton:

```markdown
# Adapter - {{medium}}

## Purpose and when to attach
{{one or two sentences: which outputs this covers; attach with core.md when ...}}

## Format specs
{{sizes, aspect ratios, safe zones, resolution, file types, technical limits of the medium: hard numbers}}

## Core in this medium
- Colors: {{which roles carry the medium; bg / surface split; accent budget}}
- Type: {{floor for this medium from Core 3; which weights; alignment}}
- Tokens: {{radius, border, shadow model as applied here, spacing rhythm}}
- Motifs: {{which motifs, how many (max), which zones for this format}}
- Logo: {{placement and size for this medium from Core 9, or "none"}}
- Imagery: {{illustration / photo rule for this medium from Core 6-7, or "none"}}

## Layouts
1. **{{layout name}}** - {{one-line recipe: zones and what sits where}}
2. **{{layout name}}** - {{...}}
3. **{{layout name}}** - {{...}}

## Rules and gotchas
- {{medium-specific rule}}
- {{...}}

## Drop from Core here
- {{Core things that do not apply in this medium, e.g. "no blur shadow in email", "no motion in print"}}

## Usage prompt (copy-paste, attach with core.md)
```text
{{a complete prompt the student pastes into any LLM, in the kit language, referencing core.md and this adapter, with the slots the student fills marked <...>}}
```

## Done-check
1. {{yes/no check}}
2. {{...}}
3. {{...}}
4. {{...}}
5. {{...}}
```

## Writing rules

- Hard numbers everywhere: px, mm, ratios, counts. "Generous margin" is banned; "margin >= 8% of the short edge" is right.
- Point to Core sections by number ("floor per Core 3") instead of copying values, except values that change in this medium (write those literally).
- Layouts are named so the student can ask for one by name ("use layout 2, quote card").
- The usage prompt is complete on its own: it names the files to read, the layout to use, the slots to fill, and ends with "run the done-check and list the results".
- Done-check items are observable yes/no facts, 4-6 of them, medium-specific; the Core gate (Core 11) runs in addition.
- Language: the kit language for the usage prompt and headings; token names and hex stay ASCII.
- No emojis, no em-dashes.
- Add-ons follow the same skeleton and land in the same `adapters/` folder. Add-adapter mode generates them one at a time.
