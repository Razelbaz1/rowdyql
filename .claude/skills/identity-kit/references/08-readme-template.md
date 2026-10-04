# 08 - Student README template (kit language; Hebrew version below, English version after it)

Generate `README.md` at the kit root from the version matching `meta.language`. Bilingual kits get the Hebrew version with the English usage prompts appended.

---

## Hebrew version

```markdown
# ערכת הזהות של {{brand}}

זו הזהות הוויזואלית שלכם, בקבצים שכל מודל שפה מבין.
מצרפים קובץ אחד או שניים לכל בקשה, ומקבלים פלט בסגנון שלכם, בלי להסביר מחדש.

## מה יש בתיקייה

| קובץ | מה זה | מתי מצרפים |
|---|---|---|
| `core.md` | ה-DNA: צבעים, טיפוגרפיה, צורות, מוטיבים, איור, צילום, קומפוזיציה, לוגו, עשה ואל תעשה | תמיד |
| `kit.json` | אותו מידע, בפורמט מכונה | כשכלי צריך JSON |
| `design-tokens.css` | הטוקנים כ-CSS | לכל דבר שנבנה בקוד |
| `image-style-block.md` | בלוק סגנון לפרומפטים של תמונות | כשמייצרים תמונה |
| `showcase.html` | דף שמציג את הזהות. פותחים בדפדפן | להראות, לבדוק, לשתף |
| `motifs/` | קבצי SVG של המוטיבים | כשבונים בקוד |
| `assets/` | תמונות שאתם מייצרים לפי `assets/ASSETS.md` | לפי הצורך |
| `adapters/image.md` | תמונה בודדת | עם core.md |
| `adapters/social-post.md` | פוסט לרשתות | עם core.md |
| `adapters/email.md` | מייל ממותג | עם core.md |
| `adapters/booklet-print.md` | חוברת והדפסה | עם core.md |
{{rows for every add-on adapter generated}}
| `templates/` | תבניות HTML מוכנות עם הטוקנים שלכם | כשבונים מייל או חוברת |
| `source/` | קבצי המקור שלכם, לא נגענו | לא מצרפים |

## ארבעה פרומפטים לשימוש

**1. לייצר פלט בסגנון שלי**
צרפו `core.md` ואת האדפטר המתאים, והדביקו:
```text
קראו את core.md ואת adapters/<medium>.md. בנו <מה שרוצים> לפי פריסה <מספר או שם> מהאדפטר. כל צבע, פונט ומוטיב רק מהקבצים. בסוף הריצו את ה-done-check של האדפטר ואת השער בסעיף 11 של core.md, ורשמו את התוצאות.
```

**2. לכתוב פרומפט לתמונה**
צרפו `image-style-block.md` והדביקו:
```text
כתבו פרומפט מלא למחולל תמונות עבור: <נושא התמונה>. השתמשו בבלוק הסגנון מ-image-style-block.md מילה במילה, הוסיפו רק את הנושא, הקומפוזיציה ויחס התמונה <יחס>. בלי טקסט בתוך התמונה.
```

**3. להלביש את הזהות על קובץ קיים**
צרפו `core.md`, `design-tokens.css` ואת הקובץ, והדביקו:
```text
קראו את core.md ואת design-tokens.css. עצבו מחדש את הקובץ המצורף כך שיחיה בתוך הזהות הזו. התוכן נשאר, המראה משתנה. כל צבע הוא טוקן, כל פונט מהמחסנית, כל מרווח מהסקאלה. לפני שינוי הציגו מה יתחלף וחכו לאישור. בסוף רשימת לפני ואחרי.
```

**4. לבדוק אם פלט מתאים לזהות**
צרפו `core.md` ואת הפלט, והדביקו:
```text
קראו את סעיף 11 של core.md. עברו על הפלט המצורף ועל כל בדיקה ענו כן או לא עם הסבר של שורה. סכמו: עובר, עובר חלקית, נכשל. אם נכשל, רשמו את שלושת התיקונים הקטנים ביותר שיביאו אותו לעובר.
```

## להוסיף אדפטר חדש
פותחים שיחה עם הסקיל identity-kit, נותנים את הנתיב לתיקייה הזו, ואומרים "תוסיף אדפטר <שם>". הסקיל קורא את core.md ומוסיף רק את הקובץ החסר.

## תמונות שעוד לא נוצרו
ראו `assets/ASSETS.md`: לכל תמונה יש פרומפט מוכן ונתיב יעד. מייצרים, שומרים בנתיב, ומסמנים done.

נוצר {{date}} מתוך `source/{{reference}}`.
```

---

## English version

```markdown
# {{brand}} - Brand Identity Kit

Your visual identity as files any LLM can read. Attach one or two files to any request and get output in your style, no re-explaining.

## What is in the folder

| File | What it is | When to attach |
|---|---|---|
| `core.md` | the DNA: color, type, shapes, motifs, illustration, photo, composition, logo, do/don't | always |
| `kit.json` | the same data, machine view | when a tool wants JSON |
| `design-tokens.css` | tokens as CSS | anything built in code |
| `image-style-block.md` | style block for image prompts | when generating an image |
| `showcase.html` | a page that renders the identity, open in a browser | to show, check, share |
| `motifs/` | motif SVG files | when building in code |
| `assets/` | images you generate per `assets/ASSETS.md` | as needed |
| `adapters/image.md` | single image | with core.md |
| `adapters/social-post.md` | social post | with core.md |
| `adapters/email.md` | branded email | with core.md |
| `adapters/booklet-print.md` | booklet and print | with core.md |
{{rows for every add-on adapter generated}}
| `templates/` | ready HTML shells with your tokens | when building an email or booklet |
| `source/` | your original references, untouched | never attach |

## Four usage prompts

**1. Produce an output in my style** (attach `core.md` + the adapter)
```text
Read core.md and adapters/<medium>.md. Build <what you want> using layout <number or name> from the adapter. Every color, font and motif only from these files. Finish by running the adapter's done-check and the gate in core.md section 11, and list the results.
```

**2. Write an image prompt** (attach `image-style-block.md`)
```text
Write a complete image-generator prompt for: <subject>. Use the style block from image-style-block.md verbatim; add only the subject, the composition and the aspect ratio <ratio>. No text inside the image.
```

**3. Restyle an existing file** (attach `core.md`, `design-tokens.css`, the file)
```text
Read core.md and design-tokens.css. Restyle the attached file to live inside this identity. Content stays, look changes. Every color is a token, every font from the stack, every spacing on the scale. Before changing anything, show what will change and wait for approval. End with a before/after list.
```

**4. Check an output against the identity** (attach `core.md` + the output)
```text
Read core.md section 11. Review the attached output and answer each check yes or no with a one-line reason. Summarize: pass, partial, fail. If fail, list the three smallest fixes that get it to pass.
```

## Add an adapter later
Open a chat with the identity-kit skill, give it this folder's path, and say "add adapter <name>". It reads core.md and adds only the missing file.

## Images not yet generated
See `assets/ASSETS.md`: each image has a ready prompt and a target path. Generate, save at the path, mark done.

Generated {{date}} from `source/{{reference}}`.
```
