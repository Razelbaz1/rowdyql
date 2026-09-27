| key | where | context | en |
|---|---|---|---|
| g_consent | sign-in / sign-up gate | Checkbox label. Keep the <a> tag and its attributes exactly. Avoid gender slash forms. | I have read and agree to the <a href=\"#\" id=\"termsLink\">terms of use</a>. |
| g_foot | sign-in / sign-up gate | Small footnote on the sign-up card, a wink to database students: signing up is one INSERT, signing in is a SELECT, the password is stored as a hash. Keep the <code> tags. | Your sign-up is really one <code>INSERT</code>. Signing in is a <code>SELECT</code>. The password is stored as a hash, never as text. |
| g_working | sign-in / sign-up gate | Shown on the submit button while the request runs. The card shows a live SQL panel executing the query. | Executing… |
| g_ok_up | sign-in / sign-up gate | Message after sign-up: we sent a confirmation link to the email; click it, then sign in. | Registered. We sent a confirmation link to your email; click it, then sign in. |
| g_err_in | sign-in / sign-up gate | Sign-in failed: wrong email or password. | Wrong email or password. |
| g_err_gen | sign-in / sign-up gate | Generic error, something failed on our side. | Something went wrong. Try again in a moment. |
| g_err_exists | sign-in / sign-up gate | Shown next to the email field when it is already registered. | This email is already registered. |
| su_h | sign-up done | Popup title right after sign-up. {n} is the first name. | Welcome, {n}! |
| su_body | sign-up done | Popup body right after sign-up: a confirmation link was sent to {e}; click it, then sign in. | You are signed up. We sent a verification link to {e}; click it, then sign in. |
| su_tip | sign-up done | Small line in the same popup, for when the email did not arrive: check spam. | Can't see it? Check the spam folder. |
| g_checking | sign-in / sign-up gate | Shown next to the email field while checking whether it is already registered. | Checking… |
| g_free | sign-in / sign-up gate | Shown next to the email field when it is not registered yet (green). | This email is available. |
| g_err_captcha | sign-in / sign-up gate | The CAPTCHA check was not completed. | Complete the CAPTCHA check and try again. |
| l_h1 | landing page (before sign-up) | Main headline of the landing page, the first thing a stranger sees. Database jargon (σ, JOIN, PRIMARY KEY) floats around it. Must hook, not describe. Short. | Don't understand a word yet? Perfect timing. |
| l_sub | landing page (before sign-up) | Paragraph under the headline. Keep every promise in it: starts from zero, no prior knowledge, step by step up to multi-table queries, subqueries, window functions and proper database design; a visualizer, an instantly checked exercise and exam-style questions per topic. | Welcome to RowdyQL. The jargon above will soon be your mother tongue: you start from zero, with no prior knowledge assumed, and move step by step up to queries that combine several tables, subqueries and window functions, and to designing a database properly. Every topic comes with a visualizer you can touch, an exercise checked on the spot, and questions at exam level and at job-interview level. |
| l_cta | landing page (before sign-up) | Primary button under the headline. Starts sign-up. | Start here |
| l_cta2 | landing page (before sign-up) | Button at the end of the scroll story. Starts sign-up; says it takes about a minute. | Create an account, one minute |
| l_have | landing page (before sign-up) | Secondary button next to the primary one. Goes to sign-in. First person is fine here. | I already have an account |
| l_feat_h | landing page (before sign-up) | Section heading above 4 feature cards. | What is inside |
| l_how_h | landing page (before sign-up) | Section heading above 3 numbered steps. | How it works |
| ch_details | sign-up wizard, chapter names | One-word label in the sign-up progress bar (chapter 1: name, birth date, email, password). | Details |
| ch_terms | sign-up wizard, chapter names | One-word label in the sign-up progress bar (chapter 2: privacy terms). | Terms |
| ch_done | sign-up wizard, chapter names | One-word label in the sign-up progress bar (last chapter). | Done |
| dt_h | sign-up wizard | Heading of the name and birth date steps. Warm. | Let us meet |
| d_email_why | sign-up wizard, email step | Helper line under the email field: the email is the login identifier and the confirmation link is sent there. | Your email is your identifier. The confirmation link goes there. |
| d_pass_why | sign-up wizard, password step | Helper line under the password field: minimum 8 characters; stored as a hash, so nobody can read it, not even the site owners. | At least 8 characters. Stored as a hash: nobody can read it, not even us. |
| d_first_why | sign-up wizard, first name step | Helper line under the first name field: this is how we will address you; letters only, Hebrew or English. | What we should call you. Letters only, Hebrew or English. |
| d_last_why | sign-up wizard, last name step | Helper line under the last name field; this step comes right after first name. | And now the last name. |
| d_birth_why | sign-up wizard, birth date step | Helper line under the birth date field. Reassures that nobody sees it. | Never shown to anyone. |
| in_why | sign-in | Subtitle on the sign-in card for a returning student. | Welcome back. Email and password, and continue where you stopped. |
| in_to_up | sign-in | Line at the bottom of the sign-in card. The last word is a link to sign-up. | No account yet? Sign up |
| up_to_in | sign-up wizard | Line at the bottom of the sign-up card. The last word is a link to sign-in. | Already have an account? Sign in |
| tm_h | sign-up wizard, terms | Heading of the terms step. | Before we continue |
| tm_why | sign-up wizard, terms | Error shown when the student tries to continue without ticking the terms checkbox. | Please accept the terms of use to continue to the next step. |
| t_s1 | sign-up wizard, terms | Privacy summary, line 1 of 4: what is stored. Keep the facts exact. | Stored: email, first and last name, date of birth, and your onboarding answers if you choose to answer. |
| t_s2 | sign-up wizard, terms | Privacy summary, line 2 of 4: what is NOT stored. Keep the facts exact. | Not stored: national ID, phone, or anything you did not type here. |
| t_s3 | sign-up wizard, terms | Privacy summary, line 3 of 4: only the course staff sees it, and only for the course. | Seen only by course staff, only for the course. |
| t_s4 | sign-up wizard, terms | Privacy summary, line 4 of 4: deletion on request at any time, progress included. | You can ask for deletion at any time, and everything goes, progress included. |
| g_blocked | sign-in / sign-up gate | Shown at sign-in when staff suspended the account. Point them to the site team. | This account is suspended. Please contact the site team. |
| ch_n | sign-up wizard, chapter names | Tiny label above the chapter name. {n} is a number. | Chapter {n} |
| g_forgot | sign-in / sign-up gate | Link under the password field on sign-in. First person is fine here. | Forgot password |
| dt_h_acc | sign-up wizard | Heading of the email and password steps. | Create your account |
| l_feat.0.1 | landing page (before sign-up) | Feature card title: animated visualizers of each operator on real tables. | Live visualizers |
| l_feat.0.2 | landing page (before sign-up) | Feature card body under the title above. | Every operator and clause animated on real tables. You see what happens to the rows instead of reading about it. |
| l_feat.1.1 | landing page (before sign-up) | Feature card title: exercises are checked on the spot. | Exercises checked instantly |
| l_feat.1.2 | landing page (before sign-up) | Feature card body: the checker compares the result table, not the text, so any correct query is accepted. | The checker compares results, not text. There is more than one right answer, and all of them count. |
| l_feat.2.1 | landing page (before sign-up) | Feature card title: questions in the style of the exam. | Exam-style questions |
| l_feat.2.2 | landing page (before sign-up) | Feature card body: six options per question, real traps, explanation right after answering. | Six options, real traps, and an explanation right after you choose. |
| l_feat.3.1 | landing page (before sign-up) | Feature card title: progress is saved. Must NOT promise multiple devices. | Progress that is saved |
| l_feat.3.2 | landing page (before sign-up) | Feature card body: you continue from where you stopped. | Where you stopped is where you continue. |
| l_how.0.0 | landing page (before sign-up) | Step 1 title (bold). The next key is a short line under it that completes it. | Create an account |
| l_how.0.1 | landing page (before sign-up) | Line under step 1. Reads as the continuation of the title. | and you're in within a minute. |
| l_how.1.0 | landing page (before sign-up) | Step 2 title (bold). | Learn lesson by lesson |
| l_how.1.1 | landing page (before sign-up) | Line under step 2. Reads as the continuation of the title. | at your own pace, as much as you like. |
| l_how.2.0 | landing page (before sign-up) | Step 3 title (bold). | Practice until it sticks |
| l_how.2.1 | landing page (before sign-up) | Line under step 3. | Solve exercises and tests. |
