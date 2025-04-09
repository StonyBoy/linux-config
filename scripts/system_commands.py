#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2025-Apr-09 20:06
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :
# Provide a system menu for Niri

import argparse
import subprocess
import time
import sys

# scripts/system_commands.py | $(fuzzel -d -l 12 -f 'Inconsolata:style=Regular:size=12' -a top -p 'Select>' -t 000080ff -S fdf6e3ff -s ff6347ff -b f5deb3ff)


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('action', nargs='?', default='')

    return parser.parse_args()


def main():
    menu = {
        'cancel': 'notify-send Cancelling',
        'logout': 'niri msg action quit',
        'suspend': 'sudo systemctl suspend',
        'hibernate': 'sudo systemctl hibernate',
        'reboot': 'sudo systemctl reboot',
        'poweroff': 'sudo systemctl poweroff',
    }
    args = parse_arguments()
    if args.action:
        if args.action in menu.keys():
            cmd = menu[args.action].split()
            if args.action != 'cancel':
                subprocess.run(['notify-send', menu[args.action]])
                time.sleep(5)
            subprocess.run(cmd)
    else:
        for action in menu.keys():
            print(action)


if __name__ == '__main__':
    main()

sys.exit(0)
