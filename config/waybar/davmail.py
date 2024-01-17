#!/usr/bin/env python3

# Steen Hegelund
# Time-Stamp: 2024-Jan-17 11:24
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import os.path
import re
import datetime
import json


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', '-v', action='count', default=0)
    parser.add_argument('--logpath', '-l', default='~/davmail.log')

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

    def show_status(self, diff, tooltip):
        if self.event == 'FAILED':
            self.status = 'error'
        elif self.event == 'BROKEN':
            self.status = 'warning'
        elif diff < datetime.timedelta(hours=1):
            self.status = 'ok'
        elif diff < datetime.timedelta(days=1):
            self.status = 'warning'
        else:
            self.status = 'error'

        if self.status == 'ok':
            return show_empty()

        text = f"DavMail: {self.status}"
        res = {"text": text, "tooltip": tooltip, "class": self.status, "percentage": 100}
        print(json.dumps(res))

    def show_email(self):
        diff = self.timestamp - self.elemtimestamp
        tooltip = f"DavMail Status:\n  Last: {show_datetime(self.timestamp)}\n  Email: {show_datetime(self.elemtimestamp)}"
        self.show_status(diff, tooltip)

    def show_info(self):
        diff = self.elemtimestamp - self.timestamp
        tooltip = f"DavMail Status:\n  Last: {show_datetime(self.timestamp)}"
        self.show_status(diff, tooltip)

    def show(self):
        if self.event == 'Email':
            self.show_email()
        else:
            self.show_info()

    def __str__(self):
        return f'{self.timestamp}: {self.event} {self.elemtimestamp}'


class EventHistory:
    def __init__(self):
        self.history = []

    def append(self, event):
        if len(self.history) > 0 and self.history[-1].event == event.event:
            # Filter out duplicate events
            self.history[-1] = event
        else:
            self.history.append(event)

    def nonempty(self):
        return len(self.history) > 0

    def reverse(self):
        self.history.reverse()

    def __iter__(self):
        return self.history.__iter__()


def show_empty():
    res = {"text": "", "tooltip": "", "class": "", "percentage": 0}
    print(json.dumps(res))


def show_davmail_status(history):
    history.reverse()
    for evt in history:
        if evt.event == 'FAILED' or evt.event == 'BROKEN':
            evt.show()
            return
    for evt in history:
        if evt.event == 'Email' or evt.event == 'CONNECT' or evt.event == 'UID':
            evt.show()
            return


def parse_log(args):
    info = re.compile(r'(\S+\s+\S+)\s+INFO\s+\S+\s+\S+\s+-\s+(\S+).*')
    debug = re.compile(r'(\S+\s+\S+)\s+DEBUG\s+\S+\s+(\S+)\s+(.*)')
    email = re.compile(r'.*FETCH.*INTERNALDATE\s*\"([^"]+)\s+\S+\"')
    uid = re.compile(r'.*FETCH\s+\(UID\s+\d+')
    pipeerr = re.compile(r'.*Exception sending error to client Broken pipe')
    history = EventHistory()

    with open(os.path.expanduser(args.logpath), 'rt') as fobj:
        lines = fobj.readlines()
        for line in lines:
            mt = info.match(line)
            if mt:
                history.append(DavMailEvent(mt.group(1), mt.group(2)))
                continue
            mt = debug.match(line)
            if mt:
                if mt.group(2) == 'davmail.imap.ImapConnection':
                    mtt = email.match(mt.group(3))
                    if mtt:
                        history.append(DavMailEvent(mt.group(1), 'Email', mtt.group(1)))
                    continue
                mtt = uid.match(mt.group(3))
                if mtt:
                    history.append(DavMailEvent(mt.group(1), 'UID'))
                    continue
                mtt = pipeerr.match(mt.group(3))
                if mtt:
                    history.append(DavMailEvent(mt.group(1), 'BROKEN'))
                    continue
                if args.verbose > 1:
                    line = line.strip('\n')
                    print(f"Line: {line}")

    return history


def get_davmail_status(args):
    if args.logpath is None:
        args.logpath = '~/davmail.log'

    if os.path.exists(args.logpath):
        history = parse_log(args)
        if history.nonempty():
            if args.verbose:
                for evt in history:
                    print(f'evt: {evt}')
            show_davmail_status(history)
            return
    show_empty()
    if args.verbose:
        print('No events found in the log')


def main():
    arguments = parse_arguments()
    get_davmail_status(arguments)


if __name__ == '__main__':
    main()
