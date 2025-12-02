#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2025-Dec-02 15:03
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import subprocess
import re
import json


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', '-v', action='count', default=0)

    return parser.parse_args()


class TaskInfo:
    def __init__(self, pid, user, pctmem, rss, oom, cmd):
        self.pid = pid
        self.user = user
        self.pctmem = pctmem
        self.rss = int(rss) / 1024 / 1024
        self.oom = oom
        self.cmd = cmd[0:35]

    def tooltip(self):
        return f'<span foreground="#f1c40f">{self.pctmem}%</span> <b>{self.rss:0.2f}GB</b> <tt>{self.pid:>6s} {self.user} {self.oom}</tt> {self.cmd}'

    def __str__(self):
        return f"{self.pid}: {self.user} {self.pctmem} {self.cmd}"


def get_memory_info():
    meminfo = {}
    with open('/proc/meminfo', 'r') as f:
        for line in f:
            parts = line.split()
            key = parts[0].rstrip(':')
            value = int(parts[1])
            meminfo[key] = value

    # Values are in kB, convert to GB
    total = meminfo['MemTotal'] / 1024 / 1014
    available = meminfo['MemAvailable'] / 1024 / 1024
    used = total - available
    return used, total


def get_task_status(args: argparse.Namespace):
    cmd = ["ps", "-axo", "pid,user,pmem,rss,oom,cmd", "--sort=-pmem"]
    cp = subprocess.run(cmd, capture_output=True)
    lines = cp.stdout.decode().split('\n')
    taskrex = re.compile(r'\s*(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(.*)')
    tasks = []
    for line in lines[1:6]:
        mt = taskrex.match(line)
        if mt:
            tasks.append(TaskInfo(*mt.groups()))

    if args.verbose:
        for task in tasks:
            print(task.tooltip())

    usedmem, totalmem = get_memory_info()
    text = f'{usedmem:0.1f}GB {totalmem:0.1f}GB'
    tooltip = '\n'.join([task.tooltip() for task in tasks])
    tooltips = {'text': text, 'tooltip': tooltip, 'class': 'ok'}
    print(json.dumps(tooltips))


def main():
    args = parse_arguments()
    get_task_status(args)


if __name__ == '__main__':
    main()
