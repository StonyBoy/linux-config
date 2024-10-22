#!/usr/bin/env python3

# Steen Hegelund
# Time-Stamp: 2024-Oct-22 16:36
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import subprocess
import re
import json


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', '-v', action='count', default=0)
    parser.add_argument('--user', '-u', nargs='*', default=[])
    parser.add_argument('--system', '-s', nargs='*', default=[])

    return parser.parse_args()


class UnitStatus:
    keyvalregex = re.compile(r'\s*(\S+):\s+(.*)')
    activeregex = re.compile(r'(\S+)\s+\((\S+)\)\s+since\s+([^;]+);\s+(.*)\s+ago')
    inactiveregex = re.compile(r'(\S+)\s+(.*)')
    tasksregex = re.compile(r'(\S+)\s+\(\S+\s+(\S+)\)')
    triggerregex = re.compile(r'\S+\s+(\S+)')
    timerregex = re.compile(r'([^;]+);\s+(.*)\s+left')

    def __init__(self, name, user=False):
        self.name = name
        self.state = ''
        self.tasks = ''
        self.memory = ''
        self.duration = ''
        self.trigger = ''
        self.timer = ''
        lines = self.cmd(user)
        for line in lines:
            mt = self.keyvalregex.match(line)
            if mt:
                if mt[1] == 'Active':
                    self.parse_active(mt[2])
                if mt[1] == 'Tasks':
                    self.parse_tasks(mt[2])
                if mt[1] == 'Memory':
                    self.memory = mt[2]
                if mt[1] == 'TriggeredBy':
                    self.parse_trigger(mt[2])
                if mt[1] == 'Trigger':
                    self.parse_timer(mt[2])

    def cmd(self, user):
        cmd = ['systemctl', 'status', self.name]
        if user:
            cmd = ['systemctl', '--user', 'status', self.name]

        cp = subprocess.run(cmd, capture_output=True)
        return cp.stdout.decode().split('\n')

    def parse_active(self, text):
        mt = self.activeregex.match(text)
        if mt:
            self.state = mt[2]
            self.duration = mt[4]
            return
        mt = self.inactiveregex.match(text)
        if mt:
            self.state = mt[1]
            self.duration = mt[2]

    def parse_tasks(self, text):
        mt = self.tasksregex.match(text)
        if mt:
            self.tasks = mt[1]

    def parse_trigger(self, text):
        mt = self.triggerregex.match(text)
        if mt:
            self.trigger = mt[1]

    def parse_timer(self, text):
        mt = self.timerregex.match(text)
        if mt:
            self.timer = mt[2]

    def __str__(self):
        result = f'{self.name} {self.state}'
        if self.duration:
            result += f' dur: {self.duration}'
        if self.tasks:
            result += f' tsk: {self.tasks}'
        if self.memory:
            result += f' mem: {self.memory}'
        if self.trigger:
            result += f' trg: {self.trigger}'
        if self.timer:
            result += f' tmr: {self.timer}'
        return result

    def tooltip(self):
        if '.timer' in self.name:
            kind = 'T'
            name = self.name.replace('.timer', '')
        else:
            kind = 'S'
            name = self.name.replace('.service', '')
        title = f'<tt>{kind} <span foreground="#f1c40f">{name}</span> <b>{self.state}</b></tt>'
        if self.state == 'running':
            return f'{title} for {self.duration}, {self.tasks}, {self.memory}\n'
        elif self.state == 'waiting' and len(self.timer):
            return f'{title} next in {self.timer}\n'
        elif self.state == 'dead' and len(self.trigger) > 0:
            return f'{title} triggered by {self.trigger}\n'
        elif len(self.state) > 0:
            return title + '\n'
        return ''


class UnitList:
    def __init__(self):
        self.units = []

    def append(self, unit):
        self.units.append(unit)

    def __len__(self):
        return len(self.units)

    def dump(self):
        for unit in self.units:
            print(unit)

    def combine(self):
        text = ''
        tooltip = ''
        cls = 'ok'
        if len(self.units):
            text = 'OK'
        for unit in self.units:
            tooltip += unit.tooltip()
            if unit.state == 'starting':
                text = f'Unit: {unit.name} {unit.state}'
                cls = 'warning'
            elif len(unit.trigger) == 0:
                if unit.state == 'dead' or unit.state == 'inactive' or unit.state == 'failed':
                    text = f'Unit: {unit.name} {unit.state}'
                    cls = 'error'
        return {'text': text, 'tooltip': tooltip, 'class': cls}


def get_unit_status(args):
    units = UnitList()
    if args.system:
        for sys in args.system:
            units.append(UnitStatus(sys))
    if args.user:
        for usr in args.user:
            units.append(UnitStatus(usr, True))

    if len(units) == 0:
        print(json.dumps({'text': '', 'tooltip': '', 'class': 'custom-systemd_unit', 'percentage': 0}))
    else:
        if args.verbose:
            units.dump()
        print(json.dumps(units.combine()))


def main():
    args = parse_arguments()
    get_unit_status(args)


if __name__ == '__main__':
    main()
