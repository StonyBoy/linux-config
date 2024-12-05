#!/usr/bin/env python3

# Steen Hegelund
# Time-Stamp: 2024-Dec-05 17:17
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import subprocess
import json


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', '-v', action='count', default=0)
    parser.add_argument('--zone', '-z', nargs='*', default=[],
                        help='List of timezones names as found in the IANA time zone database')
    parser.add_argument('--name', '-n', nargs='*', default=[],
                        help='User friendly name of the timezones in the same order as in --zone')

    return parser.parse_args()


def get_zone(zone: str | None = None, name: str | None = None) -> str:
    if zone and name:
        cmd = ['date', f'+<span foreground="#f1c40f">{name}</span>: %Y-%m-%d %H:%M:%S']
        cp = subprocess.run(cmd, capture_output=True, env={'TZ': zone})
    else:
        cmd = ['date', '+%Y-%m-%d %H:%M:%S %Z']
        cp = subprocess.run(cmd, capture_output=True)
    return cp.stdout.decode().split('\n')[0]


def get_datetime(args: argparse.Namespace):
    current = get_zone()
    if len(args.zone) == 0 or len(args.zone) != len(args.name):
        print(json.dumps({'text': current, 'tooltip': 'Current Date/Time', 'class': 'multi-clock', 'percentage': 0}))
    else:
        zones = []
        if args.zone:
            for idx, zone in enumerate(args.zone):
                zones.append(get_zone(zone, args.name[idx]))
        print(json.dumps({'text': current, 'tooltip': '\n'.join(zones), 'class': 'multi-clock', 'percentage': 0}))


def main():
    args = parse_arguments()
    get_datetime(args)


if __name__ == '__main__':
    main()
