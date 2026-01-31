#!/usr/local/pyvenv/steen/bin/python3
'''
Install configuration for a Linux/Unix environment

Installation:
    source /usr/local/pyvenv/steen/bin/activate
    pip install -r requirements.txt
    deactivate
'''
import os
import sys
import enum
import subprocess
import yaml
from colorama import Fore, Style
import time

global root
root = '~/'


class FileStatus(enum.Enum):
    CorrectLink = f'{Fore.GREEN}Nothing to do{Style.RESET_ALL}'
    Missing = f'{Fore.RED}Create link{Style.RESET_ALL}'
    Linked = f'{Fore.BLUE}Delete existing link and create new link{Style.RESET_ALL}'
    SameContent = f'{Fore.GREEN}Delete existing file and create link{Style.RESET_ALL}'
    DifferentContent = f'{Fore.MAGENTA}Rename file and create link{Style.RESET_ALL}'
    Folder = f'{Fore.CYAN}Rename folder and create link{Style.RESET_ALL}'


class Installer:
    def __init__(self, src, dot, dst, level):
        self.srcpath = os.path.abspath(src)
        self.dot = '.' if dot else ''
        dstroot = os.path.abspath(os.path.expanduser(root))
        if dst:
            self.dstpath = os.path.join(dstroot, self.dot + dst)
        else:
            self.dstpath = os.path.join(dstroot, self.dot + src)
        self.level = level
        if os.path.exists(self.dstpath):
            if os.path.islink(self.dstpath):
                if os.readlink(self.dstpath) == self.srcpath:
                    self.file_status = FileStatus.CorrectLink
                else:
                    self.file_status = FileStatus.Linked
            else:
                if self.compare_contents():
                    self.file_status = FileStatus.SameContent
                else:
                    self.file_status = FileStatus.DifferentContent
        else:
            if os.path.islink(self.dstpath):
                self.file_status = FileStatus.Linked
            else:
                self.file_status = FileStatus.Missing

    def compare_contents(self):
        return subprocess.run(['diff', '-q', '-a', self.dstpath, self.srcpath], stdout=subprocess.PIPE).returncode == 0

    def create_dst_backup(self):
        newname = self.dstpath + time.strftime('.backup_%Y_%b_%d_%H_%M_%S')
        os.rename(self.dstpath, newname)
        print(f'  Backup as {newname}')

    def execute(self):
        indent = '  ' * (self.level + 1)
        print(f'{indent}{self.file_status.value}:  {self.srcpath} => {self.dstpath}')
        if self.file_status == FileStatus.Missing:
            newdir = os.path.dirname(self.dstpath)
            if not os.path.exists(newdir):
                os.makedirs(newdir, exist_ok=True)
            if os.path.exists(self.dstpath):
                os.remove(self.dstpath)
            os.symlink(self.srcpath, self.dstpath)
        elif self.file_status == FileStatus.CorrectLink:
            return
        elif self.file_status == FileStatus.Linked:
            os.remove(self.dstpath)
            os.symlink(self.srcpath, self.dstpath)
        elif self.file_status == FileStatus.SameContent:
            os.remove(self.dstpath)
            os.symlink(self.srcpath, self.dstpath)
        elif self.file_status == FileStatus.DifferentContent:
            self.create_dst_backup()
            os.symlink(self.srcpath, self.dstpath)
        elif self.file_status == FileStatus.Folder:
            self.create_dst_backup()
            os.symlink(self.srcpath, self.dstpath)


class InstallBase:
    def __init__(self, parent, level, name):
        self.parent = parent
        self.level = level
        self.name = name
        self.destination = None
        self.dot = True
        self.do_install = False
        self.children = []
        self.do_clear = 'cls' if os.name == 'nt' else 'clear'

    def clear(self):
        os.system(self.do_clear)

    def query_user(self):
        if self.name == 'default':
            self.do_install = True
            return self.do_install
        self.clear()
        self.show()
        indent = '  ' * self.level
        prompt = f'{indent}{Style.BRIGHT}Do you want to install {Fore.BLUE}{self.name}{Style.RESET_ALL}: (N/y) > '
        if input(prompt).lower() == 'y':
            self.do_install = True
        return self.do_install

    def installation_needed(self):
        return self.do_install

    def append(self, child):
        self.children.append(child)

    def show(self):
        pass


class InstallGroup(InstallBase):
    def __init__(self, parent, level, name, value):
        super().__init__(parent, level, name)
        self.src = value['src']
        if 'dest' in value:
            self.destination = value['dest']
        else:
            self.destination = self.get_destination()
        if 'dot' in value:
            self.dot = value['dot']
        else:
            self.dot = self.get_dot()

    def install(self):
        if self.do_install:
            indent = '  ' * self.level
            print(f'{indent}Installing {Fore.BLUE}{self.name}{Style.RESET_ALL}')
            for name in self.src:
                inst = Installer(name, self.dot, self.destination, self.level + 1)
                inst.execute()

    def get_destination(self):
        try:
            return self.parent.get_destination()
        except AttributeError:
            pass
        return None

    def get_dot(self):
        try:
            return self.parent.get_dot()
        except AttributeError:
            pass
        return True

    def show(self):
        indent = '  ' * self.level
        cindent = '  ' * (self.level + 1)
        print(f'{indent}{Fore.MAGENTA}{self.name}{Style.RESET_ALL}:')
        for name in self.src:
            print(f'{cindent}{Style.DIM}{name}{Style.RESET_ALL}')

    def __str__(self):
        return f'InstallItem: {self.name}: {self.src}'


class Feature(InstallBase):
    def __init__(self, parent, level, name, value):
        super().__init__(parent, level, name)
        if 'dest' in value:
            self.destination = value['dest']
        if 'dot' in value:
            self.dot = value['dot']
        if self.level > 1:
            self.indent = '  ' * self.level
        else:
            self.indent = f'{Fore.BLUE}*{Style.RESET_ALL} '

    def query_user(self):
        if super().query_user():
            for child in self.children:
                child.query_user()
        return self.do_install

    def installation_needed(self):
        result = super().installation_needed()
        for child in self.children:
            result = result or child.installation_needed()
        return result

    def install(self):
        if self.do_install:
            print(f'{self.indent}Installing {Fore.BLUE}{self.name}{Style.RESET_ALL}')
            for child in self.children:
                child.install()

    def get_destination(self):
        if self.destination:
            return self.destination
        if self.parent:
            try:
                return self.parent.get_destination()
            except AttributeError:
                pass
        return None

    def get_dot(self):
        if self.destination:
            return self.dot
        if self.parent:
            try:
                return self.parent.get_dot()
            except AttributeError:
                pass
        return True

    def show(self):
        print(f'{self.indent}{Fore.BLUE}{self.name}{Style.RESET_ALL}:')
        for child in self.children:
            child.show()

    def __str__(self):
        return f'Feature: {self.name}: {[str(child) for child in self.children]}'


def add_feature(parent, name, value, level):
    # print('YAML Error', f'name: "{name}"', yaml.dump(value, allow_unicode=True, default_flow_style=False))
    if 'src' in value:
        ft = InstallGroup(parent, level, name, value)
        parent.append(ft)
    else:
        ft = Feature(parent, level, name, value)
        parent.append(ft)
        if isinstance(value, dict):
            for ckey, cval in value.items():
                if ckey == 'dest':
                    # ignore
                    pass
                else:
                    add_feature(ft, ckey, cval, level + 1)


def setup_test(features):
    features[0].do_install = True
    features[0].children[0].do_install = True
    features[1].do_install = True
    features[2].do_install = True
    features[2].children[1].do_install = True
    features[4].do_install = True
    features[4].children[2].do_install = True
    features[4].children[2].children[1].do_install = True
    features[6].do_install = True
    features[6].children[1].do_install = True
    features[6].children[1].children[2].do_install = True
    for f in features:
        f.install()
    sys.exit(0)


def install_items():
    features = []
    with open('install.yaml', 'r') as stream:
        try:
            docs = yaml.safe_load_all(stream)
        except yaml.YAMLError as exc:
            print(exc)
            sys.exit(-1)
        for doc in docs:
            for key, value in doc.items():
                add_feature(features, key, value, 1)
            break
    for f in features:
        f.query_user()
    # setup_test(features)
    changes = False
    for f in features:
        changes = changes or f.installation_needed()
    if changes:
        prompt = f'{Fore.GREEN}Begin installation{Style.RESET_ALL}: (y/n) > '
        response = ''
        while response != 'n' and response != 'y':
            response = input(prompt).lower()
            if response == 'y':
                for f in features:
                    f.install()


if __name__ == '__main__':
    try:
        install_items()
    except KeyboardInterrupt:
        print(f'\n\n{Fore.RED}*** Installation Aborted ***{Style.RESET_ALL}')
        sys.exit(1)
    except FileNotFoundError as exc:
        print(f'\n\n{Fore.RED}*** Installation Aborted ***{Style.RESET_ALL}')
        print(f'File not found: {exc}')
        sys.exit(1)

