#!/usr/bin/env python3

# Steen Hegelund
# Time-Stamp: 2024-Aug-19 21:07
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import subprocess
import json


def get_window_status():
    cmd = ['niri', 'msg', '-j', 'focused-window']
    cp = subprocess.run(cmd, capture_output=True)
    if cp.returncode == 0:
        value = json.loads(cp.stdout.decode())
        if 'title' in value:
            res = {"text": value['title'], "tooltip": 'Window Title', "class": 'ok', "percentage": 100}
            print(json.dumps(res))
            return
    print(json.dumps({"text": '', "tooltip": 'Window Title', "class": 'error', "percentage": 100}))


def main():
    get_window_status()


if __name__ == '__main__':
    main()
