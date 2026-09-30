# RowdyQL voice kit

The official voice of the site, approved by Raz on 2026-09-30.

| File | What it is |
|---|---|
| `voice-profile.md` | The Hebrew voice (official): the persona, Do/Don't, decisions, before/after examples and the quick test |
| `voice-profile-en.md` | The English voice, derived from the Hebrew one |
| `analysis-raz.md` | How Raz writes, from 568 of his own messages |
| `analysis-walla.md` | The craft of 30 Walla columns (craft only, no content) |
| `metrics.md` | Numbers behind both (sentence length, punctuation, marker words) |
| `sources.md` | The 30 articles, with links |
| `scripts/voice_check.py` | The mechanical gate. `build.py` and a Claude Code hook run it |
| `voice-baseline.json` | Violations already on the site when the voice was approved. They don't block until someone edits them |
| `voice-allow.json` | Optional. Exceptions Raz approved: `{"<source>\|<key>\|<check>": "reason"}` |
| `scripts/extract_raz.py`, `fetch_article.py`, `metrics.py` | How the sources were built (reproducible) |
| `corpus/`, `raz-sample/` | Raw sources, local only (`.gitignore` in this folder) |

## How the voice is enforced

1. **Every writer reads it.** Claude Code does it through `CLAUDE.md` and the `rowdyql-voice` skill. Antigravity does it through `.agents/rules/hebrew-copy.md` (always on) and `.agents/skills/hebrew-copy/SKILL.md`.
2. **A script blocks the checkable part.** `python build.py` stops on any new or edited string that breaks a mechanical rule. The PostToolUse hook in `.claude/settings.json` shows the error to Claude right after the edit.
3. **A review covers the rest.** `python voice/scripts/voice_check.py --changed` lists changed strings for the skill's review mode (the six-question quick test). Raz approves.
4. **Raz's corrections feed back.** They go into `copy/examples.md`, and the profile gets a new version when a correction reveals a new rule.

## Moving this folder

The folder can move, for example into the brand identity kit. Paths to it live in these files. Update all of them, then run the check:

- `build.py` (the `VOICE_CHECK` constant)
- `.claude/settings.json` (the hook command)
- `CLAUDE.md`, `README.md`, `.agents/rules/hebrew-copy.md`, `.agents/skills/hebrew-copy/SKILL.md`, `.claude/skills/rowdyql-voice/SKILL.md`
- The path mentions inside this folder's own files (search for `voice/`)

`python <new path>/scripts/voice_check.py` reports an `ERROR pointer` for every file that still names the old path, and `python build.py` refuses to run until they are all fixed. The folder must stay inside the rowdyql repo, because the checker looks for `build.py` and `src/page.html` above it.
