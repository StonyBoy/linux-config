#!/usr/bin/env python3

import argparse
import subprocess
import json
import os.path
import sys


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument('user')
    parser.add_argument('-p', '--path', default='/usr/local/bin/et')
    parser.add_argument('-s', '--server', default='dk')

    return parser.parse_args()


def show_easytest(elem: dict):
    text = f"{elem['name']}"
    tooltip = f"Easytest Status:\n  Server: {elem['name']}\n  Target: {elem['vsc']}\n  User: {elem['user']}\n  Since: {elem['date']} {elem['time']}"
    res = {"text": text, "tooltip": tooltip, "class": "custom-easytest", "percentage": 100}
    print(json.dumps(res))


def show_empty():
    res = {"text": "", "tooltip": "", "class": "", "percentage": 0}
    print(json.dumps(res))


def get_easytest_status(args: argparse.Namespace):
    found = False
    cp = subprocess.run([args.path, 'status', args.server], capture_output=True)
    if cp.returncode == 0:
        lines = cp.stdout.decode().split('\n')
        names = ['name', 'server', 'status', 'pcb', 'loop_port', 'loop_1pps', 'vsc', 'family', 'user', 'date', 'time']
        for line in lines[2:]:
            values = line.split()
            if len(values) > 2:
                elem = dict(zip(names, values))
                if elem['status'] == 'busy' and elem['user'] == args.user:
                    show_easytest(elem)
                    found = True
    if not found:
        show_empty()


def main():
    args = parse_arguments()
    if not os.path.exists(arguments.path):
        print(f"EasyTest is not found at {arguments.path}")
        sys.exit(1)
    get_easytest_status(args)


if __name__ == '__main__':
    main()
