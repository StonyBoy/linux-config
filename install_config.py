#! /usr/bin/env python3
'''
Install links

Installation:
    pip3 install --user colorama
    pip3 install --user PyYAML
'''
import os
import sys
import enum
import subprocess
import yaml
from colorama import Fore, Back, Style
import time


class FileStatus(enum.Enum):
    CorrectLink = f'{Fore.GREEN}Nothing to do{Style.RESET_ALL}'
    Missing = f'{Fore.RED}Create link{Style.RESET_ALL}'
    Linked = f'{Fore.BLUE}Delete existing link and create new link{Style.RESET_ALL}'
    SameContent = f'{Fore.GREEN}Delete existing file and create link{Style.RESET_ALL}'
    DifferentContent = f'{Fore.MAGENTA}Rename file and create link{Style.RESET_ALL}'
    Folder = f'{Fore.CYAN}Rename folder and create link{Style.RESET_ALL}'


class Installer:
    def __init__(self, dst_path, dot, src_path):
        self.dst_path = str(os.path.abspath(os.path.expanduser(dst_path)))
        self.dot = '.' if dot else ''
        self.src_path = os.path.abspath(src_path)
        self.file_status = FileStatus.Missing
        if os.path.isfile(self.src_path):
            if os.path.isdir(self.dst_path):
                self.dst_path = os.path.join(self.dst_path, self.dot + src_path)
            self.get_file_status()
        elif os.path.isdir(self.src_path):
            self.dst_path = os.path.join(self.dst_path, self.dot + src_path)
            self.get_dir_status()
        else:
            raise FileNotFoundError(self.src_path)

    def get_file_status(self):
        if os.path.exists(self.dst_path):
            if os.path.islink(self.dst_path):
                if os.readlink(self.dst_path) == self.src_path:
                    self.file_status = FileStatus.CorrectLink
                else:
                    self.file_status = FileStatus.Linked
            else:
                if self.compare_contents():
                    self.file_status = FileStatus.SameContent
                else:
                    self.file_status = FileStatus.DifferentContent
        else:
            if os.path.islink(self.dst_path):
                self.file_status = FileStatus.Linked

    def get_dir_status(self):
        if os.path.exists(self.dst_path):
            if os.path.islink(self.dst_path):
                if os.readlink(self.dst_path) == self.src_path:
                    self.file_status = FileStatus.CorrectLink
                else:
                    self.file_status = FileStatus.Linked
            else:
                self.file_status = FileStatus.Folder

    def compare_contents(self):
        return subprocess.run(['diff', '-q', '-a', self.dst_path, self.src_path], stdout=subprocess.PIPE).returncode == 0

    def create_dst_backup(self):
        newname = self.dst_path + time.strftime('.backup_%Y_%b_%d_%H_%M_%S')
        os.rename(self.dst_path, newname)
        print(f'  Backup as {newname}')

    def run(self):
        print(f'{self.file_status.value}:  {self.src_path} => {self.dst_path}')
        if self.file_status == FileStatus.CorrectLink:
            return
        if self.file_status == FileStatus.Missing:
            if not os.path.exists(os.path.dirname(self.dst_path)):
                os.makedirs(os.path.dirname(self.dst_path), exist_ok=True)
            os.remove(self.dst_path)
            os.symlink(self.src_path, self.dst_path)
        if self.file_status == FileStatus.Linked:
            os.remove(self.dst_path)
            os.symlink(self.src_path, self.dst_path)
        if self.file_status == FileStatus.SameContent:
            os.remove(self.dst_path)
            os.symlink(self.src_path, self.dst_path)
        if self.file_status == FileStatus.DifferentContent:
            self.create_dst_backup()
            os.symlink(self.src_path, self.dst_path)
        if self.file_status == FileStatus.Folder:
            self.create_dst_backup()
            os.symlink(self.src_path, self.dst_path)


class FeatureVariant:
    def __init__(self, parent, name, value):
        self.parent = parent
        self.name = name
        self.value = value
        self.installers = []

    def query_user(self, destination, dot):
        if self.name.lower() == 'default':
            for val in self.value:
                self.installers.append(Installer(destination, dot, val))
        else:
            self.show()
            prompt = f'    Do you want to install {Fore.GREEN}{self.parent}/{self.name}{Style.RESET_ALL}: (N/y) > '
            if input(prompt).lower() == 'y':
                for val in self.value:
                    self.installers.append(Installer(destination, dot, val))

    def add_installer(self, destination, dot):
        for item in self.value:
            self.installers.append(Installer(destination, dot, item))

    def __str__(self):
        result = '\n    {}/{}:'.format(self.parent, self.name)
        for value in self.value:
            result += '\n      {}'.format(value)
        return result

    def show(self):
        print(self)

    def install(self):
        if len(self.installers):
            for installer in self.installers:
                installer.run()

    def installation_needed(self):
        return len(self.installers) > 0


class Feature:
    def __init__(self, name, value):
        self.name = name
        self.default = None
        self.dot = False
        self.destination = None
        self.variants = {}
        for key, val in value.items():
            if key == 'default':
                self.default = FeatureVariant(name, key, val)
            elif key == 'dot':
                self.dot = val
            elif key == 'dest':
                self.destination = val
            elif len(key):
                self.variants[key] = FeatureVariant(name, key, val)

    def __str__(self):
        result = f'\n* {Fore.BLUE}{self.name}{Style.RESET_ALL}:'
        if self.default:
            result += str(self.default)
        for value in self.variants.values():
            result += str(value)
        return result

    def show(self):
        print(self)

    def query_user(self):
        self.show()
        prompt = f'  Do you want to install {Fore.BLUE}{self.name}{Style.RESET_ALL}: (N/y) > '
        if input(prompt).lower() == 'y':
            if self.default:
                self.default.add_installer(self.destination, self.dot)
            for var in self.variants.values():
                var.query_user(self.destination, self.dot)
            return True
        return False

    def install(self):
        if self.default:
            self.default.install()
        for value in self.variants.values():
            value.install()

    def installation_needed(self):
        result = False
        if self.default:
            result = result or self.default.installation_needed()
        for value in self.variants.values():
            result = result or value.installation_needed()
        return result


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
                features.append(Feature(key, value))
            break
    for f in features:
        f.query_user()
    changes = False
    for f in features:
        changes = changes or f.installation_needed()
    if changes:
        prompt = f'\n{Fore.MAGENTA}Begin installation{Style.RESET_ALL}: (y/n) > '
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

