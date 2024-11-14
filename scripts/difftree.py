#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2024-Nov-14 22:50
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import os.path
import subprocess


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('--verbose', '-v', action='count', default=0)
    parser.add_argument('-1', dest='locuniq', action='store_true', help='show unique local files')
    parser.add_argument('-2', dest='common', action='store_true', help='show common files')
    parser.add_argument('-3', dest='remuniq', action='store_true', help='show unique remote files')
    parser.add_argument('local', help='local tree path')
    parser.add_argument('remote', help='tree tree path')

    return parser.parse_args()


class DiffFile:
    def __init__(self, abspath, relpath):
        self.abspath = abspath
        self.relpath = relpath

    def precompare(self, other):
        self.other = os.path.join(other, self.relpath)
        self.name = os.path.basename(self.abspath)

    def show(self):
        print(self)

    def compare(self):
        print(f'  Compare: {self.name}: {self.abspath} {self.other}')

    def isdiff(self):
        cmd = ['diff', '-q', self.abspath, self.other]
        cp = subprocess.run(cmd)
        return cp.returncode != 0

    def delta(self):
        cmd = ['delta', '--paging', 'always', self.abspath, self.other]
        cp = subprocess.run(cmd)
        return cp.returncode != 0

    def __str__(self):
        return f'  {self.relpath}: {self.abspath}'


class DiffTreeFolder:
    def __init__(self, args, locpath, rempath):
        self.args = args
        self.locpath = locpath
        self.rempath = rempath
        self.locchildren = {}
        self.comchildren = {}
        self.remchildren = {}
        self._build(self.locpath, self.locchildren)
        self._build(self.rempath, self.remchildren)
        self._align()

    def _build(self, top, map):
        for dirpath, _dirs, files in os.walk(top):
            for name in files:
                abspath = os.path.join(dirpath, name)
                relpath = os.path.relpath(abspath, top)
                map[relpath] = DiffFile(abspath, relpath)

    def _align(self):
        for key in list(self.locchildren.keys()):
            if key in self.remchildren.keys():
                self.comchildren[key] = self.locchildren.pop(key)
                self.comchildren[key].precompare(self.rempath)
                del self.remchildren[key]

    def compare(self):
        for key, value in self.comchildren.items():
            if self.args.verbose:
                value.compare()
            if value.isdiff():
                value.delta()

    def show(self, args):
        print(self)
        if args.locuniq:
            print('Local Files')
            for child in self.locchildren.values():
                child.show()
        if args.common:
            print('Common Files')
            for child in self.comchildren.values():
                child.show()
        if args.remuniq:
            print('Remote Files')
            for child in self.remchildren.values():
                child.show()

    def __str__(self):
        return f'{self.locpath} vs {self.rempath}'


def main():
    args = parse_arguments()
    dtree = DiffTreeFolder(args, os.path.expanduser(args.local), os.path.expanduser(args.remote))
    if args.locuniq or args.common or args.remuniq:
        dtree.show(args)
    dtree.compare()


if __name__ == '__main__':
    main()

