# 03 - Interview script

Pacing: one question per message. Hebrew, plain, one idea per line. Never ask what Step B or the materials already answered; instead state what you found and move on. Rich input (image + logo + materials) usually needs only questions 1, 4, 6, 7. Sparse input (one image) needs all of tier 1.

Every answer is written into the draft kit.json immediately. Unanswered optional fields stay `not defined`.

---

## Tier 1 - always (max 7)

**Q1 - Language and direction** (skip if the materials are clearly one language and the student already wrote in it)

באיזו שפה תהיה הערכה?
עברית (מימין לשמאל), אנגלית, או דו-לשונית?

Writes: `meta.language`, `meta.direction`.

**Q2 - Who and what**

מי אתם ומה אתם עושים, במשפט אחד?

Writes: `identity.who`, `identity.what`.

**Q3 - Audience**

למי הפלטים מיועדים? מי קורא, רואה, מקבל אותם?

Writes: `identity.audience`.

**Q4 - Personality and counter-example**

שלוש מילים שמתארות את האופי של המותג.
ואחר כך דוגמה אחת ל"ככה זה אף פעם לא נראה".

Writes: `identity.words[3]`, `identity.never_looks_like`.

**Q5 - Logo status** (skip if a logo file was supplied: confirm the path instead)

לוגו: יש קובץ, יש לוגו אבל צריך רק כללי מיקום, או אין עדיין?

Writes: `logo.status` = `file` | `rules-only` | `none`.

**Q6 - The motif loop** (always; this is where extracted or proposed motifs get approved)

Show the palette table first, then the motifs rendered (inline SVG or CSS shapes, each with its name). Then:

הנה מה שחילצתי מהתמונה: הצבעים והצורות החוזרות.
מה נשאר, מה יורד, מה לשנות?

Repeat until the student approves 5-8 motifs. Each round: apply the corrections, re-render, show again. Also confirm the palette corrections here. Writes: `color.*`, `motifs[]` with `status: approved`.

**Q7 - Outputs they actually make**

אילו פלטים אתם באמת מייצרים? אפשר לבחור כמה:
פוסט לרשתות · מייל · חוברת או הדפסה · תמונה · מצגת · קרוסלה · דף אינטרנט · מסמך PDF · אייקונים · וידאו · רקע לזום · דמות או מסקוטה

Writes: `meta.outputs[]`. Fixed base is always generated; each named output beyond the base turns on its add-on adapter.

---

## Refinement gate

זה מספיק כדי לבנות את הערכה.
רוצים לדייק עוד קצת, או שממשיכים לבנייה?

If "continue": go to the plan gate (SKILL.md Step D). If "refine": tier 2, each question optional, skip anything already known.

## Tier 2 - only after the gate

**Q8 - Quiet tier**

יש פלטים שצריכים גרסה פורמלית ושקטה, בלי קישוט? למשל הצעת מחיר או מכתב רשמי.

Writes: `meta.quiet_tier` (turns on `adapters/quiet-tier.md`).

**Q9 - Illustration vs photo**

הבסיס של התמונות שלכם: איור, צילום, או שניהם?

Writes: `illustration.used`, `photo.used`.

**Q10 - Mascot**

יש דמות או מסקוטה שחוזרת?

Writes: `mascot.exists` (turns on `adapters/mascot.md`; asks for the canon image path if yes).

**Q11 - Print sizes**

הדפסה: אילו גדלים? A4, A5, כרטיס ביקור, רול-אפ?

Writes: `print.sizes[]`.

**Q12 - Image generator**

באיזה מחולל תמונות אתם עובדים?
Nano Banana · GPT Image · Recraft · Midjourney · אחר · לא יודע

Writes: `meta.generator` (adjusts the aspect-ratio and sizing notes in `adapters/image.md`).

---

## Branching rules

- **Rich input**: image + logo + materials. Ask Q1 (only if unclear), Q4, Q6, Q7. State everything else as found.
- **Sparse input**: one image. Ask all of tier 1.
- **Materials answer a question**: do not ask; write "מצאתי בחומרים: ..." and continue.
- **Student answers several questions at once**: record all, skip the ones now answered.
- **Student is tired of questions**: "עוד X שאלות ואנחנו בונים" and finish tier 1 only.
- **No image supplied**: stop and ask for one. There is no image-less path.
