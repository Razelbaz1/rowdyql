"""Wraps src/page.html (the artifact body) into a standalone index.html (the full build, for the local tests), and writes the
public build to dist/ and the paid chapter packs to dist-packs/ (see the end of this file).

First runs the voice check (the site's official voice, raz-elbaz-brand-identity-kit/voice/voice-profile.md) and stops on
new voice errors. --allow-voice builds anyway; use it only when Raz approved that text.
"""
import re, pathlib, sys, importlib.util

VOICE_CHECK = "raz-elbaz-brand-identity-kit/voice/scripts/voice_check.py"   # update if the voice folder moves
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

# Not inside a frame of another site (clickjacking): the page stays hidden unless it is the top window.
# GitHub Pages can't send X-Frame-Options or frame-ancestors, so this is the in-page guard.
FRAME_GUARD = "if(self===top){var g=document.getElementById('fg');g.parentNode.removeChild(g)}else{try{top.location.replace(location.href)}catch(e){}}"

# Content-Security-Policy: scripts only from this page (by hash), the pinned supabase-js and Turnstile.
# An injected <script> or onerror="" never runs, and data can only be sent to our own hosts.
# A new inline <script> in src/page.html gets its hash here automatically; a new outside host must be added below.
import hashlib, base64
def sha(s): return "'sha256-" + base64.b64encode(hashlib.sha256(s.encode("utf-8")).digest()).decode() + "'"
inline = [sha(FRAME_GUARD)] + [sha(s) for s in re.findall(r"<script(?![^>]*\bsrc=)[^>]*>(.*?)</script>", body, re.S)]
SB = "afzlmlbigruxijudqukp.supabase.co"
CSP = "; ".join([
    "default-src 'self'",
    "script-src 'self' " + " ".join(inline) + " https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.118.0/ https://challenges.cloudflare.com",
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
    "font-src 'self' https://fonts.gstatic.com data:",
    f"img-src 'self' data: blob: https://{SB}",
    f"connect-src 'self' https://{SB} wss://{SB} https://challenges.cloudflare.com",
    "frame-src https://challenges.cloudflare.com",
    "worker-src 'self'", "manifest-src 'self'", "media-src 'self' data: blob:",
    "object-src 'none'", "base-uri 'none'", "form-action 'self'",
])
html = f"""<!doctype html>
<html lang="he" dir="rtl">
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Security-Policy" content="{CSP}">
<style id="fg">html{{display:none!important}}</style><script>{FRAME_GUARD}</script>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title}</title>
<meta name="description" content="RowdyQL: SQL בגובה העיניים. הקורס שהופך את SQL לשפה שלכם.">
<link rel="icon" type="image/svg+xml" href="favicon.svg">
<link rel="apple-touch-icon" href="apple-touch-icon.png">
<link rel="manifest" href="manifest.json">
<meta name="theme-color" content="#F7F2EC" media="(prefers-color-scheme: light)"><meta name="theme-color" content="#11161B" media="(prefers-color-scheme: dark)">
<meta name="apple-mobile-web-app-capable" content="yes"><meta name="apple-mobile-web-app-title" content="RowdyQL"><meta name="apple-mobile-web-app-status-bar-style" content="default">
<link rel="canonical" href="https://rowdyql.com/">
<meta property="og:type" content="website"><meta property="og:title" content="RowdyQL · SQL בגובה העיניים"><meta property="og:description" content="הקורס שהופך את SQL לשפה שלכם."><meta property="og:url" content="https://rowdyql.com/"><meta property="og:image" content="https://rowdyql.com/og.jpg?v=2026-10-14"><meta property="og:image:type" content="image/jpeg"><meta property="og:image:width" content="1200"><meta property="og:image:height" content="630"><meta name="twitter:card" content="summary_large_image">
<style>:root{{color-scheme:light dark}}body{{margin:0}}img{{max-width:100%}}[hidden]{{display:none!important}}</style>
</head>
<body>
{body}
</body>
</html>
"""
pathlib.Path("index.html").write_text(html, encoding="utf-8")
print("index.html written,", len(html), "chars")

# ---- The public build (dist/) and the chapter packs (dist-packs/) ----
# index.html above is the full build: every pack inline, for the local tests. The public build cuts each region marked
# /*@pack <chapter>*/ … /*@/pack*/ out of the page and writes it to dist-packs/<chapter>.js; the page then loads a pack from the
# server (pack_tickets → the pack Edge Function) only for an account that has that chapter. dist/ is what the host publishes;
# dist-packs/ is uploaded to the database and never published.
import json, shutil
PACK_RE = re.compile(r"/\*@pack (\w+)\*/\n(.*?)/\*@/pack\*/\n?", re.S)
i0 = body.index("const I18N = {"); he0 = body.index("he: {", i0); en0 = body.index("\nen: {", he0)
i1 = body.index("/* =========================== STATE & HELPERS", en0)
packs = {}
for m in PACK_RE.finditer(body):
    part = "he" if he0 < m.start() < en0 else "en" if en0 < m.start() < i1 else "code"
    packs.setdefault(m.group(1), {"he": [], "en": [], "code": []})[part].append(m.group(2))
public = PACK_RE.sub("", body)
if "/*@pack" in public or "/*@/pack" in public:
    sys.exit("build stopped: an unmatched pack mark is left in the public build")
out_packs = pathlib.Path("dist-packs"); shutil.rmtree(out_packs, ignore_errors=True); out_packs.mkdir()
sri = {}
for name, p in sorted(packs.items()):
    js = (f"/* RowdyQL pack: {name} */\nObject.assign(I18N.he, {{\n{''.join(p['he'])}}});\nObject.assign(I18N.en, {{\n{''.join(p['en'])}}});\n"
          + "".join(p["code"]))
    if f"PACKS.have.add('{name}')" not in js:
        sys.exit(f"build stopped: the {name} pack never marks itself loaded (PACKS.have.add('{name}'))")
    (out_packs / f"{name}.js").write_bytes(js.encode("utf-8"))   # bytes as hashed: no newline translation on Windows
    sri[name] = "sha384-" + base64.b64encode(hashlib.sha384(js.encode("utf-8")).digest()).decode()
(out_packs / "manifest.json").write_text(json.dumps(sri, indent=1) + "\n", encoding="utf-8")
if public.count("const PACK_SRI = {};") != 1:
    sys.exit("build stopped: the PACK_SRI placeholder is missing")
public = public.replace("const PACK_SRI = {};", "const PACK_SRI = " + json.dumps(sri) + ";", 1)
PACK_SRC = f"https://{SB}/functions/v1/pack"
pub_inline = [sha(FRAME_GUARD)] + [sha(s) for s in re.findall(r"<script(?![^>]*\bsrc=)[^>]*>(.*?)</script>", public, re.S)]
pub_csp = CSP.replace(" ".join(inline), " ".join(pub_inline), 1).replace("script-src 'self' ", "script-src 'self' " + PACK_SRC + " ", 1)
pub_html = html.replace(CSP, pub_csp, 1).replace(body, public, 1)
out = pathlib.Path("dist"); shutil.rmtree(out, ignore_errors=True); out.mkdir()
(out / "index.html").write_text(pub_html, encoding="utf-8")
for f in ["favicon.svg", "favicon.ico", "apple-touch-icon.png", "manifest.json", "sw.js", "icon-192.png", "icon-512.png", "badge-72.png",
          "og.jpg", "og.png", "email-logo.png", "email-logo-light.png"]:
    shutil.copy(f, out / f)
shutil.copytree("email-titles", out / "email-titles")
# Response headers on the host (Cloudflare): what a <meta> can't do (frame-ancestors, HSTS) plus the usual hardening.
(out / "_headers").write_text("""/*
  Strict-Transport-Security: max-age=31536000; includeSubDomains
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  Content-Security-Policy: frame-ancestors 'none'
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=(), usb=()
  Cross-Origin-Opener-Policy: same-origin
""", encoding="utf-8")
print("dist/ written (public build,", len(pub_html), "chars); packs:", ", ".join(f"{k} {len((out_packs / (k + '.js')).read_text(encoding='utf-8'))} chars" for k in sri))
