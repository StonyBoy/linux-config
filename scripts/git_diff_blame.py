#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2025-Apr-09 20:05
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

'''
Do a diff over a commit range and blame the diffhunks to find which commit changed the line
This can be used to find the commit where a change needs to be added in a series of commits
'''
import subprocess
import argparse
import re
import sys


def parse_arguments():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)

    parser.add_argument('-c', '--commits', action='store_true', help='Show list of commits referred in the diff')
    parser.add_argument('-d', '--diff', action='store_true', help='Use plain diff instead of delta to show hunks')
    parser.add_argument('range', help='Commit or commit range to process')
    parser.add_argument('files', nargs='*', help='Files to be diffed')

    return parser.parse_args()


def run(cmd):
    cp = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if cp.returncode == 0:
        return cp.stdout.decode().split('\n')
    print(cmd, cp.stderr.decode())
    sys.exit(1)


class Hunk:
    blame_regex = re.compile(r'^(\^?[0-9a-f]+)\s+((\S+\s+)?\([^\)]+\))\s+(.*)')

    def __init__(self, box, start):
        self.box = box
        self.start = start
        self.shas = {}
        self.hunklines = []
        self.blamehunklines = []

    def update(self, lines, end):
        self.hunklines = lines[self.start:end]

    @staticmethod
    def _blame_at(blame_lines, line_num):
        if line_num < 1 or line_num > len(blame_lines):
            return None
        bline = blame_lines[line_num - 1]
        if not bline:
            return None
        found = Hunk.blame_regex.findall(bline)
        return found[0] if found else None

    @staticmethod
    def _format(sign, sha, content):
        return '{} {} {}'.format(sign, sha, content) if content else '{} {}'.format(sign, sha)

    def resolve(self, blame_begin, blame_end):
        old_line = int(self.box[0])
        new_line = int(self.box[2])
        for line in self.hunklines:
            self.blamehunklines.append(line)
            if line.startswith('-'):
                binfo = self._blame_at(blame_begin, old_line)
                if binfo:
                    self.blamehunklines[-1] = self._format('-', binfo[0], line[1:])
                    self.shas[binfo[0]] = binfo[1]
                old_line += 1
            elif line.startswith('+'):
                binfo = self._blame_at(blame_end, new_line)
                if binfo:
                    self.blamehunklines[-1] = self._format('+', binfo[0], line[1:])
                    self.shas[binfo[0]] = binfo[1]
                new_line += 1
            elif line.startswith(' '):
                old_line += 1
                new_line += 1

    def get_commits(self):
        return self.shas

    def show(self, use_diff):
        if use_diff:
            print('\n'.join(self.blamehunklines))
        else:
            input = '\n'.join(self.blamehunklines)
            subprocess.run(['delta'], input=input.encode())

    def __str__(self):
        return 'file: {}'.format(self.file)


class DiffFile:
    hunk_regex = re.compile(r'^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@')

    def __init__(self, file, rge, use_diff):
        self.file = file
        self.range = rge
        self.use_diff = use_diff
        self.begin = rge
        self.end = 'HEAD'
        if '..' in self.begin:
            self.begin, self.end = self.begin.split('..')
        # blame_begin attributes removed lines to whoever last touched them before the range
        self.blame_begin = self._get_blame(self.begin)
        # blame_end is restricted to the range so added lines resolve to a commit inside it
        self.blame_end = self._get_blame(f'{self.begin}..{self.end}')
        self._hunks()

    def _get_diff(self):
        return run(['git', '--no-pager', 'diff', f'{self.range}', '--', self.file])

    def _get_blame(self, rev):
        return run(['git', '--no-pager', 'blame', '-M', rev, '--', self.file])

    def _hunks(self):
        self.hunks = []
        lines = self._get_diff()
        start = None
        for idx, line in enumerate(lines):
            hunkmatch = DiffFile.hunk_regex.findall(line)
            if hunkmatch:
                hunk = Hunk(hunkmatch[0], idx)
                if start is not None:
                    self.hunks[-1].update(lines, idx)
                start = idx
                self.hunks.append(hunk)
        if start:
            self.hunks[-1].update(lines, -1)
        for hunk in self.hunks:
            hunk.resolve(self.blame_begin, self.blame_end)

    def _get_commit(self, rev):
        return run(['git', '--no-pager', 'show', '-s', '--format="%h %as %ae %s"', rev.lstrip('^')])[0]

    def header(self, text):
        print(f'##### {text} #####')

    def show_commits(self):
        commits = {}
        for hunk in self.hunks:
            commits.update(hunk.get_commits())
        self.header(f'Commits referred : {self.file}')
        for sha in commits.keys():
            print("  ", self._get_commit(sha))

    def show(self, commits):
        self.header(str(self))
        for hunk in self.hunks:
            hunk.show(self.use_diff)
        if commits:
            print()
            self.show_commits()

    def __str__(self):
        return f'{self.file}: {self.begin}..{self.end}'


def non_empty(line):
    return len(line) > 0


def main():
    args = parse_arguments()

    if len(args.files) == 0:
        args.files = list(filter(non_empty, run(['git', '--no-pager', 'diff', '--name-only', f'{args.range}'])))

    for file in args.files:
        dfile = DiffFile(file, args.range, args.diff)
        dfile.show(args.commits)


if __name__ == '__main__':
    main()

