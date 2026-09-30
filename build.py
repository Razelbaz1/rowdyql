"""Wraps src/page.html (the artifact body) into a standalone index.html for GitHub Pages.

First runs the voice check (the site's official voice, voice/voice-profile.md) and stops on
new voice errors. --allow-voice builds anyway; use it only when Raz approved that text.
"""
import re, pathlib, sys, importlib.util

VOICE_CHECK = "voice/scripts/voice_check.py"   # update if the voice folder moves
spec = importlib.util.spec_from_file_location("voice_check", VOICE_CHECK)
if not spec or not pathlib.Path(VOICE_CHECK).exists():
    sys.exit(f"build stopped: {VOICE_CHECK} not found (was the voice folder moved? update VOICE_CHECK)")
voice = importlib.util.module_from_spec(spec); spec.loader.exec_module(voice)
if not voice.gate(verbose=False):
    if "--allow-voice" not in sys.argv:
        sys.exit("build stopped: fix the voice errors above, or rerun with --allow-voice if Raz approved this text")
    print("!!! --allow-voice: building with voice errors, because it was asked for explicitly")

body = pathlib.Path("src/page.html").read_text(encoding="utf-8")
m = re.search(r"<title>(.*?)</title>", body); title = m.group(1) if m else "RowdyQL"
body = body.replace(m.group(0), "", 1) if m else body
html = f"""<!doctype html>
<html lang="he" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title}</title>
<meta name="description" content="RowdyQL: סביבת לימוד אינטראקטיבית לקורס תכנון בסיסי נתונים">
<link rel="icon" type="image/svg+xml" href="favicon.svg">
<meta property="og:type" content="website"><meta property="og:title" content="RowdyQL"><meta property="og:description" content="עוד לא מבינים מילה? הגעתם בול בזמן."><meta property="og:url" content="https://rowdyql.com/"><meta property="og:image" content="https://rowdyql.com/og.png"><meta name="twitter:card" content="summary_large_image">
<style>:root{{color-scheme:light dark}}body{{margin:0}}img{{max-width:100%}}[hidden]{{display:none!important}}</style>
</head>
<body>
{body}
</body>
</html>
"""
pathlib.Path("index.html").write_text(html, encoding="utf-8")
print("index.html written,", len(html), "chars")
