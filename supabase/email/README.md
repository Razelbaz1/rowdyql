# המיילים של RowdyQL

חמשת המיילים בנויים על תבנית המייל של הערכה (`raz-elbaz-brand-identity-kit/templates/email-shell.html`). לא עורכים אותם ביד: משנים את `tools/build_emails.py` ומריצים `python tools/build_emails.py`. שלושה מודבקים ב-Supabase (הטבלה למטה), ושניים יושבים בתוך פונקציות SQL (מייל הפרידה ומייל ההודעות, בהמשך). תצוגה מקדימה: לפתוח את `preview.html` בדפדפן (לבנות מחדש: `node tools/emailpreview.js`).

| תבנית ב-Supabase | קובץ | נושא (Subject) |
|---|---|---|
| Confirm signup | `confirm_signup.html` | לפי המגדר (למטה) |
| Reset password | `reset_password.html` | איפוס הסיסמה ל-RowdyQL |
| Reauthentication | `reauthentication.html` | הקוד לשינוי הסיסמה ב-RowdyQL |

## הדבקה
Supabase → Authentication → Emails → Templates. בוחרים תבנית, מדביקים את הנושא, ואת כל תוכן הקובץ בגוף ההודעה (Message body), ושומרים.
הלוגו נטען מ-`https://rowdyql.com/email-logo-light.png` (הקובץ בשורש הריפו, נוצר ב-`node tools/emaillogolight.js`). הלוגו הכהה הישן, `email-logo.png`, נשאר בשרת בשביל מיילים שכבר נשלחו. הברכה בשם הפרטי מגיעה מ-`first_name` שנשמר בהרשמה.

## מייל האישור לפי מגדר
מייל האישור פונה ביחיד לפי המגדר שנבחר בהרשמה (`gender`, M או F), ובלי מגדר ברבים (פרופיל הקול 1.2). משתנים הכותרת (תמונה: `confirm_signup_m.png`, `confirm_signup_f.png` או `confirm_signup.png`), שורת התצוגה המקדימה ו"שבחרת/שבחרתם". הנושא, שמודבק כמו שהוא:
```
{{ with .Data.gender }}{{ if eq . "F" }}ברוכה הבאה ל-RowdyQL: אישור האימייל{{ else }}ברוך הבא ל-RowdyQL: אישור האימייל{{ end }}{{ else }}ברוכים הבאים ל-RowdyQL: אישור האימייל{{ end }}
```

## שם השולח: RowdyQL
שירות המייל המובנה של Supabase לא מאפשר לשנות את השולח, אז צריך SMTP משלנו. ההמלצה: Resend (יש תוכנית חינמית).
1. נרשמים ב-resend.com, ואז Domains → Add domain → `rowdyql.com`.
2. ב-Cloudflare → DNS מוסיפים את הרשומות ש-Resend מציג, בדיוק כמו שהן. רשומת CNAME, אם יש, מסמנים DNS only (ענן אפור). הרשומות האלה לא משפיעות על האתר. מחכים ל-Verified.
3. ב-Resend → API Keys → Create (Sending access).
4. ב-Supabase → Authentication → Emails → SMTP Settings → Enable custom SMTP:
   - Sender email: `noreply@rowdyql.com`
   - Sender name: `RowdyQL`
   - Host: `smtp.resend.com` · Port: `465` · Username: `resend` · Password: ה-API key
5. ב-Authentication → Rate Limits בודקים את מגבלת המיילים לשעה ומתאימים למספר הנרשמים.
6. בודקים: הרשמה עם אימייל חדש, ו"שכחתי סיסמה" בחלון הכניסה.

## מייל הפרידה ותשובות אליו
מייל הפרידה נשלח מהפונקציה `delete_my_account` (Resend דרך `pg_net`, המפתח ב-Vault בשם `resend_api_key`). התבנית: `goodbye.html`; ה-SQL נבנה ממנה ב-`python tools/gen_goodbye_sql.py`.
תשובות למייל הולכות ל-`hello@rowdyql.com` (המשתנה `v_reply` בפונקציה). כדי שהכתובת תקלוט דואר: Cloudflare → `rowdyql.com` → Email → Email Routing → הפעלה (מוסיף רשומות MX שלא נוגעות באתר) → Routing rules → כתובת `hello` → Send to: תיבת הג'ימייל שלך (מאשרים את המייל שמגיע אליה).

## מייל ההודעות (הפעמון)
לא מדביקים אותו ב-Supabase. הוא נמצא בתוך `send_notice()` בקובץ `supabase/migration_2026-09-27_notices.sql`, כמו מייל הפרידה. אחרי שינוי ב-`notice.html` מריצים `python tools/gen_notice_sql.py`, ואז מריצים את ה-SQL שוב.
