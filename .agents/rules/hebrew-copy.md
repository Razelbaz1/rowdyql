---
trigger: always_on
---

# Hebrew UI copy for RowdyQL

RowdyQL is a databases and SQL course site for Israeli students, taught from zero. Raz, the course TA, owns every word. His wording always wins, and his own before/after pairs in `copy/examples.md` override everything in this file.

**The official voice.** How the copy should sound is defined in `raz-elbaz-brand-identity-kit/voice/voice-profile.md` (Hebrew, approved by Raz on 2026-09-30) and `raz-elbaz-brand-identity-kit/voice/voice-profile-en.md` (English). Read the profile before you write anything. This file covers the mechanics. The profile covers the voice: concrete openings, a short line that lands, one idiom at most, the site takes the joke, and no colons used as slogans. Your proposals are checked against both, by script and by review, before Raz sees them.

## The one rule

Write the Hebrew from the intent. Never translate the English sentence. The English column tells you what the string means; the context column tells you where it appears and who reads it. Ask how a good Israeli TA would say this out loud to a student in class, write that, then cut every word that adds nothing.

## Rules

1. **Address the reader in plural** (אתם): לחצו, עברתם, תמצאו. Never mix singular and plural in one string. No slash forms (מסכים/ה): rephrase instead, for example with a gender-neutral past tense (קראתי ואישרתי). One exception (Raz, 2026-10-08): the sign-up confirmation email speaks to the reader in the singular, by the gender chosen at sign-up, and stays plural when there is none.
2. **Buttons and links use an action noun** (שם פעולה): הרשמה, כניסה, הרצה, בדיקה, איפוס, המשך. Not an imperative (הרץ, בדוק, דלג). First person is fine when the student is making a statement (שכחתי סיסמה, כבר יש לי חשבון). When a sentence mentions a button, quote its label: לחצו על 'בדיקה'. Exception (Raz, 2026-09-30): the one or two landing-page buttons that invite sign-up may be a short present-plural phrase, like the live "מכאן מתחילים" and "פותחים חשבון, דקה אחת".
3. **One idea per sentence.** No comma splices: if two clauses could stand alone, use a period or a real connective (ו, אבל, כי, אז). Wrong: "היא נשמרת כגיבוב, אף אחד לא יכול לקרוא אותה, גם לא אנחנו."
4. **No calques from English.** These came from translating and sound foreign: "ננסה לחיות איתה" (live with it), "הכל נשמר לחשבון" (saved to your account), "ענפים שלא הוטלו על אותן עמודות" (projected onto).
5. **Normal Hebrew word order.** Wrong: "רואה את זה רק צוות הקורס". Right: "רק צוות הקורס רואה את זה".
6. **Spoken register, not a form.** Avoid: נקלט/ה, יש ל..., אנא, הנך, ניתן, במידה ו, על מנת, לבירור, בוצע בהצלחה. Prefer: אפשר, צריך, כדי, אם.
7. **Minimal.** If removing a sentence loses no information, remove it. Never state the obvious (a signed-in student knows it is their account). A greeting is the greeting plus the first name.
8. **Headlines hook, they do not describe.**
9. **Keep facts exact.** Privacy lines, numbers, promises: same facts, new wording. Never promise use on multiple devices.

## Terms

- SQL keywords, table names and column names stay in English (SELECT, JOIN, Students, StudentID).
- Hebrew terms used on the site: טבלה, שורה, עמודה, שאילתה, סכמה, מופע, מפתח ראשי, מפתח זר, צירוף (join), הטלה (projection), בחירה (selection), גיבוב (hash), אלגברה רלציונית.
- Real terms stay, even in an intro: explain them, never drop them (Raz: "המילה רלציוני חשובה").
- Slang (Raz, 2026-09-30): gentle slang is fine, one per string: בול, יושב, כיף, סבבה, על הדרך. Not יאללה, אחי, וואלה.
- Open decision, keep the site's current choice until Raz decides: אימייל vs מייל.

## Format

- Keep placeholders ({n}, {e}, {d}, {s}) and HTML tags (<b>, <code>, <a ...>) exactly as they are.
- Keep symbols as they are (σ π ⋈ ÷ ∪ ∩ ✓).
- Quotes inside a string use single quotes: 'כלום עדיין'. Never use double quotes inside a string.
- No text emoticons such as ":(" (they flip in right-to-left text).
- Buttons: 3 words at most. Other strings: about as long as the current Hebrew, or shorter.

## Boundaries

- Never edit `src/page.html`, `index.html` or any file outside `copy/`. Never run git. Write proposals to a file in `copy/` only.
- Claude (in Claude Code) applies the strings Raz approves, builds the site, checks it on screen and deploys it.

## Before you hand it over

Read each string in your head as spoken Hebrew. Would Raz say it to a student? Is any English sentence structure left? Is gender or number mixed? Are placeholders and tags intact?
