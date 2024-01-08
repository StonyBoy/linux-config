#!/usr/bin/env python3
import argparse
import os.path
import re
import datetime
import json


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('--logpath', default='~/davmail.log')

    return parser.parse_args()


def show_datetime(dt):
    return dt.strftime('%d-%b-%Y %H:%M:%S')


class DavMailEvent:
    def __init__(self, datetimestr, eventstr, elemstr=None):
        self.timestamp = datetime.datetime.fromisoformat(datetimestr.replace(',', '.'))
        self.event = eventstr
        self.elemtimestamp = datetime.datetime.now(tz=None)
        if elemstr:
            self.elemtimestamp = datetime.datetime.strptime(elemstr, '%d-%b-%Y %H:%M:%S')

    def show(self):
        if self.event == 'Email':
            self.show_email()
        else:
            self.show_info()

    def show_email(self):
        diff = self.timestamp - self.elemtimestamp
        # print(f'diff: {diff}')
        if diff < datetime.timedelta(hours=1):
            self.status = 'ok'
        elif diff < datetime.timedelta(days=1):
            self.status = 'warning'
        else:
            self.status = 'error'
        text = f"DavMail: {self.status}"
        tooltip = f"DavMail Status:\n  Last: {show_datetime(self.timestamp)}\n  Email: {show_datetime(self.elemtimestamp)}"
        res = {"text": text, "tooltip": tooltip, "class": self.status, "percentage": 100}
        print(json.dumps(res))

    def show_info(self):
        diff = self.elemtimestamp - self.timestamp
        # print(f'diff: {diff}')
        if diff < datetime.timedelta(hours=1):
            self.status = 'ok'
        elif diff < datetime.timedelta(days=1):
            self.status = 'warning'
        else:
            self.status = 'error'
        text = f"DavMail: {self.status}"
        tooltip = f"DavMail Status:\n  Last: {show_datetime(self.timestamp)}"
        res = {"text": text, "tooltip": tooltip, "class": self.status, "percentage": 100}
        print(json.dumps(res))

    def __str__(self):
        return f'{self.timestamp}: {self.event} {self.elemtimestamp if not self.elemtimestamp is None else ""}'


def show_empty():
    res = {"text": "", "tooltip": "", "class": "", "percentage": 0}
    print(json.dumps(res))


def get_davmail_status(args):
    info = re.compile(r'(\S+\s+\S+)\s+INFO\s+\S+\s+\S+\s+-\s+(\S+).*')
    debug = re.compile(r'(\S+\s+\S+)\s+DEBUG\s+\S+\s+(\S+)\s+(.*)')
    email = re.compile(r'.*FETCH.*INTERNALDATE\s*\"([^"]+)\s+\S+\"')
    history = []
    found = False

    if args.logpath is None:
        args.logpath = '~/davmail.log'

    with open(os.path.expanduser(args.logpath), 'rt') as fobj:
        lines = fobj.readlines()
        for line in lines:
            mt = info.match(line)
            if mt:
                history.append(DavMailEvent(mt.group(1), mt.group(2)))
            else:
                mt = debug.match(line)
                if mt:
                    if mt.group(2) == 'davmail.imap.ImapConnection':
                        mtt = email.match(mt.group(3))
                        if mtt:
                            history.append(DavMailEvent(mt.group(1), 'Email', mtt.group(1)))

        if len(history):
            history[-1].show()
            found = True
    if not found:
        show_empty()


def main():
    arguments = parse_arguments()
    get_davmail_status(arguments)


if __name__ == '__main__':
    main()
