# {{brand}} - Image style block

Paste this block, verbatim, into every image-generation prompt. Add only the subject, the composition for this image, and the aspect ratio. Recycled from Ben's toy-art scaffold; the generator cannot read the kit, so the prompt carries the brand inside it.

## The look (one paragraph, always first)

{{illustration.used ? illustration_paragraph : photo_paragraph}}

Illustration paragraph template: "{{technique}} illustration in a {{style_classification}} style: {{line description with hex}}, {{fill}}, {{shading translated: 'solid offset shadows with no blur' | 'soft diffused shading' | 'no shadows'}}, {{perspective}}, {{detail level}} detail, generous {{color.bg}} negative space."

Photo paragraph template: "Photograph, {{subjects}}, {{lighting}}, {{treatment, with duotone hex if any}}, {{crop}}, {{overlay}}."

## Palette (literal hex)

Color palette: background {{color.bg}}; primary accent {{color.accent}} with {{color.depth}} depth; secondary accents used sparingly, at most two per image: {{color.accent_2}}, {{color.accent_3}}, {{color.accent_4}}; outlines and dark elements {{color.ink}}; surfaces {{color.surface}}.

## Composition

Composition organized in clear zones, not scattered; {{composition.density}} density; subject {{composition.alignment}}-anchored; at most two large decorative shapes; {{composition.whitespace as %}} of the frame left as negative space.

## Motif flavor (pick at most {{motif_rules.max_per_composition}} per image, by description)

{{for each motif: "- " + name + ": " + description + " (" + zone + ")"}}

## Constraints

No text, letters, numbers or logos in the image. {{illustration.forbidden joined}} {{photo.forbidden joined}} Friendly and professional, never childish, never generic stock.

## Avoid line (always last)

Avoid: {{list from Core 6/7 forbidden + "hands and fingers, text artifacts, watermark, extra limbs, gradients unless specified, decorative clutter, a second style"}}.

## Format hint

State orientation in words ("wide 16:9 banner", "square icon") and set the generator's aspect ratio and size. Drafts 1K, deliverables 2K, print 4K.

## Theme sets

To make several images that read as one family: keep this whole block identical, keep the same composition rule, vary only the subject line. Generate one, judge it, then run the rest.
