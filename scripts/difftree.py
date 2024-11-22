#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2024-Nov-22 13:42
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

'''
Compare two folders (local and remote file trees) and provide an overview (using options 1, 2 or 3):

1) File found only in the local folder
2) File found only in the remote folder
3) Files found in both folders

When the 1, 2, or 3 options are not provided the files found in both folders will be compare using either:
a) delta (https://github.com/dandavison/delta
b) diff
c) vimdiff provided by neovim
d) vimdiff provided by vim
'''

import argparse
import os.path
import subprocess
import enum
from colorama import Fore, Back, Style


class ToolType(enum.Enum):
    DIFF = 0
    DELTA = 1
    NEOVIM = 2
    VIMDIFF = 3


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('-1', dest='locuniq', action='store_true', help='show unique local files')
    parser.add_argument('-2', dest='remuniq', action='store_true', help='show unique remote files')
    parser.add_argument('-3', dest='common', action='store_true', help='show common files')
    parser.add_argument('-d', '--diff', action='store_true', help='Open differing files in diff')
    parser.add_argument('-e', '--edit', action='store_true', help='Open differing files in vimdiff')
    parser.add_argument('local', help='local tree path')
    parser.add_argument('remote', help='remote tree path')

    return parser.parse_args()


class FileItem:
    def __init__(self, abspath: str, relpath: str):
        self.abspath = abspath
        self.relpath = relpath
        self.name = os.path.basename(abspath)
        self.dirname = os.path.dirname(relpath)

    def show(self):
        print(self)

    def __str__(self):
        return f'  {self.name}: {self.dirname}'


class DiffFileItem(FileItem):
    def __init__(self, fileitem: FileItem, other: str, tool: ToolType):
        FileItem.__init__(self, fileitem.abspath, fileitem.relpath)
        self.other = os.path.join(other, self.relpath)
        self.tool = tool
        self._isdiff()
        if self.isdiff:
            self.locdiff = self._diffvalue(self.abspath)
            self.remdiff = self._diffvalue(self.other)

    def _isdiff(self):
        cmd = ['diff', '-aq', self.abspath, self.other]
        self.isdiff = subprocess.run(cmd, capture_output=True).returncode != 0

    def _diffvalue(self, path: str):
        try:
            with open(path, 'rt', encoding='utf-8', errors='ignore') as fobj:
                lines = fobj.readlines()
                return len(lines)
            return 0
        except FileNotFoundError:
            return -1

    def compare(self):
        match self.tool:
            case ToolType.DIFF:
                cmd = ['diff', '-au', self.abspath, self.other]
            case ToolType.DELTA:
                cmd = ['delta', '--paging', 'always', self.abspath, self.other]
            case ToolType.VIMDIFF:
                cmd = ['vimdiff', self.abspath, self.other]
            case ToolType.NEOVIM:
                cmd = ['nvim', '-d', self.abspath, self.other]

        cmdline = ' '.join(cmd)
        if self.tool == ToolType.DIFF:
            # Show a header that stands out as this will be one long output
            print(f'{Back.GREEN}{Fore.WHITE}{cmdline}{Style.RESET_ALL}')
        else:
            print(cmdline)

        cp = subprocess.run(cmd)
        return cp.returncode != 0

    def __str__(self):
        res = FileItem.__str__(self)
        if self.isdiff:
            locdiff = 'Missing' if self.locdiff == -1 else self.locdiff
            remdiff = 'Missing' if self.remdiff == -1 else self.remdiff
            res = f'  {Fore.RED}{res.strip()} - lines: {locdiff} {remdiff}{Style.RESET_ALL}'
        return res


class DiffTreeFolder:
    def __init__(self, args: argparse.Namespace, locpath: str, rempath: str):
        self.args = args
        self.locpath = locpath
        self.rempath = rempath
        self.locchildren = {}
        self.comchildren = {}
        self.remchildren = {}
        self._select_tool()
        self._build(self.locpath, self.locchildren)
        self._build(self.rempath, self.remchildren)
        self._align()

    def _build(self, top: str, map: dict):
        for dirpath, _dirs, files in os.walk(top):
            for name in files:
                abspath = os.path.join(dirpath, name)
                relpath = os.path.relpath(abspath, top)
                map[relpath] = FileItem(abspath, relpath)

    def _align(self):
        for key in list(self.locchildren.keys()):
            if key in self.remchildren.keys():
                self.comchildren[key] = DiffFileItem(self.locchildren.pop(key), self.rempath, self.tool)
                del self.remchildren[key]

    def _select_tool(self):
        self.tool = ToolType.DIFF
        if self.args.edit:
            if os.path.exists('/usr/bin/nvim') or os.path.exists('/usr/local/bin/nvim'):
                self.tool = ToolType.NEOVIM
            if os.path.exists('/usr/bin/vimdiff') or os.path.exists('/usr/local/bin/vimdiff'):
                self.tool = ToolType.VIMDIFF
        elif self.args.diff:
            pass
        else:
            if os.path.exists('/usr/bin/delta'):
                self.tool = ToolType.DELTA

    def compare(self):
        for key, value in self.comchildren.items():
            if value.isdiff:
                value.compare()

    def show(self, args: argparse.Namespace):
        if args.locuniq:
            print(f'{Back.BLUE}{Fore.WHITE}Local Files{Style.RESET_ALL}')
            for child in self.locchildren.values():
                child.show()
        if args.common:
            print(f'{Back.MAGENTA}{Fore.WHITE}Common Files{Style.RESET_ALL}')
            for child in self.comchildren.values():
                child.show()
        if args.remuniq:
            print(f'{Back.GREEN}{Fore.WHITE}Remote Files{Style.RESET_ALL}')
            for child in self.remchildren.values():
                child.show()

    def __str__(self):
        return f'{Back.BLUE}{Fore.WHITE}{self.locpath}{Style.RESET_ALL} vs {Back.GREEN}{Fore.WHITE}{self.rempath}{Style.RESET_ALL}'


def main():
    args = parse_arguments()
    dtree = DiffTreeFolder(args, os.path.expanduser(args.local), os.path.expanduser(args.remote))
    if args.locuniq or args.common or args.remuniq:
        dtree.show(args)
        return
    dtree.compare()


if __name__ == '__main__':
    main()

