#!/usr/bin/env python3

import os
import time
import json
import posix

SECS_PER_DAY = 86400
SECS_PER_HOUR = 3600
SECS_PER_MINUTE = 60


def show_host_info(uname: posix.uname_result, secs: int):
    sep = chr(0xf104)
    days = secs // SECS_PER_DAY
    remainder = secs % SECS_PER_DAY
    hours = remainder // SECS_PER_HOUR
    minutes = remainder % SECS_PER_HOUR // SECS_PER_MINUTE

    text = f"<b>{uname.nodename}</b>: {days}{sep}{hours:>02}{sep}{minutes:>02}"
    tooltip = f"Host Information:\n  Hostname: {uname.nodename}\n  Release: {uname.release}\n  Uptime: {days} days {hours} hours {minutes} minutes"
    res = {"text": text, "tooltip": tooltip, "class": "custom-hostinfo", "percentage": 100}

    print(json.dumps(res))


def get_host_info():
    show_host_info(os.uname(), int(time.clock_gettime(time.CLOCK_BOOTTIME)))


def main():
    get_host_info()


if __name__ == '__main__':
    main()
