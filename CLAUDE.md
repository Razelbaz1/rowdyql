# RowdyQL

Course site in Hebrew and English. Source is `src/page.html`; `python build.py` wraps it into `index.html` (see README.md).

## Voice (official, approved by Raz 2026-09-30)

- Every text a student or reader sees follows the official voice: site strings, lessons, emails, notices and posts. Hebrew: `raz-elbaz-brand-identity-kit/voice/voice-profile.md`. English: `raz-elbaz-brand-identity-kit/voice/voice-profile-en.md`. The mechanics (plural address, button nouns, terms, placeholders) are in `.agents/rules/hebrew-copy.md`. Raz's own before/after pairs in `copy/examples.md` outrank both.
- To write or review copy, use the `rowdyql-voice` skill.
- New or long copy (a lesson, an email, a post, a set of site strings): first offer to hand it to Antigravity with the `ag-handoff` skill. If Raz agrees, review AG's draft with `rowdyql-voice` before it ships. Small edits stay with `rowdyql-voice`.
- `python build.py` runs `raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py` and stops on new voice errors. Fix the text. Never pass `--allow-voice` unless Raz explicitly approved that text.
- Before committing copy changes, run `python raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py --changed` and review every changed string with the skill's review mode. Show Raz new or changed copy before it ships.
- Never edit the voice profiles without Raz. His corrections go into `copy/examples.md`, and a profile change gets a new version line.
