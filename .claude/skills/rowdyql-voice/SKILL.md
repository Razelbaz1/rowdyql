---
name: rowdyql-voice
description: Write or review RowdyQL copy in Raz's official voice, Hebrew or English - site strings, lesson text, emails, notices, posts, anything a student or reader will see. Use whenever writing, rewriting or changing such text, and before committing copy changes. Hebrew cues - "תכתוב טקסט לאתר", "תנסח", "תבדוק את הניסוח", "בקול של האתר", "פוסט", "מייל למשתמשים". Also "voice check", "review the copy".
---

# RowdyQL voice

The official voice, approved by Raz on 2026-09-30:
- Hebrew: `voice/voice-profile.md`
- English: `voice/voice-profile-en.md`
- Mechanics (plural address, button nouns, terms, placeholders, string format): `.agents/rules/hebrew-copy.md`
- Highest authority: Raz's own before/after pairs in `copy/examples.md`

Read the profile for the language you write in before every copy task, including its before/after section. Don't work from memory of it.

## Write mode

1. Work out the intent: what the student needs from this text, where it appears, and what comes right before and after it. Write each language from the intent. Never translate one language's sentence into the other.
2. Write it the way the profile says: spoken, present tense, plural in Hebrew and "you" in English. Start from something concrete. Build, then land on a short line. Use one idiom at most. The site takes the joke. Keep real terms and make them clear.
3. Cut every sentence the student wouldn't miss.
4. Run the quick test at the bottom of the profile on every string.
5. For site strings: edit `src/page.html` (and the matching `I18N_CAMPUS` override, if one exists), then run `python build.py`. The build runs `voice/scripts/voice_check.py` and stops on a new error. Fix the text, don't work around the check.
6. For emails in `supabase/email/`: run `python voice/scripts/voice_check.py`, which scans them too.
7. For text that doesn't go into the repo (a post, a notice Raz sends from the dashboard, a message): run the quick test and show Raz the text.

## Review mode (before every commit that touches copy)

1. `python voice/scripts/voice_check.py --changed` lists every string added or changed since the last commit.
2. Review each one against the profile's quick test (six questions) and the Do/Don't lists. If you wrote the copy in this session, give the review to a subagent with fresh context: the writer shouldn't grade its own work.
3. Report a table to Raz: key | before | now | verdict (ok / fix) | rule. Propose a fix for every "fix".
4. `python voice/scripts/voice_check.py` must pass with 0 new errors. Warnings are judgment calls. Mention them.

## Rules

- Never pass `--allow-voice` to `build.py`, and never add an entry to `voice/voice-allow.json` or `voice/voice-baseline.json`, unless Raz explicitly approved that specific text.
- When Raz corrects copy, add the pair to `copy/examples.md` (before, after, why). If his correction reveals a rule the profile doesn't have, propose the profile change to him with a new version line. If the rule is mechanical, propose a check in `voice_check.py` too.
- After fixing old copy that was in the baseline, run `python voice/scripts/voice_check.py --prune` so the baseline shrinks.
- Never edit the voice profiles without Raz.
