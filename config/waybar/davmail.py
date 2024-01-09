#!/usr/bin/env python3
import argparse
import os.path
import re
import datetime
import json


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', '-v', action='count', default=0)
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
        if self.event == 'FAILED':
            self.status = 'error'
        elif diff < datetime.timedelta(hours=1):
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


def show_davmail_status(args, history):
    if args.verbose:
        for evt in history:
            print(f'evt: {evt}')
    history.reverse()
    for evt in history:
        if evt.event == 'FAILED' or evt.event == 'Email' or evt.event == 'DISCONNECT' or evt.event == 'UID':
            evt.show()
            break


def parse_log(args):
    info = re.compile(r'(\S+\s+\S+)\s+INFO\s+\S+\s+\S+\s+-\s+(\S+).*')
    debug = re.compile(r'(\S+\s+\S+)\s+DEBUG\s+\S+\s+(\S+)\s+(.*)')
    email = re.compile(r'.*FETCH.*INTERNALDATE\s*\"([^"]+)\s+\S+\"')
    uid = re.compile(r'.*FETCH\s+\(UID\s+\d+')
    history = []

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
                    else:
                        mtt = uid.match(mt.group(3))
                        if mtt:
                            if len(history) > 0 and history[-1].event == 'UID':
                                history[-1] = DavMailEvent(mt.group(1), 'UID')
                            else:
                                history.append(DavMailEvent(mt.group(1), 'UID'))
                        elif args.verbose > 1:
                            line = line.strip('\n')
                            print(f"Line: {line}")
        if len(history) > 0:
            show_davmail_status(args, history)

    return len(history) > 0


def get_davmail_status(args):
    if args.logpath is None:
        args.logpath = '~/davmail.log'

    if not parse_log(args):
        show_empty()
        if args.verbose:
            print('No events found in the log')


def main():
    arguments = parse_arguments()
    get_davmail_status(arguments)


if __name__ == '__main__':
    main()
