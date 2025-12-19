#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2025-Dec-19 14:12
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import json
import os
import enum


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', '-v', action='count', default=0)
    parser.add_argument('--service', '-s', nargs='+', help='Service to monitor', default=[])
    parser.add_argument('--process', '-p', nargs='+', help='Process to monitor', default=[])

    return parser.parse_args()


class ScopeType(enum.IntEnum):
    UNDEF = 0
    SERVICE = 1
    PROCESS = 2


class MemoryScope:
    def __init__(self, name: str, scope_type: ScopeType, verbose=False):
        self.name = name
        self.usedmem = 0
        self.peakmem = 0
        self.verbose = verbose

        match scope_type:
            case ScopeType.SERVICE:
                cgroup_path = self.get_cgroup_path_by_name(name)
                self.usedmem, self.peakmem = self.get_cgroup_memory(cgroup_path)
                self.name = name.removesuffix('.service')

            case ScopeType.PROCESS:
                pid = self.get_pid_by_name(name)
                if pid is None:
                    return
                cgroup_path = self.get_cgroup_path_by_pid(pid)
                if cgroup_path is None:
                    return
                self.usedmem, self.peakmem = self.get_cgroup_memory(cgroup_path)

    def get_memory_value(self, cgroup_path, filename):
        mem_file = os.path.join(cgroup_path, filename)
        if self.verbose:
            print(mem_file)
        value = 0
        try:
            with open(mem_file, 'r') as f:
                value = int(f.read().strip())
        except Exception:
            pass
        return value

    def get_cgroup_memory(self, cgroup_path):
        mem_current = self.get_memory_value(cgroup_path, 'memory.current')
        mem_peak = self.get_memory_value(cgroup_path, 'memory.peak')
        return (mem_current / (1024 ** 3), mem_peak / (1024 ** 3))

    def get_cgroup_path_by_name(self, target, base='/sys/fs/cgroup/user.slice'):
        for root, dirs, files in os.walk(base):
            for name in dirs + files:
                if name == target:
                    return os.path.join(root, name)
        return None

    def get_pid_by_name(self, proc_name):
        for pid in os.listdir('/proc'):
            if pid.isdigit():
                try:
                    with open(f'/proc/{pid}/comm', 'r') as f:
                        name = f.read().strip()
                    if name.startswith(proc_name):
                        return pid
                except Exception:
                    continue
        return None

    def get_cgroup_path_by_pid(self, pid):
        try:
            with open(f'/proc/{pid}/cgroup', 'r') as f:
                for line in f:
                    # For cgroup v2, look for '0::'
                    if 'memory' in line or '0::' in line:
                        path = line.strip().split(':')[-1]
                        return os.path.join('/sys/fs/cgroup', path.lstrip('/'))
        except Exception:
            pass
        return None

    def __str__(self):
        return f'{self.name}: {self.usedmem:0.1f}GB {self.peakmem:0.1f}GB'


def main():
    args = parse_arguments()
    items = []
    for servname in args.service:
        items.append(MemoryScope(servname, ScopeType.SERVICE))
    for procname in args.process:
        items.append(MemoryScope(procname, ScopeType.PROCESS))
    used = sum(item.usedmem for item in items)
    peak = max(item.peakmem for item in items)
    text = f'Used Mem: {used:0.1f}GB, Peak Mem: {peak:0.1f}GB'
    tooltip = '\n'.join(str(item) for item in items)
    info = {'text': text, 'tooltip': tooltip, 'class': 'ok'}
    print(json.dumps(info))


if __name__ == '__main__':
    main()
