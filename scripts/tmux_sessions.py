#!/usr/bin/env python3

# Steen Hegelund
# Time-Stamp: 2024-Jun-28 14:37
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import subprocess
import re
import sys


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('server_session', nargs='?', default='')
    parser.add_argument('--get', '-g', action='append', default=[])
    parser.add_argument('--inline', '-i', action='store_true')
    parser.add_argument('--verbose', '-v', action='store_true')

    return parser.parse_args()


class TmuxServer:
    srvre = re.compile(r'^(\S+):')

    def __init__(self, name='localhost'):
        self.name = name
        self.alive = self.is_server_alive()
        self.sessions = []
        self.get_sessions()

    def ping_server(self):
        cp = subprocess.run(['ping', '-Aqc 5', '-W 0.1', self.name], capture_output=True)
        return cp.returncode == 0

    def is_server_alive(self):
        if self.name == 'localhost':
            return True
        return self.ping_server()

    def parse_response(self, cp):
        if cp.returncode == 0:
            lines = cp.stdout.decode().split('\n')
            for line in lines:
                mt = self.srvre.match(line)
                if mt:
                    self.sessions.append(mt.group(1))

    def get_sessions(self):
        if self.alive:
            if self.name == 'localhost':
                self.parse_response(subprocess.run(['tmux', 'list-sessions'], capture_output=True))
            else:
                self.parse_response(subprocess.run(['ssh', self.name, 'tmux', 'list-sessions'], capture_output=True))

    def print_sessions(self):
        for session in self.sessions:
            if self.name != 'localhost':
                print(f'{self.name}@{session}')
            else:
                print(session)


def get_tmux_sessions(args):
    servers = [TmuxServer()]
    for server in args.get:
        servers.append(TmuxServer(server))
    for server in servers:
        server.print_sessions()


def attach(args):
    if '@' in args.server_session:
        server, session = args.server_session.split('@')
        title = f'{{{session}}} @ {server}'
        if args.inline:
            cmd = ['ssh', '-t', server, 'tmux', '-u', 'attach-session', '-t', session]
        else:
            cmd = ['alacritty', '--title', title, '-e', 'ssh', '-t', server, 'tmux', '-u', 'attach-session', '-t', session]
    else:
        session = args.server_session
        title = f'{{{session}}}'
        if args.inline:
            cmd = ['tmux', '-u', 'attach-session', '-t', session]
        else:
            cmd = ['alacritty', '--title', title, '-e', 'tmux', '-u', 'attach-session', '-t', session]

    # Specifying a pipe for the 3 std devices allows the process to run detached
    if args.verbose:
        print(f'Command: {' '.join(cmd)}')
    if args.inline:
        subprocess.run(cmd)
    else:
        subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)


def main():
    args = parse_arguments()
    if args.server_session:
        attach(args)
    else:
        get_tmux_sessions(args)


if __name__ == '__main__':
    main()

sys.exit(0)
