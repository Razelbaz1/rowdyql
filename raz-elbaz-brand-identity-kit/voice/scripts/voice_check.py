"""Voice check: the mechanical half of the official voice (voice-profile.md, voice-profile-en.md).

Usage (from anywhere in the repo):
  python raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py              new violations only; exit 1 if any error
  python raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py --all        every violation, baseline included (audit)
  python raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py --changed    strings added or changed since git HEAD, for the review step
  python raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py --prune      drop baseline entries that are fixed
  python raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py --init-baseline   first run only: record today's violations
  python raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py --hook       Claude Code PostToolUse hook (hook JSON on stdin)

build.py calls gate() and stops on new errors unless run with --allow-voice.

Scanned: the he/en strings of I18N and I18N_CAMPUS in src/page.html, the visible text of
supabase/email/*.html, and the meta descriptions in build.py.

A violation is new when its (source, key, check) is not in voice-baseline.json, or when the
string changed since the baseline was taken. So every new or edited string must be clean,
and old copy only blocks once someone touches it. voice-allow.json holds approved exceptions
({"<source>|<key>|<check>": "reason"}).

Only what a script can decide with certainty lives here. Whether a line sounds like Raz is
the review step (the rowdyql-voice skill, fed by --changed).
"""
import hashlib, html, json, os, re, subprocess, sys

VOICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASELINE = os.path.join(VOICE, "voice-baseline.json")
ALLOW = os.path.join(VOICE, "voice-allow.json")
HEB = "א-ת"
LETTER = re.compile(f"[{HEB}]")
# files outside the voice folder that must point at it; checked so the folder can move safely
POINTERS = ["CLAUDE.md", "README.md", ".agents/rules/hebrew-copy.md", ".agents/skills/hebrew-copy/SKILL.md",
            ".claude/skills/rowdyql-voice/SKILL.md", ".claude/settings.json", "build.py"]


def repo_root():
    d = VOICE
    while d != os.path.dirname(d):
        if os.path.exists(os.path.join(d, "build.py")) and os.path.exists(os.path.join(d, "src", "page.html")):
            return d
        d = os.path.dirname(d)
    sys.exit("voice_check: could not find the repo root (build.py + src/page.html) above " + VOICE)


REPO = repo_root()
VOICE_REL = os.path.relpath(VOICE, REPO).replace("\\", "/")


# ---------------------------------------------------------------- sources

PAIR = re.compile(r'([A-Za-z_0-9]+)\s*:\s*"((?:[^"\\]|\\.)*)"')
ARR = re.compile(r'([A-Za-z_0-9]+)\s*:\s*\[\s*\[')


def _arrays(block):
    out = {}
    for m in ARR.finditer(block):
        i, depth = block.index("[", m.start()), 0
        for j in range(i, len(block)):
            depth += {"[": 1, "]": -1}.get(block[j], 0)
            if depth == 0:
                break
        try:
            rows = json.loads(block[i:j + 1])
        except ValueError:
            continue
        for a, row in enumerate(rows):
            for b, v in enumerate(row if isinstance(row, list) else [row]):
                if isinstance(v, str):
                    out[f"{m.group(1)}.{a}.{b}"] = json.dumps(v, ensure_ascii=False)[1:-1]
    return out


def page_strings(src):
    """{(lang, 'TABLE.lang.key'): raw JS string body} for the I18N and I18N_CAMPUS tables."""
    out = {}
    for name, start, end in (("I18N", "const I18N = {", "const I18N_CAMPUS = {"),
                             ("I18N_CAMPUS", "const I18N_CAMPUS = {", "const CAMPUS = {")):
        if start not in src or end not in src:
            continue
        blk = src[src.index(start):src.index(end)]
        he, en = blk.index("he: {"), blk.index("\nen: {")
        for lang, part in (("he", blk[he:en]), ("en", blk[en:])):
            table = {**dict(PAIR.findall(part)), **_arrays(part)}
            for k, v in table.items():
                out[(lang, f"{name}.{lang}.{k}")] = v
    return out


def email_strings(root):
    out, folder = {}, os.path.join(root, "supabase", "email")
    if not os.path.isdir(folder):
        return out
    for f in sorted(os.listdir(folder)):
        if not f.endswith(".html") or f == "preview.html":
            continue
        s = open(os.path.join(folder, f), encoding="utf-8").read()
        s = re.sub(r"<(style|script)[^>]*>.*?</\1>", " ", s, flags=re.S)
        s = re.sub(r"\{\{.*?\}\}", " ", s)
        for line in html.unescape(re.sub(r"<[^>]+>", "\n", s)).splitlines():
            line = line.strip()
            if len(LETTER.findall(line)) >= 3:
                out[("he", f"email/{f}#{_h(line)}")] = line
    return out


def meta_strings(root):
    s = open(os.path.join(root, "build.py"), encoding="utf-8").read()
    return {("he", f"build.py/{m.group(1)}#{_h(m.group(2))}"): m.group(2)
            for m in re.finditer(r'(name="description"|property="og:description") content="([^"]*)"', s)}


def collect(page_src=None):
    src = page_src if page_src is not None else open(os.path.join(REPO, "src", "page.html"), encoding="utf-8").read()
    return {**page_strings(src), **email_strings(REPO), **meta_strings(REPO)}


def _h(s):
    return hashlib.sha1(s.encode("utf-8")).hexdigest()[:10]


def visible(raw):
    """What the reader sees: tags, placeholders and escapes out."""
    t = raw.replace('\\"', '"').replace("\\n", " ").replace("\\'", "'")
    t = re.sub(r"<[^>]+>", " ", t)
    return re.sub(r"\s+", " ", t).strip()


# ---------------------------------------------------------------- checks

def words(pattern):
    """Hebrew-aware whole word: no Hebrew letter on either side; one optional prefix letter."""
    return re.compile(f"(?<![{HEB}])[ושהבלמכ]?(?:{pattern})(?![{HEB}])")


HE_FORM = words("נקלט|נקלטה|נקלטו|אנא|הנך|הינו|הינה|הינם|הינן|ניתן|מהווה|מהווים|מהוות|לפיכך|הרצוי|הרצויה|הרצויים"
                "|לבירור")
# אינו and family, but not after ש: "סטודנטים שאינם מנהלים" is how exam questions are phrased
HE_FORM_NEG = re.compile(f"(?<![{HEB}])ו?(?:אינו|אינה|אינם|אינן)(?![{HEB}])")
HE_FORM_PHRASES = re.compile(f"על מנת|במידה ו|במידה ש|כמו כן|נוסף לכך|בהתאם ל|"
                             f"(?<![{HEB}])(?:ב?אשר)(?![{HEB}])|"   # bare אשר / באשר; not לאשר (to confirm)
                             f"(?:בוצע|בוצעה|נשמר|נשמרה|נשמרו|עודכן|עודכנה|נמחק|נמחקה|נשלח|נשלחה|נוצר|נוצרה) בהצלחה|"
                             f"(?<![{HEB}])יש ל(?!(?:נו|כם|כן|ך|י|ו|ה|הם|הן)(?![{HEB}]))[{HEB}]{{2,}}")
# not לחץ alone: "בלי לחץ" is a noun; the imperative comes as "לחץ על"
# no prefix letters except ו: להירשם, לבדוק are infinitives
HE_IMPER_SG = re.compile(f"(?<![{HEB}])ו?(?:בדוק|הרץ|דלג|הזן|הקלד|היכנס|התחבר|הירשם|גלול)(?![{HEB}])"
                         f"|(?<![{HEB}])ו?לחץ על")
HE_CALQUE = re.compile("לחיות איתה|נשמר לחשבון|הוטלו על|הוטל על|ממחישים חיים")
HE_SUMMARY = re.compile("לסיכום|בשורה התחתונה|כפי שראינו|בסיכומו של דבר")
HE_SLASH = re.compile(f"[{HEB}]/(?:ה|ית|ות|תם|תן)(?![{HEB}])")
EN_FORMAL = re.compile(r"\b(kindly|successfully|utili[sz]e[sd]?|in order to|prior to|hereby|aforementioned|please note)\b", re.I)
EN_HYPE = re.compile(r"\b(empower|seamless(?:ly)?|leverage|journey|delve|dive in|level up|supercharge)\b", re.I)
EN_SUMMARY = re.compile(r"\b(in summary|to sum up|in conclusion|as we've seen|as we have seen)\b", re.I)
EN_EASE = re.compile(r"\b(simply|obviously|easily)\b", re.I)
EN_PLEASE = re.compile(r"\bplease\b", re.I)
EN_STIFF = re.compile(r"\b(?:(?:do|does|did|is|are|was|were|have|has|would|could|should) not|(?:you|we|they) are|"
                      r"(?:it|that|there|what) is|I am|let us)\b")
EMOJI = re.compile("[\U0001F300-\U0001FAFF☀-⛿]|(?<![\\w(])[:;]-?[()DP](?![\\w])")
DASH = re.compile(r"—|(?<!\d)–|–(?!\d)")   # an en dash between numbers (1–6) is fine
# an escaped double quote in the JS string, unless it is gershayim between Hebrew letters (ד"ר, תשפ"ו)
QUOTE = re.compile(f'(?<![{HEB}])\\\\"|\\\\"(?![{HEB}])')
COLON_LEADS = ("למשל", "לדוגמה", "לדוגמא", "פתרון", "רמז", "הערה", "שימו לב", "ניסוח שקול", "תשובה",
               "e.g", "for example", "solution", "hint", "note", "answer")


def colon_hits(raw, lang):
    """Colons doing a slogan's job: a whole clause before the colon ("הדרך הכי טבעית להתחיל היא גיליון אחד:").
    Allowed: labels of up to two words or starting with a symbol or code ("רמז 1:", "σ:", "Rides.RiderID →:"),
    times and ratios, a bold label, a lead word (למשל, רמז...), and anything before a placeholder, quote,
    code or symbol."""
    t = raw.replace('\\"', '"')
    letters = f"[{HEB}]" if lang == "he" else "[A-Za-z]"
    hits = []
    for m in re.finditer(":", t):
        i = m.start()
        before, after = t[:i], t[i + 1:]
        if before.rfind("<") > before.rfind(">"):          # inside a tag or attribute
            continue
        if re.search(r"\d$", before) and re.match(r"\d", after):   # 12:30, 0:2
            continue
        if re.search(r"</(b|strong)>\s*$", before):        # <b>לא תואם</b>: ...
            continue
        seg = re.split(r"[.?!]\s", re.sub(r"<[^>]+>", "", before))[-1].strip().lower()
        if any(seg.endswith(w) for w in COLON_LEADS):
            continue
        if not seg or not re.match(letters, seg):           # starts with a symbol, code or a number
            continue
        if sum(1 for w in seg.split() if re.search(letters, w)) <= 2:   # a short label
            continue
        nxt = re.sub(r"^\s*(<[^>]+>\s*)*", "", after)
        if not nxt or re.match(r"[{\"'„“A-Za-z0-9σπρ⋈∪∩−×÷←→(\[]", nxt):
            continue
        hits.append(visible(before)[-25:] + ":" + visible(after)[:25])
    return hits


# (id, lang, severity, message, finder(raw, vis) -> list of matched snippets)
CHECKS = [
    ("form-register", "he", "error", "Form or academic register (voice-profile.md, Don't 1)",
     lambda r, v: [m.group(0) for rx in (HE_FORM, HE_FORM_NEG, HE_FORM_PHRASES) for m in rx.finditer(v)]),
    ("colon-slogan", "he", "error", "Colon doing a slogan's job; use a dash, a period or 'אבל' (Don't 2)",
     lambda r, v: colon_hits(r, "he")),
    ("singular-imperative", "he", "error", "Singular imperative; the site speaks in plural (copy rules 1-2)",
     lambda r, v: [m.group(0) for m in HE_IMPER_SG.finditer(v)]),
    ("calque", "he", "error", "Known calque or phrase nobody says (copy rules 4, Don't 4)",
     lambda r, v: [m.group(0) for m in HE_CALQUE.finditer(v)]),
    ("summary-ending", "he", "error", "Summary ending (Don't 7)",
     lambda r, v: [m.group(0) for m in HE_SUMMARY.finditer(v)]),
    ("gender-slash", "he", "error", "Gender slash form; rephrase instead (copy rules 1)",
     lambda r, v: [m.group(0) for m in HE_SLASH.finditer(v)]),
    ("double-quote", "he", "error", "Double quotes inside a string; use single quotes (copy rules, Format)",
     lambda r, v: ['"'] if QUOTE.search(re.sub(r"<[^>]+>", "", r)) else []),
    ("formal-en", "en", "error", "Form or office English (voice-profile-en.md, Don't 1)",
     lambda r, v: [m.group(0) for m in EN_FORMAL.finditer(v)]),
    ("hype-en", "en", "error", "Startup/AI-marketing word (EN Don't 2)",
     lambda r, v: [m.group(0) for m in EN_HYPE.finditer(v)]),
    ("summary-en", "en", "error", "Summary ending (EN Don't 6)",
     lambda r, v: [m.group(0) for m in EN_SUMMARY.finditer(v)]),
    ("emoji", "*", "error", "Emoji or text emoticon (Don't; copy rules, Format)",
     lambda r, v: [m.group(0) for m in EMOJI.finditer(v)]),
    ("em-dash", "*", "error", "Em or en dash; use a spaced hyphen ( - ) or a period",
     lambda r, v: [m.group(0) for m in DASH.finditer(v)]),
    ("exclamations", "*", "warn", "More than one exclamation mark (Don't 9)",
     lambda r, v: ["!" * v.count("!")] if v.count("!") > 1 else []),
    ("colon-en", "en", "warn", "Colon doing a slogan's job (EN Don't 3)",
     lambda r, v: colon_hits(r, "en")),
    ("please-en", "en", "warn", "'please' only for a real request (EN Don't 1)",
     lambda r, v: [m.group(0) for m in EN_PLEASE.finditer(v)]),
    ("ease-en", "en", "warn", "Condescending ease word (EN Don't 5)",
     lambda r, v: [m.group(0) for m in EN_EASE.finditer(v)]),
    ("stiff-en", "en", "warn", "Uncontracted, reads translated (EN Don't 10)",
     lambda r, v: [m.group(0) for m in EN_STIFF.finditer(v)]),
]
MESSAGES = {c[0]: (c[2], c[3]) for c in CHECKS}


def scan(strings):
    """[(source_key, check_id, severity, lang, raw, snippets)]"""
    found = []
    for (lang, key), raw in strings.items():
        vis = visible(raw)
        if not vis:
            continue
        for cid, clang, sev, _, fn in CHECKS:
            if clang not in ("*", lang):
                continue
            hits = fn(raw, vis)
            if hits:
                found.append((key, cid, sev, lang, raw, hits))
    return found


def pointer_problems():
    """Every file that points at the voice folder must name its current path."""
    probs = []
    for rel in POINTERS:
        p = os.path.join(REPO, rel)
        if not os.path.exists(p):
            probs.append(f"{rel} is missing (it should point at {VOICE_REL}/)")
        elif f"{VOICE_REL}/" not in open(p, encoding="utf-8").read().replace("\\", "/"):
            probs.append(f"{rel} does not mention {VOICE_REL}/ (was the voice folder moved?)")
    return probs


# ---------------------------------------------------------------- baseline and reporting

def _load(path):
    return json.load(open(path, encoding="utf-8")) if os.path.exists(path) else {}


def _id(key, cid):
    return f"{key}|{cid}"


def split_new(found):
    """(new, known, fixed_count): known = in the baseline with the same text, or allowed."""
    base, allow = _load(BASELINE), _load(ALLOW)
    new, known = [], []
    for f in found:
        i = _id(f[0], f[1])
        (known if base.get(i) == _h(f[4]) or i in allow else new).append(f)
    live = {_id(f[0], f[1]) for f in found}
    return new, known, sum(1 for i in base if i not in live)


def show(rows, label):
    for key, cid, sev, lang, raw, hits in rows:
        sev_txt = "ERROR" if sev == "error" else "warn "
        print(f"  {label}{sev_txt} {key}  [{cid}]  {', '.join(dict.fromkeys(hits))}")
        print(f"        {visible(raw)[:140]}")
        print(f"        -> {MESSAGES[cid][1]}")


def gate(verbose=True):
    """Run by build.py. Prints the report; True when nothing new blocks."""
    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except (AttributeError, ValueError):
        pass
    probs = pointer_problems()
    new, known, fixed = split_new(scan(collect()))
    errors = [f for f in new if f[2] == "error"]
    warns = [f for f in new if f[2] == "warn"]
    print(f"voice check: {len(errors)} new error(s), {len(warns)} new warning(s); "
          f"{len(known)} known in the baseline (not blocking); {fixed} baseline entr{'y' if fixed == 1 else 'ies'} fixed")
    for p in probs:
        print("  ERROR pointer: " + p)
    show(errors, "")
    if verbose or errors:
        show(warns, "")
    if fixed:
        print(f"  (run  python {VOICE_REL}/scripts/voice_check.py --prune  to shrink the baseline)")
    return not errors and not probs


def changed():
    """Strings added or changed since git HEAD, for the review step."""
    try:
        head = subprocess.run(["git", "show", "HEAD:src/page.html"], cwd=REPO, capture_output=True, check=True).stdout.decode("utf-8")
    except (subprocess.CalledProcessError, FileNotFoundError):
        sys.exit("voice_check --changed: git HEAD not available")
    old, now = page_strings(head), page_strings(open(os.path.join(REPO, "src", "page.html"), encoding="utf-8").read())
    rows = [(k[1], old.get(k), v) for k, v in now.items() if old.get(k) != v]
    print(f"{len(rows)} string(s) added or changed since HEAD in src/page.html (emails: see git diff supabase/email)")
    for key, before, after in rows:
        print(f"\n[{key}]")
        print(f"  before: {visible(before) if before else '(new)'}")
        print(f"  now:    {visible(after)}")


def main(argv):
    sys.stdout.reconfigure(encoding="utf-8")
    if "--hook" in argv:
        try:
            path = json.load(sys.stdin).get("tool_input", {}).get("file_path", "").replace("\\", "/")
        except ValueError:
            path = ""
        if not (path.endswith("src/page.html") or "/supabase/email/" in path or path.endswith("/build.py")):
            return 0
        new, _, _ = split_new(scan(collect()))
        errors = [f for f in new if f[2] == "error"]
        if errors or pointer_problems():
            sys.stdout = sys.stderr
            gate(verbose=True)
            print("Fix these before building: the official voice blocks them (voice-profile.md).")
            return 2
        return 0
    if "--changed" in argv:
        changed()
        return 0
    found = scan(collect())
    if "--init-baseline" in argv:
        if os.path.exists(BASELINE) and "--force" not in argv:
            sys.exit("voice-baseline.json exists; --init-baseline is for the first run only (add --force to overwrite)")
        json.dump({_id(f[0], f[1]): _h(f[4]) for f in found}, open(BASELINE, "w", encoding="utf-8"),
                  ensure_ascii=False, indent=0, sort_keys=True)
        print(f"baseline written: {len(found)} known violation(s)")
        return 0
    if "--prune" in argv:
        base = _load(BASELINE)
        live = {_id(f[0], f[1]): _h(f[4]) for f in found}
        kept = {k: v for k, v in base.items() if live.get(k) == v}
        json.dump(kept, open(BASELINE, "w", encoding="utf-8"), ensure_ascii=False, indent=0, sort_keys=True)
        print(f"baseline pruned: {len(base) - len(kept)} fixed entr{'y' if len(base) - len(kept) == 1 else 'ies'} removed, {len(kept)} left")
        return 0
    if "--all" in argv:
        print(f"voice check, full audit: {len(found)} violation(s)")
        show(sorted(found, key=lambda f: (f[2], f[1], f[0])), "")
        return 0
    return 0 if gate() else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
