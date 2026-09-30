"""Save one article's body text for the voice corpus.

Usage: python voice/scripts/fetch_article.py <url> [<url> ...]

Writes voice/corpus/NN-<writer>-<id>.txt with a header (url, writer, date,
headline, word count) and the body paragraphs as-is, one per line. Prints one
status line per URL. Skips URLs already saved. Body = <p> text of 40+ chars,
minus boilerplate; the header comes from the page's NewsArticle JSON-LD.
"""
import html, json, os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "corpus")
UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128 Safari/537.36"
JUNK = re.compile(r"כל הזכויות שמורות|לחצו כאן|הצטרפו|ערוץ הטלגרם|קבוצת הוואטסאפ|לכתבה המלאה|צילום:|קרדיט|newsletter", re.I)


def get(url):
    r = subprocess.run(["curl", "-sL", "-A", UA, "-w", "\n%{url_effective}", url],
                       capture_output=True, timeout=60)
    body, _, final = r.stdout.decode("utf-8", "replace").rpartition("\n")
    return body, final


def meta(page):
    for raw in re.findall(r'<script[^>]*application/ld\+json[^>]*>(.*?)</script>', page, re.S):
        try:
            data = json.loads(raw)
        except ValueError:
            continue
        for d in data if isinstance(data, list) else [data]:
            if isinstance(d, dict) and d.get("@type") in ("NewsArticle", "Article", "ReportageNewsArticle"):
                a = d.get("author") or []
                a = a if isinstance(a, list) else [a]
                names = ", ".join(x.get("name", "") for x in a if isinstance(x, dict))
                return names, (d.get("datePublished") or "")[:10], d.get("headline") or ""
    return "", "", ""


def body(page):
    # <p> only (not <picture>/<path>); Walla marks body paragraphs article_speakable,
    # which leaves out captions, "more on Walla" teasers and sponsored links
    tags = re.findall(r"<p(\s[^>]*)?>(.*?)</p>", page, re.S)
    if any("article_speakable" in attrs for attrs, _ in tags):
        tags = [(a, p) for a, p in tags if "article_speakable" in a]
    paras = []
    for _, p in tags:
        t = html.unescape(re.sub(r"<[^>]+>", "", p)).strip()
        t = re.sub(r"\s+", " ", t)
        if len(t) >= 40 and not JUNK.search(t) and t not in paras:
            paras.append(t)
    return paras


def slug(s):
    s = re.sub(r"[^\w]+", "-", s, flags=re.U).strip("-")
    return s[:30] or "unknown"


def main(urls):
    os.makedirs(OUT, exist_ok=True)
    have = {}
    for f in os.listdir(OUT):
        if f.endswith(".txt"):
            first = open(os.path.join(OUT, f), encoding="utf-8").readline()
            have[first.replace("url:", "").strip()] = f
    n = len(have)
    for url in urls:
        page, final = get(url)
        if final in have or url in have:
            print(f"SKIP already saved: {have.get(final) or have.get(url)}")
            continue
        writer, date, headline = meta(page)
        paras = body(page)
        words = sum(len(p.split()) for p in paras)
        if words < 300:
            print(f"FAIL {url}: only {words} words extracted (paywall, video, or odd layout)")
            continue
        n += 1
        art_id = re.findall(r"\d{5,}", final)
        name = f"{n:02d}-{slug(writer)}-{art_id[-1] if art_id else n}.txt"
        with open(os.path.join(OUT, name), "w", encoding="utf-8") as fh:
            fh.write(f"url: {final}\nwriter: {writer}\ndate: {date}\nheadline: {headline}\nwords: {words}\n\n")
            fh.write("\n".join(paras) + "\n")
        have[final] = name
        print(f"OK   {name}  {words}w  {date}  {writer}  |  {headline}")


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    main(sys.argv[1:])
