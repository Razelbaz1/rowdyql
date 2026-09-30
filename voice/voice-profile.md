# RowdyQL voice profile

**Status: approved by Raz, 2026-09-30. Version 1. This is the official voice of the site.** English version: `voice/voice-profile-en.md`.

How RowdyQL should sound in Hebrew: Raz's own voice, sharpened by the craft of good Walla columnists. It covers site copy, lesson text, emails, notices and posts. It sits next to the copy rules in `.agents/rules/hebrew-copy.md`, which handle the mechanics (plural address, button nouns, terms, placeholders). This file handles how the copy sounds. Raz's before/after pairs in `copy/examples.md` still outrank both.

Evidence tags: **[R]** Raz's own drafts or rejections, **[W]** the Walla corpus, **[R+W]** both. Details: [analysis-raz.md](analysis-raz.md), [analysis-walla.md](analysis-walla.md), [metrics.md](metrics.md).

## How it is enforced

- Every writer reads this file first: Claude Code via `CLAUDE.md` and the `rowdyql-voice` skill, and Antigravity via its always-on copy rules.
- `python build.py` runs `voice/scripts/voice_check.py` and refuses to build when a new or edited string breaks a mechanical rule from the Don't list. Strings that were already on the site when the profile was approved are listed in `voice/voice-baseline.json`. They don't block until someone edits them.
- What a script can't judge (does it sound like Raz, does it land) goes through the review step: `voice_check.py --changed` lists every string that changed, and each one gets the quick test at the bottom of this file before Raz approves it.
- Raz's corrections go into `copy/examples.md`. When a correction reveals a new rule, this file gets a new version, and the checker gets a new check if the rule is mechanical.

## The voice in one paragraph

A TA who is a step ahead of you and remembers what it was like not to understand a word. The Hebrew is spoken, not written: present tense, plural, short. It starts from something concrete, builds for a sentence or two, then lands on a short line. The jokes are small, and the site is always the one taking them ("הג'יבריש הזה", "מבטיחים שפעם אחרונה"). It admits when something is hard, never explains what the student already knows, and never sounds like a form, a paper or a machine.

## Do

1. **Write it the way you'd say it to a student in the corridor.** Spoken Hebrew, then cut. [R]
   "בלי לחץ, זה לא מבחן." / "מתרגלים עד שזה יושב."
2. **Let subjectless present-plural verbs carry the action**: פותחים, לומדים, מתרגלים, ממשיכים, מתחילים. The student is inside the action, not told about it. [R]
   "פותחים חשבון, דקה אחת." / "עצרתם ב-X. ממשיכים משם?"
3. **Open on something concrete**: a number, an object, the question the student actually has. Don't open on a definition or an announcement. [R+W]
   "עוד לא מבינים מילה? הגעתם בול בזמן." (not "ברוכים הבאים לקורס המקיף...")
4. **Build, then land.** After a longer sentence, a short verdict of two to five words. This is the strongest instinct in both sources. [R+W]
   Raz: "האדם הוא צוואר בקבוק בסיפור." / Walla technique: "הוא הבוס." / site: "אותו מספר עמודות, טיפוס אחר."
5. **Answer the student's question before they ask it.** "למה? כי...", "ומה עם X? ...". At most one per paragraph. [W, and Raz asks questions this way himself]
6. **Turn with "אבל" or a dash, not a colon.** The dash ( - ) is Raz's natural joint between a setup and its point (13 per 1,000 words in his writing, 0 on the site today). "אבל" is the columnists' hinge. [R+W]
   "כולם מדברים באותה שפה - SQL."
7. **Use one familiar, spoken idiom per unit, not more**: בול, עד שזה יושב, בלי לחץ, בגובה העיניים, נחיתה רכה. Bending one slightly is fine. [R+W]
   **Gentle slang is allowed** (Raz, 2026-09-30), one per unit. The test: would a TA say it in front of the class without anyone noticing it's slang? Fine: בול, יושב, כיף, סבבה, על הדרך. Too far: יאללה, אחי, וואלה, חבל"ז, פצצה.
8. **The site takes the joke, never the student.** Humor here is reassurance: the site pokes fun at itself, at the jargon or at the situation. [R+W]
   "הג'יבריש שלמעלה יהיה בקרוב שפת האם שלכם." / "פעם אחרונה, מבטיחים." (both live)
9. **Meet jargon out loud.** Give the idea in plain words first, then its name. It's fine to admit a term sounds odd. **Never drop a real term to make a line simpler.** Keep it and make it clear (Raz, 2026-09-30: "המילה רלציוני חשובה"). [W; fits Raz's "ג'יבריש"]
   "ב-SQL אומרים מה רוצים לקבל, לא איך. בגלל זה קוראים לה שפה הצהרתית."
10. **End on something that lands**: the short verdict, or a callback to the headline, the first line or one of the site's recurring phrases (מכאן מתחילים, עד שזה יושב). [W]
11. **Use a triad now and then, with the weight in the third slot.** [R+W]
    Raz: "מצאנו הוכחנו ותיקנו." / "לוחצים עליו, נכנסים ומתחילים."
12. **Admit it when something is really hard.** "זה החלק שכולם נתקעים בו" does more than "זה פשוט". [R, medium evidence]
13. **Cut every sentence the student wouldn't miss.** This is Raz's most repeated note. [R]

## Don't

1. **Form or office register.** Everything already banned in the copy rules (נקלט/ה, יש ל..., אנא, הנך, ניתן, במידה ו, על מנת, בוצע בהצלחה), plus the academic register Raz rejected ("עברית רגילה ולא אקדמית מסורבלת"): מהווה, הינו, אשר, לפיכך, כמו כן, נוסף לכך, בהתאם לזאת, הרצוי/ה, אינו/אינה.
2. **Colons as slogan structure**: "לומדים SQL כמו שכותבים אותו: חי, על טבלאות, עם תשובה מיד." (Raz rejected this one) and "X: Y." explanations. The site uses 27 colons per 1,000 words, against 4 in the columns and 3 in Raz's writing. Keep colons for UI labels, before code, and before a quote.
3. **Stating what the student already knows.** "ההתקדמות נשמרת מכל מכשיר" (Raz: "זה ברור... הרי").
4. **Phrases nobody says**: "ממחישים חיים" (Raz: "אף אחד לא מדבר ככה"). Say it out loud. If you wouldn't say it, rewrite it.
5. **True but boring details**: "יחד עם ההתקדמות וכל מה שנשמר בו" (Raz: "זה לא מעניין תסיר את זה").
6. **Over-styling.** More than one joke, image or idiom in a unit. "הדלת פתוחה:" was, in Raz's words, "מסוגנן גרוע".
7. **Summary endings**: לסיכום, בשורה התחתונה, כפי שראינו, אם כך.
8. **Sarcasm or snark** at the student or anyone else. The columnists do it to celebrities. RowdyQL has no one to mock.
9. **Exclamation marks as decoration.** Keep them for a greeting or a real win ("נכון!"). Both sources use them rarely.
10. **Raz's chat habits.** אוקיי, בעצם, לגבי, "מה שאני רוצה זה..." and long comma-joined lines are how Raz talks to a tool. They are his most frequent words and they don't belong in copy. The profile is his voice sharpened, not transcribed.

## Where the sources disagreed (Raz's voice won)

| Walla does | Raz wants | Profile rule |
|---|---|---|
| Paragraphs around 60 words | "פחות מלל", "קצרה וקולעת" | UI strings: one or two sentences. Lesson paragraphs: up to about three. |
| Snark at its subjects | Warm, "ידידותי ומחבר" | Humor only as reassurance, at the site's own expense (Do 8) |
| Some writers are formal-literary | "לא אקדמית מסורבלת", "אל תשתמש במילים מתוחכמות" | Spoken register only (Don't 1) |
| Stacked wordplay and pop references | "מסוגנן גרוע" | One device per unit (Do 7, Don't 6) |
| Long comma chains | One idea per sentence (copy rules) | Short sentences. Rhythm comes from mixing lengths, not from commas. |

## Decisions (Raz, 2026-09-30)

- **Buttons.** Utility buttons use an action noun (הרשמה, בדיקה, המשך), as the copy rules say. The one or two landing-page buttons that invite sign-up may be a short present-plural phrase ("מכאן מתחילים", "פותחים חשבון, דקה אחת").
- **Slang.** Gentle slang is allowed, one per unit (Do 7).
- **Real terms stay.** "רלציוני" and every other real term is kept and made clear, never dropped (Do 9).
- **English.** The English site has its own profile, `voice/voice-profile-en.md`, derived from this one.
- **Still open:** exclamation marks in greetings ("ברוכים הבאים, {n}!"). Keep the site's current choice until Raz decides.

## Before and after

Four real strings from the site, rewritten with this profile. The numbers in brackets point to the Do and Don't lists above. **Approved by Raz and applied to the site on 2026-09-30.**

### 1. Intro lesson, the paragraph under the headline (`hero_lede`)

Headline above it: "כל מערכת שהשתמשתם בה היום יושבת על טבלאות."

**Before**
> הבנק, הקופה במכולת, ווייז, מודל, הרישום לקורסים. מאחורי כל אחת מהן יש בסיס נתונים רלציוני, ובכולם מדברים בשפה אחת: SQL. בקורס נלמד לחשוב על נתונים כמו מי שמתכנן את הטבלאות האלה, לא רק מי שממלא אותן.

**After**
> הבנק, הקופה בסופר, ווייז, מודל, הרישום לקורסים. מאחורי כל אחד מהם עומד בסיס נתונים רלציוני, וכולם מדברים באותה שפה - SQL. עד היום הייתם בצד שממלא את הטבלאות. מכאן עוברים לצד שמתכנן אותן.

- The colon became a dash [Do 6, Don't 2].
- The future "נלמד" became the present "עוברים" [Do 2].
- The last two sentences build and turn, and "מכאן" echoes the landing button "מכאן מתחילים" [Do 4, 10].
- Fixed the mismatch "כל אחת מהן... ובכולם".
- "במכולת" became "בסופר", to match the tag under the paragraph.
- "רלציוני" stays [Do 9].

### 2. The popup right after sign-up (`su_body`)

**Before**
> ההרשמה נקלטה. שלחנו קישור אימות ל-{e}, לחצו עליו ואז היכנסו.

**After**
> נשאר רק צעד אחד. שלחנו קישור אימות ל-{e} - לוחצים עליו, נכנסים ומתחילים.

- "נקלטה" is a receipt word [Don't 1]. On 2026-09-25 you asked for this message to welcome people, not confirm a transaction.
- The triad ends on "ומתחילים" [Do 11]. It echoes the confirmation email ("נשאר רק לאשר את האימייל, ומתחילים"), so both touchpoints say the same thing [Do 10].
- **Kept as is:** the title "ברוכים הבאים, {n}!" and the tip under it, "לא רואים את המייל? כדאי להציץ בספאם." The tip already sounds like the voice: a question and a casual verb.

### 3. Set operations lesson, the "incompatible" message (`st_msg_x`)

**Before**
> **לא תואם**: A היא עמודה אחת של מספרים, וניסינו לאחד אותה עם שמות תחנות. אותו מספר עמודות, אבל טיפוס שונה. במבחן זו טעות שנופלים בה כשמאחדים תוצאות של שני ענפים שלא הוטלו על אותן עמודות.

**After**
> **לא תואם**: A היא עמודה של מספרים, וניסינו לאחד אותה עם שמות של תחנות. אותו מספר עמודות, טיפוס אחר. במבחן זו מלכודת קלאסית - מאחדים שתי תוצאות ולא בודקים שה-π בשתיהן השאיר את אותן עמודות.

- "שלא הוטלו על אותן עמודות" is the exact calque the copy rules cite as a bad example, and it's still live. It's gone.
- "ענפים" (from the English "branches") became plain "שתי תוצאות".
- "אותו מספר עמודות, טיפוס אחר." is the short verdict [Do 4].
- The dash carries the turn to the exam trap [Do 6]. "מלכודת" matches the word the site already uses for exam traps.
- The colon after the bold label stays. That's a UI label, not prose.

### 4. Intro lesson, what "declarative" means (`de_p1`, `de_p2`)

**Before**
> SQL היא שפה **הצהרתית**: מתארים את התוצאה הרצויה, ומנוע בסיס הנתונים בוחר בעצמו באיזה סדר לגשת לטבלאות, איפה לסנן ואיך לצרף. אתם לא כותבים לולאות.
>
> המתמטיקה שמאחורי הבחירות האלה היא **אלגברה רלציונית**: שפה של פעולות על טבלאות (בחירה, הטלה, צירוף). היא הנושא של הפרק הבא, ובלעדיה SQL נשאר אוסף של דפוסים לשינון.

**After**
> ב-SQL אומרים מה רוצים לקבל, לא איך להגיע לזה. בגלל זה קוראים לה שפה **הצהרתית**. באיזה סדר לעבור על הטבלאות, איפה לסנן ואיך לצרף - את כל זה מנוע בסיס הנתונים מחליט לבד. לולאות לא כותבים כאן בכלל.
>
> ואיך המנוע יודע לבחור? מאחורי זה עומדת **אלגברה רלציונית**, שפה של פעולות על טבלאות (בחירה, הטלה, צירוף). היא הפרק הבא. בלעדיה, SQL נשאר אוסף של דפוסים לשינון.

- The first line used to be a definition. Now it's the idea in plain words, and the term comes after it [Do 3, 9].
- Two colons became a dash and periods [Do 6, Don't 2].
- "הרצויה" is gone [Don't 1].
- The second paragraph now opens with the question a student would ask, which also links the two paragraphs [Do 5].
- The best sentence in the original ("בלעדיה, SQL נשאר אוסף של דפוסים לשינון") now stands alone at the end [Do 10].
- The campus edition says "שני המפגשים הבאים" instead of "הפרק הבא". The same change applies: "עליה נדבר בשני המפגשים הבאים."

## Quick test before a line ships

1. Would Raz say it out loud to a student? If not, rewrite it.
2. Is there a sentence the student wouldn't miss? Cut it.
3. Does it start from something concrete, not a definition?
4. Is a colon doing a slogan's job? Use a dash, a period or "אבל" instead.
5. If there's a joke, who is it on? It must be the site, never the student.
6. Does the last line land, or does it summarize?
