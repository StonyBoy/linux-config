#!/usr/bin/env python3

# Steen Hegelund
# Time-Stamp: 2024-Dec-05 17:15
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import os.path
import mailbox
import json
import subprocess
import datetime
import re


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', '-v', action='count', default=0, help='Provide more information')
    parser.add_argument('--maildir', '-d', nargs='*', default=[], help='List of maildir folders to scan')
    parser.add_argument('--logpath', '-l', help='The Davmail logfile to parse for status')
    parser.add_argument('--mailsync', '-m', action='store_true', help='Run mailsync')

    return parser.parse_args()


def show_empty():
    res = {"text": "None", "tooltip": "", "class": "warning", "percentage": 0}
    print(json.dumps(res))


class MailFolder:
    def __init__(self, path: str):
        self.path = os.path.expanduser(path)
        self.unread = 0
        self.total = 0
        mdir = mailbox.Maildir(self.path, None, False)
        for msg in mdir.itervalues():
            if 'S' not in msg.get_flags():
                self.unread += 1
            self.total += 1

    def __str__(self):
        return f'{self.unread} unread of {self.total} in {os.path.basename(self.path)}'


class DavMailEvent:
    def __init__(self, etype, datetimestr, eventstr, elemstr=None):
        self.etype = etype
        self.event = eventstr
        self.timestamp = datetime.datetime.fromisoformat(datetimestr.replace(',', '.'))
        self.elemtimestamp = datetime.datetime.now(tz=None)
        if elemstr:
            self.elemtimestamp = datetime.datetime.strptime(elemstr, '%d-%b-%Y %H:%M:%S')

    def show_status(self, diff, tooltip):
        status = 'ok'
        if diff < datetime.timedelta(hours=1):
            self.status = 'ok'
        elif diff < datetime.timedelta(days=1):
            self.status = 'warning'
        if self.etype == 'Error':
            status = 'error'
        text = f'DavMail: {status}'
        res = {"text": text, "tooltip": tooltip, "class": status, "percentage": 100}
        print(json.dumps(res))

    def show_datetime(self):
        return self.timestamp.strftime('%d-%b-%Y %H:%M:%S')

    def show(self):
        diff = self.elemtimestamp - self.timestamp
        tooltip = f"DavMail Status:\n  Last: {self.show_datetime()}"
        self.show_status(diff, tooltip)

    def __str__(self):
        return f'{self.etype}: {self.timestamp}: {self.event} {self.elemtimestamp}'


def mail_sync(args: argparse.Namespace) -> list[str]:
    cmd = ['systemctl', '--user', 'restart', 'mbsync.service']
    cp = subprocess.run(cmd, capture_output=True)
    return cp.stdout.decode().split('\n')


def get_mail_status(args: argparse.Namespace):
    folders = []
    for maildir in args.maildir:
        if os.path.exists(maildir):
            folders.append(MailFolder(maildir))

    if len(folders) == 0:
        show_empty()
        if args.verbose:
            print('Maildir not found')
        return

    main = folders[0]
    status = 'unchanged'
    text = "No"
    if main.unread > 0:
        status = 'new'
        text = f"{main.unread} unread"

    tooltip = ''
    for fld in folders:
        tooltip += f'{os.path.basename(fld.path)}: {fld.unread} unread of {fld.total}\n'
    res = {"text": text, "tooltip": tooltip, "class": status, "percentage": 100}
    print(json.dumps(res))


def parse_davmail_log(args: argparse.Namespace) -> list[DavMailEvent]:
    info = re.compile(r'(\S+\s+\S+)\s+INFO\s+\S+\s+\S+\s+-\s+(\S+).*')
    error = re.compile(r'(\S+\s+\S+)\s+ERROR\s+\S+\s+\S+\s+-\s+(\S+.*)')
    history = []

    with open(os.path.expanduser(args.logpath), 'rt') as fobj:
        lines = fobj.readlines()
        for line in lines:
            mt = info.match(line)
            if mt:
                history.append(DavMailEvent('Info', mt.group(1), mt.group(2)))
                continue
            mt = error.match(line)
            if mt:
                history.append(DavMailEvent('Error', mt.group(1), mt.group(2)))
                continue

    return history


def get_davmail_status(args: argparse.Namespace) -> bool:
    if args.logpath is None:
        args.logpath = '~/davmail.log'

    if os.path.exists(args.logpath):
        history = parse_davmail_log(args)
        if len(history) > 2:
            if args.verbose > 1:
                for evt in history:
                    print(f'evt: {evt}')
            for idx in range(-3, 0):
                evt = history[idx]
                if args.verbose == 1:
                    print(f'evt: {evt}')
                if evt.etype == 'Error':
                    evt.show()
                    return False
            return True
    return False


def main():
    args = parse_arguments()
    if args.mailsync:
        mail_sync(args)
    if get_davmail_status(args):
        get_mail_status(args)
    else:
        show_empty()


if __name__ == '__main__':
    main()

