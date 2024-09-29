#!/usr/bin/env python3

# Steen Hegelund
# Time-Stamp: 2024-Sep-28 16:30
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import os.path
import mailbox
import json


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', '-v', action='count', default=0)
    parser.add_argument('--maildir', '-d', nargs='*', default=[])

    return parser.parse_args()


def show_empty():
    res = {"text": "", "tooltip": "", "class": "", "percentage": 0}
    print(json.dumps(res))


class MailFolder:
    def __init__(self, path):
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


def get_mail_status(args):
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

    tooltip = ''
    for fld in folders:
        tooltip += f'{os.path.basename(fld.path)}: {fld.unread} unread of {fld.total}\n'
    res = {"text": text, "tooltip": tooltip, "class": status, "percentage": 100}
    print(json.dumps(res))


def main():
    args = parse_arguments()
    get_mail_status(args)


if __name__ == '__main__':
    main()

