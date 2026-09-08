#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import datetime
import glob
import json
import os
import subprocess

ROOT = os.path.expanduser("~/.claude/projects")
HOME = os.path.expanduser("~")


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="list running claude sessions for waybar")
    parser.add_argument('--verbose', '-v', action='count', default=0)
    return parser.parse_args()


def read_title(entry, current):
    if entry.get("type") == "custom-title":
        current["name"] = entry.get("customTitle")
    elif entry.get("type") == "agent-name" and current.get("name") is None:
        current["name"] = entry.get("agentName")


def find_session_id(cwd, started_after):
    project_dir = os.path.join(ROOT, cwd.replace("/", "-"))
    candidates = glob.glob(os.path.join(project_dir, "*.jsonl"))
    candidates = [c for c in candidates if os.path.getmtime(c) >= started_after]
    if not candidates:
        return None, None
    path = max(candidates, key=os.path.getmtime)
    name = None
    try:
        for line in open(path, encoding="utf-8"):
            try:
                entry = json.loads(line)
            except ValueError:
                continue
            if entry.get("type") == "custom-title":
                name = entry.get("customTitle")
            elif entry.get("type") == "agent-name" and name is None:
                name = entry.get("agentName")
    except OSError:
        pass
    sid = os.path.splitext(os.path.basename(path))[0]
    return sid, name


class ClaudeSession:
    def __init__(self, pid, started, cwd):
        self.pid = pid
        self.started = started
        self.cwd = cwd.replace(HOME, "~")
        self.sid, self.name = find_session_id(cwd, started.timestamp())

    def label(self):
        return self.name or (self.sid[:8] if self.sid else self.pid)

    def short_cwd(self):
        parts = self.cwd.split("/")
        return "/".join(parts[-2:]) if len(parts) > 2 else self.cwd

    def tooltip(self):
        when = self.started.strftime("%d-%b %H:%M")
        return (f'<span foreground="#f1c40f">{self.label():<20}</span> <tt>{when}</tt> '
                f'<span foreground="#85c1e9">{self.short_cwd()}</span>')


def get_running_sessions():
    cmd = ["ps", "-eo", "pid,lstart,cmd"]
    cp = subprocess.run(cmd, capture_output=True, text=True)
    sessions = []
    for line in cp.stdout.splitlines()[1:]:
        parts = line.split(None, 6)
        if len(parts) < 7:
            continue
        pid, cmd = parts[0], parts[6]
        if os.path.basename(cmd.split()[0]) != "claude":
            continue
        lstart_str = " ".join(parts[1:6])
        try:
            started = datetime.datetime.strptime(lstart_str, "%a %b %d %H:%M:%S %Y")
        except ValueError:
            continue
        try:
            cwd = os.readlink(f"/proc/{pid}/cwd")
        except OSError:
            continue
        sessions.append(ClaudeSession(pid, started, cwd))
    return sessions


def show_status(args: argparse.Namespace):
    sessions = get_running_sessions()
    sessions.sort(key=lambda s: s.started, reverse=True)

    if args.verbose:
        for session in sessions:
            print(session.tooltip())

    text = f'{len(sessions)}'
    tooltip = '\n'.join(session.tooltip() for session in sessions) if sessions else 'No running Claude sessions'
    status = {'text': text, 'tooltip': tooltip, 'class': 'ok' if sessions else 'idle'}
    print(json.dumps(status))


def main():
    args = parse_arguments()
    show_status(args)


if __name__ == '__main__':
    main()
