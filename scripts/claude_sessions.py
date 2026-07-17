#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2026-Jul-16 11:40
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import datetime
import glob
import json
import os
import subprocess
import sys

ROOT = os.path.expanduser("~/.claude/projects")
HOME = os.path.expanduser("~")


def parse_arguments():
    parser = argparse.ArgumentParser(description="Browse Claude Code sessions with fzf")
    parser.add_argument("query", nargs="?", default="", help="initial fzf query")
    parser.add_argument("--project", "-c", action="store_true", help="only sessions for the current directory")
    parser.add_argument("--print", "-p", dest="do_print", action="store_true", help="print session id instead of resuming")
    parser.add_argument("--emit", action="store_true", help="print cwd<TAB>session-id for a shell widget to pushd and resume")
    parser.add_argument("--preview", metavar="FILE", help="internal: render preview for one session file")
    return parser.parse_args()


def read_user_text(entry):
    content = entry.get("message", {}).get("content")
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        return " ".join(x.get("text", "") for x in content if isinstance(x, dict) and x.get("type") == "text")
    return ""


def scan(path):
    custom = ai = first = cwd = None
    try:
        for line in open(path, encoding="utf-8"):
            try:
                entry = json.loads(line)
            except ValueError:
                continue
            etype = entry.get("type")
            if etype == "custom-title":
                custom = entry.get("customTitle")
            elif etype == "ai-title":
                ai = entry.get("aiTitle")
            elif etype == "user" and first is None:
                text = read_user_text(entry).strip()
                if text and not text.startswith("<"):
                    first = text
            if cwd is None and entry.get("cwd"):
                cwd = entry["cwd"]
    except OSError:
        return None
    title = (custom or ai or first or "(no title)").replace("\t", " ").replace("\n", " ")[:80]
    sid = os.path.splitext(os.path.basename(path))[0]
    proj = (cwd or os.path.basename(os.path.dirname(path))).replace(HOME, "~")
    return (os.path.getmtime(path), proj, title, path, cwd or "", sid)


def build_list(only_project):
    rows = []
    for path in glob.glob(os.path.join(ROOT, "*", "*.jsonl")):
        row = scan(path)
        if row is None:
            continue
        if only_project and row[4] != os.getcwd():
            continue
        rows.append(row)
    lines = []
    for mtime, proj, title, path, cwd, sid in sorted(rows, key=lambda r: r[0], reverse=True):
        date = datetime.datetime.fromtimestamp(mtime).strftime("%Y-%m-%d %H:%M")
        lines.append("\t".join([date, proj, title, path, cwd, sid]))
    return lines


def render_preview(path):
    print("\033[1m" + path.replace(HOME, "~") + "\033[0m\n")
    shown = 0
    for line in open(path, encoding="utf-8"):
        try:
            entry = json.loads(line)
        except ValueError:
            continue
        if entry.get("type") != "user":
            continue
        text = " ".join(read_user_text(entry).split())
        if not text or text.startswith("<"):
            continue
        stamp = entry.get("timestamp", "")
        try:
            stamp = datetime.datetime.fromisoformat(stamp.replace("Z", "+00:00")).strftime("%m-%d %H:%M")
        except ValueError:
            pass
        print(f"\033[36m❯ {stamp}\033[0m {text[:200]}")
        shown += 1
        if shown >= 40:
            break


def main():
    args = parse_arguments()

    if args.preview:
        try:
            render_preview(args.preview)
        except (BrokenPipeError, OSError):
            pass
        return 0

    lines = build_list(args.project)
    if not lines:
        print("No Claude sessions found", file=sys.stderr)
        return 1

    preview_cmd = f"{sys.executable} {os.path.abspath(__file__)} --preview {{4}}"
    fzf = subprocess.run(
        ["fzf", "--ansi", "--delimiter", "\t", "--with-nth", "1,2,3",
         "--query", args.query, "--preview", preview_cmd,
         "--preview-window", "down,60%,wrap", "--header", "enter: resume  ctrl-c: cancel"],
        input="\n".join(lines), capture_output=True, text=True,
    )
    if fzf.returncode != 0 or not fzf.stdout.strip():
        return 0

    fields = fzf.stdout.rstrip("\n").split("\t")
    cwd, sid = fields[4], fields[5]

    if args.emit:
        print(f"{cwd}\t{sid}")
        return 0

    if args.do_print:
        print(sid)
        return 0

    if cwd and os.path.isdir(cwd):
        os.chdir(cwd)
    os.execvp("claude", ["claude", "--resume", sid])


if __name__ == "__main__":
    sys.exit(main())
