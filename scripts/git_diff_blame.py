#! /usr/bin/env python3
# Steen Hegelund
# Time-Stamp: 2022-Oct-17 15:52
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

'''
Diff a commit range and blame the diffhunks to find which commit added the line
This can be used to find the commit where a change needs to be added in a series of commits
'''
import subprocess
import argparse
import re

hunk_regex = re.compile(r'^@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@')
blame_regex = re.compile(r'^(\^?[0-9a-f]+)\s+((\S+\s+)?\([^\)]+\))\s+(.*)')

def run(cmd):
    cp = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if cp.returncode == 0:
        return cp.stdout.decode().split('\n')
    errormsg = cp.stderr.decode().split('\n')
    print(cmd, errormsg)
    return errormsg


def get_diff(oldrev, newrev, file):
    return run(['git', '--no-pager', 'diff', '{}..{}'.format(oldrev, newrev), '--', file])

def get_blame(rev, file, first, last):
    return run(['git', '--no-pager', 'blame', '-M', '-L{},{}'.format(first, last), rev, '--', file])

def show_commit(rev):
    return run(['git', '--no-pager', 'show', '-s', '--format="%h %as %ae %s"', rev])[0]

class Hunk:
    def __init__(self, file, args, idx, o_ofs, o_cnt, n_ofs, n_cnt):
        self.file = file
        self.start = idx
        o_ofs = int(o_ofs)
        o_end = o_ofs + int(o_cnt) - 1
        n_ofs = int(n_ofs)
        n_end = n_ofs + int(n_cnt) - 1
        self.blame = []
        self.blame.append(get_blame(args.oldrev, file, o_ofs, o_end))
        self.blame.append(get_blame(args.newrev, file, n_ofs, n_end))
        self.shas = {}

    def end(self, lines, idx):
        self.hunklines = lines[self.start:idx]
        self.blamehunklines = []
        for line in self.hunklines:
            self.blamehunklines.append(line)
            for blm in self.blame:
                for bline in blm:
                    if len(bline) and len(line):
                        binfo = blame_regex.findall(bline)[0]
                        if line.startswith('-'):
                            if line[1:] in bline:
                                self.blamehunklines[-1] = '- {} {}'.format(binfo[0], line[1:])
                                self.shas[binfo[0]] = binfo[1]
                        if line.startswith('+'):
                            if line[1:] in bline:
                                self.blamehunklines[-1] = '+ {} {}'.format(binfo[0], line[1:])
                                self.shas[binfo[0]] = binfo[1]

    def shamap(self):
        return self.shas

    def __str__(self):
        return 'file: {}'.format(self.file)

    def dump(self):
        print('\n'.join(self.blamehunklines))

def get_hunks(file, args):
    lines = get_diff(args.oldrev, args.newrev, file)
    hunks = []
    start = None
    for idx, line in enumerate(lines):
        hunkmatch = hunk_regex.findall(line)
        if hunkmatch:
            if start:
                hunks[-1].end(lines, idx)
            hunks.append(Hunk(file, args, idx, *hunkmatch[0]))
            start = idx
    if start:
        hunks[-1].end(lines, -1)
    return hunks


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-s', '--showcommits', action='store_true', default=False, help='Show commits referred in the diff')
    parser.add_argument('-n', '--newrev', default='HEAD', help='lastest revision')
    parser.add_argument('-o', '--oldrev', default='HEAD~1', help='oldest revision')
    parser.add_argument('files', action='append', help='files to be diffed')
    args = parser.parse_args()
    print('args', args)

    for file in args.files:
        hunks = get_hunks(file, args)
        shamap = {}
        for hunk in hunks:
            hunk.dump()
            shamap.update(hunk.shamap())
        if args.showcommits:
            print("Commits referred in diff")
            for sha in shamap.keys():
                print("  ", show_commit(sha))
