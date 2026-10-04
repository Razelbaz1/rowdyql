"""Pull the messages Raz typed himself out of local Claude transcripts.

Usage: python raz-elbaz-brand-identity-kit/voice/scripts/extract_raz.py

Reads top-level session transcripts (not subagent ones) from ~/.claude/projects
and from the Claude desktop app's local sessions. Keeps only what Raz typed:
drops tool results, meta entries, system reminders, IDE selections, pasted or
attached documents, slash-command wrappers and interruption markers. The text
itself is kept exactly as typed. Writes raz-elbaz-brand-identity-kit/voice/raz-sample/messages.md (every
message, oldest first, with date and project) and prints a short summary.
"""
import glob, json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HOME = os.path.expanduser("~")
SOURCES = [
    os.path.join(HOME, ".claude", "projects", "*", "*.jsonl"),
    os.path.join(os.environ.get("LOCALAPPDATA", ""), "Packages", "Claude_*", "LocalCache", "Roaming", "Claude",
                 "local-agent-mode-sessions", "*", "*", "*", ".claude", "projects", "*", "*.jsonl"),
]
# wrappers the harness adds around or instead of what the user typed
DROP_BLOCKS = re.compile(
    r"<(system-reminder|ide_selection|ide_opened_file|ide_diagnostics|pasted_content|command-name|command-message|"
    r"command-args|local-command-stdout|local-command-stderr|bash-input|bash-stdout|bash-stderr|user-prompt-submit-hook|"
    r"document|task-notification|antml:document)\b[^>]*>.*?</\1>", re.S)
DROP_WHOLE = re.compile(r"^(\[Request interrupted|Caveat: The messages below|This session is being continued|"
                        r"Base directory for this skill|<command-|\[Image #\d+\]\s*$|Tool loaded\.?$)", re.S)
HEB = re.compile(r"[֐-׿]")
LAT = re.compile(r"[A-Za-z]")


def texts(entry):
    content = entry.get("message", {}).get("content")
    if isinstance(content, str):
        return [content]
    if isinstance(content, list):
        return [b.get("text", "") for b in content if isinstance(b, dict) and b.get("type") == "text"]
    return []


def clean(t):
    t = DROP_BLOCKS.sub("", t)
    t = re.sub(r"</?(pasted_content|document)[^>]*>", "", t)
    t = re.sub(r"\[Image #\d+\]", "", t)
    return t.strip()


def project_name(path):
    parts = path.replace("\\", "/").split("/")
    return parts[parts.index("projects") + 1] if "projects" in parts else "?"


def main():
    rows, seen = [], set()
    for pattern in SOURCES:
        for f in glob.glob(pattern):
            if "subagents" in f.replace("\\", "/").split("/"):
                continue
            for line in open(f, encoding="utf-8", errors="replace"):
                try:
                    e = json.loads(line)
                except ValueError:
                    continue
                if e.get("type") != "user" or e.get("isMeta") or e.get("isSidechain"):
                    continue
                for raw in texts(e):
                    t = clean(raw)
                    if not t or DROP_WHOLE.match(t):
                        continue
                    key = re.sub(r"\s+", " ", t)
                    if key in seen:
                        continue
                    seen.add(key)
                    rows.append((e.get("timestamp", "")[:16].replace("T", " "), project_name(f), t))
    rows.sort()
    out = os.path.join(ROOT, "raz-sample", "messages.md")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, "w", encoding="utf-8") as fh:
        fh.write("# Raz's own messages to Claude, unedited\n\n")
        fh.write("Extracted by raz-elbaz-brand-identity-kit/voice/scripts/extract_raz.py. Only harness wrappers were removed; the text is as typed.\n\n")
        for ts, proj, t in rows:
            fh.write(f"---\n[{ts}] {proj}\n\n{t}\n\n")
    heb = [r for r in rows if len(HEB.findall(r[2])) > len(LAT.findall(r[2]))]
    words = sum(len(r[2].split()) for r in rows)
    hwords = sum(len(r[2].split()) for r in heb)
    print(f"{len(rows)} messages, {words} words; mostly-Hebrew: {len(heb)} messages, {hwords} words")
    print(f"range {rows[0][0]} .. {rows[-1][0]}" if rows else "none")
    print(f"written to {out}")


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    main()
