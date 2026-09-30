# How Raz writes: analysis of his own messages

Source: 568 messages Raz typed to Claude between March and September 2026 (about 16,000 Hebrew words after removing English-only messages and text he pasted from elsewhere). Extracted with `voice/scripts/extract_raz.py`. The raw file stays local (`voice/raz-sample/`, ignored by git). Numbers are in `voice/metrics.md`.

## Limits of this sample (read first)

- Almost everything here was written **to a tool, not to a person**: instructions, questions, feedback on drafts. It shows how Raz thinks, what he rejects and which words come naturally to him. It says little about how he tells a story or jokes with friends.
- One message is written to a person (to Lihi, his thesis advisor, 2026-09-24). It is short, but it is the best evidence of his register toward a human reader, and it matches the rest.
- The richest evidence for the site's voice is a small set: the places where Raz **drafted site copy himself** or **rejected a draft and said why** (2026-09-22 to 2026-09-27). Those count more than anything else below.
- Typing habits are not voice: a space before `?` and `:`, typos, missing periods and run-on lines come from fast typing. The profile keeps the spoken rhythm and drops the typing errors.

## What his own copy drafts look like

These are lines Raz wrote himself for the site (quoted as typed, lightly trimmed):

- "הגעתם בול בזמן, הג'יבריש הזה בקרוב יהיה ברמת שפת אם שלכם, מכאן מתחילים." (landing headline idea, 09-23; now live as the l_h1/l_sub pair)
- "שנבדוק שהכל יושב ?" / "בלי לחץ, זה לא מבחן, נדבר על הכל לעומק עוד המון, זה היה רק מבוא." (self-check intro, 09-23; live almost word for word)
- "פותחים חשבון לומדים לפי המפגשים ובקצב שלכם כמה שתרצו, מתרגלים עד שזה יושב" (how-it-works, 09-22)
- "פותחים חשבון, דקה אחת" (button, 09-23)
- "מבטיחים שפעם אחרונה אנחנו מזכירים שממש נשמח להכיר אותך" (third reminder, 09-27)
- "תודה בחרתם ולמדתם איתנו, נשמח לשמוע ממכם איך הייתה לכם חווית הלמידה כדי שנוכל להשתפר." (goodbye email, 09-27)
- onboarding options: "להרגיש בטוח בלכתוב שאילתות", "לשלוט בסינטקס", and a level scale from "לא מכיר בכלל את הנושא" to "שולט" (09-25)

What they share:
1. **Present-tense plural verbs with no subject** carry the action: פותחים, לומדים, מתרגלים, מתחילים. The reader is inside the action, not told about it.
2. **Idiom over description**: בול בזמן, שפת אם, עד שזה יושב, בלי לחץ. A familiar spoken phrase does the work of a sentence.
3. **A small, warm joke at his own expense or the site's**, never at the reader's: "הג'יבריש הזה", "מבטיחים שפעם אחרונה". The humor is reassurance.
4. **Short.** When he drafts copy, the lines are much shorter than his chat messages.
5. When he drafts fast he sometimes slips into form register ("אם תוכל לספק לנו בבקשה מהי סיבת העזיבה", "יש לאשר ... על מנת"). He did not defend those phrasings later; the sharper versions replaced them. The profile treats his intent (warm, short, plain) as the rule, not those slips.

## What he rejects, in his words

Every time Raz rejected copy, the reason was one of these:

| His words | What it means for the profile |
|---|---|
| "זה רובוטי ולא אנושי", "רובוטי מידי", "זה נשמע מאוד רובוטי" | The top failure. Machine-sounding text is worse than plain text. |
| "אף אחד לא מדבר ככה", "ממחישים חיים זה לא אנושי" | Test every line against speech. Invented compound phrases fail. |
| "תפסיק עם המלל העודף והמיותר", "פחות מלל", "יש יותר מידי מלל" | Cut. Then cut again. |
| "זה ברור שזה נשמר מכל מכשיר... הרי" | Never state what the reader already knows. |
| "זה לא מעניין תסיר את זה" | A true detail that the reader doesn't care about goes. |
| "מסוגנן גרוע - תן לזה ניסוח רגיל יותר" | Over-styled is a failure too. Plain beats clever when clever shows. |
| "מפורט מידי ומוזר תחבירית" | Over-precise legal/technical detail plus odd word order. |
| "כתוב את הדוח בעברית רגילה ולא אקדמית מסורבלת" | Academic heaviness is out, even in academic work. |
| "אל תשתמש במילים מתוחכמות" | No showing off vocabulary. |
| "הוא מפליל את המחברת שנעשתה באופן מלאכותי מידי" | AI-sounding text is a reputational risk, not only a style issue. |
| "זה משהו שאפשר להגיד במשפט" | If one sentence can carry it, one sentence it is. |
| "לומדים SQL כמו שכותבים אותו: חי, על טבלאות, עם תשובה מיד" → "יותר אנושי", "לא מושכת אותי מספיק" | Slogan-with-colon headlines feel manufactured. |

What he asks for instead: "אנושי", "ידידותי ומחבר", "בגובה העיניים", "חד קליל וברור לכולם", "קצרה וקולעת, ללא חזרות, וענייני", "ברור וקולע ושלא ישאיר מקום לשאלות", "נחיתה רכה".

## Habits in how he writes (chat register)

Each item has at least several examples in the sample; frequencies are in `metrics.md`.

**Structure**
- **Topic, dash, comment.** "לגבי X - ...", "שקף 4 - הוסתר - מדבר על...", "זה לא לזיהוי חד משמעי - זה לא הסיבה". The dash is his main joint between ideas (about 13 per 1,000 words; the current site copy has almost none). He uses colons rarely (3 per 1,000; the site uses 27).
- **Numbered answers.** He answers a list of questions with a matching numbered list, one short line each ("1. מאשר 2. לא הבנתי למה אתה מתכוון 3. ...").
- **Cleft openers**: "מה שניסיתי לומר זה...", "מה שכן אפשר לעשות זה...", "מה שאני צריך ממך זה...", "כל מה שאני זוכר זה...". He sets up the point, then delivers it.
- **A short verdict after a long line of thought.** After a run of reasoning he lands on a compact sentence: "האדם הוא צוואר בקבוק בסיפור.", "התפר הוא המוקד.", "זה קו מאוד יפה אבל לא שייך.", "מצאנו הוכחנו ותיקנו". This is the strongest "writerly" instinct in the sample and the natural bridge to the Walla craft.
- **Question stacks** when something is unclear: "למה אנחנו קוראים לזה שופט יקר ? מה זה אומר שופט יקר ? למה הוא יקר ?" (about 14 questions per 1,000 words).

**Word choice**
- Spoken connectors and softeners: אוקיי (by far the most common opener), בוא נ..., לגבי, אולי, בעצם, פשוט, באמת, קצת, טיפה, ממש, כביכול, דיי.
- Praise words: מעולה, יופי, מושלם, "כל הכבוד".
- Idioms and images, used naturally, never stacked: להאכיל בכפית, צוואר בקבוק, נחיתה רכה, באוויר ("כל ההסבר שלך שם באוויר לי מידי"), לירות בדיקות ללא הבחנה, בול, מבסוט, דופק אותי, וכל השטויות שמסביב, זה לא חוכמה.
- He thinks in "we": בוא נ..., אנחנו, נמשיך, נחשוב. Toward students he uses plural אתם (שלכם, תצאו, תרצו).

**Tone**
- **Direct, not harsh.** Criticism is plain and immediate ("לא אהבתי", "לא הבנתי כלום", "הכל כתוב גרוע") and usually comes with the reason and the fix in the same message.
- **Hedged when uncertain, flat when sure.** Uncertain: "אני חושב", "אני תוהה", "אני שוקל", "אני נוטה לחשוב", "אולי". Sure: "זה מיותר, באף גרסה הם לא צריכים לקבל את זה."
- **Honest about his own limits**: "אני לא דובר אנגלית בצורה מושלמת", "אני חלש בנושא", "אני כבר לא זוכר מה קורה כאן", "יכול להיות שעירבבתי קצת... אבל זה הנימוק שלי". This matters for a teaching site: the voice admits that things are hard.
- **Humor is rare in chat and always light**: situational, dry, never sarcastic toward the reader. The evidence for his humor comes mostly from the copy drafts above. **Low confidence** on anything more specific than "light, warm, self-aware".

## The one message to a person (to Lihi)

Short, and consistent with everything above: a greeting line, straight to the point, a cleft opener ("מה שניסיתי לומר זה ש..."), a technical point explained with an example in parentheses, two options laid out, and his own view marked as his ("זה הפתרון המהיר אבל לא מה שאנחנו באמת רוצים לדעתי"). No formality, no filler.

## What the sample cannot tell us

- How he writes long-form prose for strangers (a post, an essay). There is none in the sample.
- His humor range. There are only a handful of jokes.
- Whether he likes exclamation marks in copy. He uses them in chat praise ("מעולה !") and the site has "ברוכים הבאים, {n}!", but he never commented on them.
