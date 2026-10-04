# RowdyQL voice profile: English

**Status: approved by Raz, 2026-09-30. Version 1.** This is the official English voice of the site. The Hebrew profile is `raz-elbaz-brand-identity-kit/voice/voice-profile.md`. Mechanical checks: `raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py`.

## Where this comes from (read first)

There is no sample of Raz writing English for an audience, so this version is **derived** from the Hebrew profile. The persona, the moves and the bans carry over. The English-specific rules below were written for how natural spoken English works, and checked against the site's current English strings. Treat it as a strong first version. Every correction Raz makes to English copy goes into `copy/examples.md` and outranks this file.

One thing Raz said directly applies here: good copy in one language is never a one-to-one translation of the other. Each language is written from the intent, not from the other language's sentence.

## The voice in one paragraph

The same TA as in Hebrew, speaking English: a step ahead of you, and still remembers what it was like not to understand a word. Plain spoken English, second person, present tense, contractions. It starts from something concrete, builds for a sentence or two, then lands on a short line. The jokes are small and always on the site, never on the student. It admits when something is hard and never sounds like a form, a paper, or a startup landing page.

## Do

1. **Write it the way you'd say it to a student after class.** Contractions are the default: you're, don't, it's, that's, let's. [from HE Do 1]
   "Don't understand a word yet? Perfect timing."
2. **Talk to "you", in the present tense.** Avoid "users", "the student", or the future "you will learn". [from HE Do 2]
3. **Open on something concrete**: a number, a thing, the question the student actually has. Don't open on a definition or an announcement. [HE Do 3]
4. **Build, then land.** After a longer sentence, a short verdict of two to five words. [HE Do 4]
   "Same number of columns, different type."
5. **Answer the student's question before they ask it.** "Why? Because...", "And the loops? There aren't any." At most one per paragraph. [HE Do 5]
6. **Turn with "but" or a spaced hyphen ( - ), not a colon.** Never an em dash. [HE Do 6]
7. **One plain English idiom per unit, at most.** Don't translate Hebrew idioms word for word. Find the English one or go plain: "הגעתם בול בזמן" is "Perfect timing", and "עד שזה יושב" is "until it sticks". [HE Do 7]
8. **The site takes the joke, never the student.** "The jargon above will soon be your mother tongue." [HE Do 8]
9. **Meet jargon out loud.** Give the idea in plain words, then the term, and never drop a real term to make a line simpler ("relational" stays). [HE Do 9]
10. **End on something that lands**: the short verdict, or a callback to the headline or a recurring phrase ("Start here", "until it sticks"). [HE Do 10]
11. **Admit it when something is really hard.** "This is where everyone gets stuck" beats "It's easy". [HE Do 12]
12. **Cut every sentence the student wouldn't miss.** [HE Do 13]

English-only rules:

13. **Buttons are short verb phrases**, which is what English readers expect: "Start here", "Check", "Send link", "Delete for good". Three words at most. (Hebrew buttons use action nouns; the languages differ here on purpose.)
14. **Sentence case** for headings and buttons: "What's inside", not "What's Inside".
15. **Gentle slang only**, the English equivalent of the Hebrew rule: "you're in", "off you go", "that's it". Not "awesome", "super", "gonna", "hey there".

## Don't

1. **Form and office English**: kindly, successfully ("saved successfully"), utilize, in order to, prior to, hereby, aforementioned, "please note". Use "please" only for a real request, never in front of every instruction.
2. **Startup and AI-marketing words**: unlock, empower, seamless, leverage, journey, delve, "dive in", "level up", "supercharge". Raz rejects copy that "looks very AI". These are the English giveaways.
3. **Colons as slogan structure**: "Learn SQL the way it's written: live, on tables, instantly." Keep colons for UI labels, before code, and before a list the reader asked for.
4. **Stating what the student already knows**: "Your progress is saved to your account" right after they signed in.
5. **Condescending ease words**: simply, just (as in "just write a query"), obviously, easily.
6. **Summary endings**: in summary, to sum up, in conclusion, as we've seen.
7. **Sarcasm or snark** at the student or anyone else.
8. **Exclamation marks as decoration.** Keep them for a greeting or a real win ("Correct!").
9. **Emoji and text emoticons.**
10. **Stiff uncontracted English** in UI strings: "If you do not know yet", "That is it", "You have not filled in". The current English strings are full of these. They read as translated.

## Before and after (proposals, not applied)

The same four strings as in the Hebrew profile. The English versions are written from the intent, not translated from the new Hebrew.

### 1. Intro lesson, under the headline (`hero_lede`)

**Before**
> Your bank, the supermarket checkout, Waze, Moodle, course registration. Behind each one sits a relational database, and all of them speak one language: SQL. In this course you learn to think about data like the person who designs those tables, not only the one who fills them in.

**After**
> Your bank, the supermarket checkout, Waze, Moodle, course registration. Behind each one sits a relational database, and they all speak the same language - SQL. Until now, you've been the one filling in the tables. This is where you start designing them.

- The colon is gone [Do 6, Don't 3].
- The last two sentences build and turn [Do 4], and "relational" stays [Do 9].

### 2. The popup right after sign-up (`su_body`)

**Before**
> You are signed up. We sent a verification link to {e}; click it, then sign in.

**After**
> One step left. We sent a verification link to {e}. Click it, sign in, and start learning.

- The popup now welcomes the student and points to the next step, instead of reading like a receipt.
- The triad ends on the promise [HE Do 11]. There are contractions where they fit.

### 3. First sign-in questionnaire, the hint under an empty answer (`ob_goals_req`)

**Before**
> If you do not know yet, write "not sure". Any answer is fine.

**After**
> Not sure yet? Write 'not sure'. Any answer counts.

- It opens on the student's own question [Do 5], with no stiff "do not" [Don't 10].
- The quotes are single quotes, per the copy rules' string format.

### 4. Set operations lesson, the "incompatible" message (`st_msg_x`)

**Before**
> **Incompatible**: A is one column of numbers, and we tried to union it with station names. Same number of columns, different type. In exams this is the classic slip when uniting two branches that were not projected onto the same columns.

**After**
> **Incompatible**: A is a column of numbers, and we tried to union it with station names. Same number of columns, different type. It's a classic exam trap - you union two results and forget to check that π kept the same columns in both.

- "Branches that were not projected onto" is textbook-speak. The new version says what the student actually does wrong.
- The verdict line stays [Do 4], and the hyphen carries the turn [Do 6].

## Quick test before a line ships

1. Would you say it out loud to a student? With contractions?
2. Is there a sentence the student wouldn't miss? Cut it.
3. Does it start from something concrete, not a definition?
4. Is a colon doing a slogan's job, or is there an em dash? Use a hyphen, a period or "but".
5. If there's a joke, who is it on? It must be the site.
6. Does the last line land, or does it summarize?
