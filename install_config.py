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
import time
try:
    from colorama import Fore, Style
except:
    pass

class FileStatus(enum.Enum):
    if 'Style' in globals():
        CorrectLink = f'{Fore.GREEN}Nothing to do{Style.RESET_ALL}'
        Missing = f'{Fore.RED}Create link{Style.RESET_ALL}'
        Linked = f'{Fore.BLUE}Delete existing link and create new link{Style.RESET_ALL}'
        SameContent = f'{Fore.GREEN}Delete existing file and create link{Style.RESET_ALL}'
        DifferentContent = f'{Fore.MAGENTA}Rename file and create link{Style.RESET_ALL}'
        Folder = f'{Fore.CYAN}Rename folder and create link{Style.RESET_ALL}'
    else:
        CorrectLink = 'Nothing to do'
        Missing = 'Create link'
        Linked = 'Delete existing link and create new link'
        SameContent = 'Delete existing file and create link'
        DifferentContent = 'Rename file and create link'
        Folder = 'Rename folder and create link'


class TermUi:
    def show(self, prompt):
        print(prompt)

    def show_arg(self, text, arg):
        print(text, arg)

    def show_kwargs(self, text, kwargs, nl=True):
        prefix = '\n' if nl else ''
        print(prefix + text.format(**kwargs))

    def show_warn(self, text):
        print('\n\n', text)

    def show_error(self, text):
        print('\n\n', text)

    def input_yn(self, prompt, nl=True):
        prefix = '\n' if nl else ''
        return input(prefix + prompt + ': (y/n) > ').lower()

    def input_arg_yn(self, prompt, arg, nl=True):
        prefix = '\n' if nl else ''
        return input(prefix + prompt + arg + ': (y/n) > ').lower()

    def input_args_yn(self, prompt, arg1, arg2, nl=True):
        prefix = '\n' if nl else ''
        return input(prefix + prompt + arg1 + '/' + arg2 + ': (y/n) > ').lower()


class ColorTermUi(TermUi):
    def show(self, prompt):
        print(prompt)

    def show_arg(self, text, arg):
        print(f'{text}{Fore.CYAN}{arg}{Style.RESET_ALL}')

    def show_kwargs(self, text, kwargs, nl=True):
        prefix = '\n' if nl else ''
        print(prefix + text.format(**kwargs))

    def show_warn(self, text):
        print(f'\n\n{Fore.BLUE}{text}{Style.RESET_ALL}')

    def show_error(self, text):
        print(f'\n\n{Fore.RED}{text}{Style.RESET_ALL}')

    def input_yn(self, prompt, nl=True):
        prefix = '\n' if nl else ''
        return input(f'{prefix}{Fore.MAGENTA}{prompt}{Style.RESET_ALL}: (y/n) > ').lower()

    def input_arg_yn(self, prompt, arg, nl=True):
        prefix = '\n' if nl else ''
        return input(f'{prefix}{prompt}{Fore.BLUE}{arg}{Style.RESET_ALL}: (y/n) > ').lower()

    def input_args_yn(self, prompt, arg1, arg2, nl=True):
        prefix = '\n' if nl else ''
        return input(f'{prefix}{prompt}{Fore.GREEN}{arg1}/{arg2}{Style.RESET_ALL}: (y/n) > ').lower()


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

    def create_dst_backup(self, tui):
        newname = self.dst_path + time.strftime('.backup_%Y_%b_%d_%H_%M_%S')
        os.rename(self.dst_path, newname)
        tui.show_arg(f'  Backup as ', newname)

    def run(self, tui):
        tui.show_kwargs('  {status}:  {src} => {dst}', {
            'status': self.file_status.value,
            'src': self.src_path,
            'dst': self.dst_path}, False)
        if self.file_status == FileStatus.CorrectLink:
            return
        if self.file_status == FileStatus.Missing:
            if not os.path.exists(os.path.dirname(self.dst_path)):
                os.makedirs(os.path.dirname(self.dst_path), exist_ok=True)
            os.symlink(self.src_path, self.dst_path)
        if self.file_status == FileStatus.Linked:
            os.remove(self.dst_path)
            os.symlink(self.src_path, self.dst_path)
        if self.file_status == FileStatus.SameContent:
            os.remove(self.dst_path)
            os.symlink(self.src_path, self.dst_path)
        if self.file_status == FileStatus.DifferentContent:
            self.create_dst_backup(tui)
            os.symlink(self.src_path, self.dst_path)
        if self.file_status == FileStatus.Folder:
            self.create_dst_backup(tui)
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
            tui.show('\n')
            for value in self.value:
                tui.show('  *   {}'.format(value))
            if tui.input_args_yn('    Do you want to install ', self.parent, self.name, True) == 'y':
                for val in self.value:
                    self.installers.append(Installer(destination, dot, val))

    def add_installer(self, destination, dot):
        for item in self.value:
            self.installers.append(Installer(destination, dot, item))

    def show(self, tui):
        tui.show('    {}/{}:'.format(self.parent, self.name))
        for value in self.value:
            tui.show('      {}'.format(value))

    def install(self, tui):
        if len(self.installers):
            for installer in self.installers:
                installer.run(tui)

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

    def query_user(self, tui):
        tui.show_arg('\n * ', self.name)
        if self.default:
            self.default.show(tui)
        for value in self.variants.values():
            value.show(tui)
        if tui.input_arg_yn('  Do you want to install ', self.name) == 'y':
            if self.default:
                self.default.add_installer(self.destination, self.dot)
            for var in self.variants.values():
                var.query_user(self.destination, self.dot)
            return True
        return False

    def install(self, tui):
        if self.default:
            self.default.install(tui)
        for value in self.variants.values():
            value.install(tui)

    def installation_needed(self):
        result = False
        if self.default:
            result = result or self.default.installation_needed()
        for value in self.variants.values():
            result = result or value.installation_needed()
        return result


def install_items(tui):
    features = []
    with open('install.yaml', 'r') as stream:
        try:
            docs = yaml.safe_load_all(stream)
        except yaml.YAMLError as exc:
            tui.show_error(exc)
            sys.exit(1)
        for doc in docs:
            for key, value in doc.items():
                features.append(Feature(key, value))
            break
    for f in features:
        f.query_user(tui)
    changes = False
    for f in features:
        changes = changes or f.installation_needed()
    if changes:
        response = ''
        while response != 'n' and response != 'y':
            response = tui.input_yn('Begin installation')
            if response == 'y':
                for f in features:
                    f.install(tui)


if __name__ == '__main__':
    tui = ColorTermUi() if 'Style' in globals() else TermUi()
    try:
        install_items(tui)
    except KeyboardInterrupt:
        tui.show_error('*** Installation Aborted ***')
        sys.exit(1)
    except FileNotFoundError as exc:
        tui.show_warn(f'File not found: {exc}')
        tui.show_error('*** Installation Aborted ***')
        sys.exit(1)

