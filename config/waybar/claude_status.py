#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import datetime
import glob
import json
import os
import re
import shlex
import subprocess

ROOT = os.path.expanduser("~/.claude/projects")
RUNDIR = f"/tmp/claude-{os.getuid()}"
HOME = os.path.expanduser("~")
SID_RE = re.compile(r'/tasks$')
UUID_RE = re.compile(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')


def parse_cmdline(cmd):
    # --resume <sid> gives the exact session id; -n <name> gives sb's display name.
    args = shlex.split(cmd)
    sid = name = None
    i = 0
    while i < len(args):
        if args[i] == "--resume" and i + 1 < len(args):
            candidate = args[i + 1]
            if UUID_RE.match(candidate):
                sid = candidate
            i += 2
        elif args[i] == "-n" and i + 1 < len(args):
            name = args[i + 1]
            i += 2
        else:
            i += 1
    return sid, name


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="list running claude sessions for waybar")
    parser.add_argument('--verbose', '-v', action='count', default=0)
    return parser.parse_args()


def find_session_id_via_fd(pid):
    # older claude builds keep the per-session tasks dir open as an fd; fast path.
    fd_dir = f"/proc/{pid}/fd"
    try:
        entries = os.listdir(fd_dir)
    except OSError:
        return None
    for entry in entries:
        try:
            target = os.readlink(os.path.join(fd_dir, entry))
        except OSError:
            continue
        if target.startswith(RUNDIR) and SID_RE.search(target):
            return os.path.basename(os.path.dirname(target))
    return None


def find_project_dir(cwd):
    # the project dir is keyed by the launch/repo root, not necessarily the exact cwd.
    parts = cwd.split("/")
    for i in range(len(parts), 0, -1):
        candidate = "/".join(parts[:i])
        d = os.path.join(ROOT, candidate.replace("/", "-"))
        if os.path.isdir(d):
            return d
    return None


def find_session_id_via_transcript(cwd, started_after, used_sids):
    # newer claude builds hold no fd marker; match a transcript by cwd and start time instead.
    project_dir = find_project_dir(cwd)
    if not project_dir:
        return None
    best_sid, best_ts = None, None
    for path in glob.glob(os.path.join(project_dir, "*.jsonl")):
        sid = os.path.splitext(os.path.basename(path))[0]
        if sid in used_sids:
            continue
        try:
            with open(path, encoding="utf-8") as f:
                for _ in range(20):
                    line = f.readline()
                    if not line:
                        break
                    try:
                        entry = json.loads(line)
                    except ValueError:
                        continue
                    if entry.get("cwd") == cwd:
                        ts = entry.get("timestamp", "")
                        try:
                            when = datetime.datetime.fromisoformat(ts.replace("Z", "+00:00")).timestamp()
                        except ValueError:
                            continue
                        if when >= started_after - 5 and (best_ts is None or when < best_ts):
                            best_sid, best_ts = sid, when
                        break
        except OSError:
            continue
    return best_sid


def read_session_name(project_dir, sid):
    if not project_dir or not sid:
        return None
    path = os.path.join(project_dir, f"{sid}.jsonl")
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
    return name


class ClaudeSession:
    def __init__(self, pid, started, cwd, cmd, used_sids):
        self.pid = pid
        self.started = started
        self.cwd = cwd.replace(HOME, "~")
        cmd_sid, cmd_name = parse_cmdline(cmd)
        self.sid = (cmd_sid or find_session_id_via_fd(pid)
                    or find_session_id_via_transcript(cwd, started.timestamp(), used_sids))
        if self.sid:
            used_sids.add(self.sid)
        project_dir = find_project_dir(cwd)
        self.name = cmd_name or (read_session_name(project_dir, self.sid) if self.sid else None)

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
    used_sids = set()
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
        sessions.append(ClaudeSession(pid, started, cwd, cmd, used_sids))
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
