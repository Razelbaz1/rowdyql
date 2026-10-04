---
name: hebrew-copy
description: Write or rewrite RowdyQL's Hebrew UI strings from a batch table in copy/. Use when asked to write Hebrew copy for the site, localize strings, or run a copy batch or pilot.
---

# Hebrew copy batch

Input: a batch file in `copy/`, for example `copy/pilot-01-landing-signup.md`. It is a Markdown table with the columns key, where, context, en, and sometimes "he now".

1. Read the official voice first: `raz-elbaz-brand-identity-kit/voice/voice-profile.md` (Do, Don't, and the before/after section). Then follow `.agents/rules/hebrew-copy.md`. If `copy/examples.md` has rows, read them too. They are Raz's own before/after pairs and the highest authority on tone.
2. For each row, work out the intent from `context` and `en`, then write the Hebrew directly. Do not translate the English word by word.
3. Read rows that belong together (a card title and its body, a step title and its continuation line) as one unit, so they read well together.
4. If the batch has a "he now" column and the current Hebrew is already natural, keep it exactly and write `keep` in the note.
5. Write the result to a new file next to the batch, named `<batch name>-gemini.md`, with this table:

   | key | he | note |

   Use the same keys in the same order, one row per input row, with none added or dropped. Leave the note empty unless Raz needs to choose something. In that case, give up to two alternatives or name the term decision.
6. Under the table, list the 3 to 5 strings you are least sure about, with one line each on why. Before you hand it over, run the quick test at the bottom of the voice profile on every string.
7. Do not edit any other file.
