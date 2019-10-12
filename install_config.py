#! /usr/bin/env python3
'''
Install links
'''
import os
import sys
import readline
import shutil
import enum
import subprocess
import pathlib
import yaml


class UserChoice(enum.Enum):
    SkipFile = '...'
    OverWriteFile = '=>*'
    InstallFile = '==>'


class FileStatus(enum.Enum):
    Hidden = '##'
    Missing = ' .'
    DifferentContent = '-+'
    SameContent = '=='
    Linked = ' >'
    OtherLink = ' ~'
    CorrectLink = 'OK'


class Installer:
    def __init__(self, src_path, dst_path):
        self.src_path = os.path.abspath(os.path.expanduser(src_path))
        self.dst_path = os.path.abspath(os.path.expanduser(dst_path))
        self.user_choice = UserChoice.InstallFile
        self.file_status = FileStatus.Missing
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

    def status(self):
        return '{:2s} {:60s} : {}'.format(self.file_status.value, os.path.relpath(self.src_path), self.dst_path)

    def compare_contents(self):
        return subprocess.run(['diff', '-q', '-a', self.dst_path, self.src_path], stdout=subprocess.PIPE).returncode == 0

    def missing_file_prompt(self):
        prompt = 'File is missing, Do you want to install {}: (N/y) > '.format(self.dst_path)
        response = input(prompt)
        return response.lower()

    def overwrite_existing_prompt(self):
        if self.file_status == FileStatus.Linked:
            prompt = '{} is linked to another file, Do you want to replace the link: (N/y) > '.format(self.dst_path)
        elif self.file_status == FileStatus.SameContent:
            prompt = '{} already exists with the same content - Do you want to replace it with a link: (N/y) > '.format(self.dst_path)
        else:
            prompt = '{} already exists - Do you want to replace it: (N/y) > '.format(self.dst_path)
        response = input(prompt)
        return response.lower()

    @staticmethod
    def go_ahead_prompt():
        prompt = 'Do you want to continue: (N/y) > '
        response = input(prompt)
        return response.lower()

    def user_selection(self):
        if self.file_status == FileStatus.CorrectLink or self.file_status == FileStatus.Hidden:
            self.user_choice = UserChoice.SkipFile
        else:
            if self.file_status == FileStatus.Missing:
                if self.missing_file_prompt() == 'y':
                    self.user_choice = UserChoice.InstallFile
                else:
                    self.user_choice = UserChoice.SkipFile
            else:
                if self.overwrite_existing_prompt() == 'y':
                    self.user_choice = UserChoice.OverWriteFile
                else:
                    self.user_choice = UserChoice.SkipFile

    def show_selection(self):
        if not self.hidden():
            print('{:2s} {:60s} {} {}'.format(self.file_status.value, os.path.relpath(self.src_path), self.user_choice.value, self.dst_path))

    def user_action(self):
        if self.file_status == FileStatus.Hidden:
            return
        if self.user_choice == UserChoice.SkipFile:
            return
        if self.user_choice == UserChoice.OverWriteFile:
            os.remove(self.dst_path)
        dst_dir = os.path.dirname(self.dst_path)
        if not os.path.exists(dst_dir):
            os.makedirs(dst_dir)
        try:
            os.symlink(self.src_path, self.dst_path)
        except FileExistsError:
            pass

    def wants_installation(self):
        return self.file_status != FileStatus.Hidden and (self.user_choice == UserChoice.OverWriteFile or self.user_choice == UserChoice.InstallFile)

    def hide(self):
        self.file_status = FileStatus.Hidden

    def hidden(self):
        return self.file_status == FileStatus.Hidden


class SelectionInstaller(Installer):
    def __init__(self, src_path, dst_path, selected_link):
        super().__init__(src_path, dst_path)
        self.selected_link = self.src_path
        if selected_link:
            self.selected_link = os.path.abspath(os.path.expanduser(selected_link))
            if os.path.exists(self.dst_path):
                if os.path.islink(self.dst_path):
                    if os.readlink(self.dst_path) == self.selected_link:
                        self.file_status = FileStatus.CorrectLink
                    else:
                        self.file_status = FileStatus.OtherLink
                else:
                    if self.compare_contents():
                        self.file_status = FileStatus.SameContent
                    else:
                        self.file_status = FileStatus.DifferentContent
            else:
                if os.path.islink(self.dst_path):
                    self.file_status = FileStatus.Linked

    def missing_file_prompt(self):
        prompt = 'File {} is missing, Do you want to install {}: (N/y) > '.format(
                os.path.basename(self.dst_path), self.src_path)
        response = input(prompt)
        return response.lower()

    def overwrite_existing_prompt(self):
        if self.file_status == FileStatus.Linked:
            prompt = '{} is linked to {}, Do you want to replace the link: (N/y) > '.format(self.dst_path, self.selected_link)
        elif self.file_status == FileStatus.OtherLink:
            prompt = '{} is linked to {}, Do you want to replace the link with {}: (N/y) > '.format(self.dst_path, pathlib.Path(self.dst_path).resolve(), self.src_path)
        elif self.file_status == FileStatus.SameContent:
            prompt = '{} already exists with the same content - Do you want to replace it with a link: (N/y) > '.format(self.dst_path)
        else:
            prompt = '{} already exists - Do you want to replace it: (N/y) > '.format(self.dst_path)
        response = input(prompt)
        return response.lower()


class File:
    def __init__(self, path, name):
        self.path = path
        self.name = name

    def get_fullpath(self):
        return os.path.join(self.path, self.name)

    def __str__(self):
        return '{}/{}'.format(self.path, self.name)


class FullFile(File):
    def __init__(self, pathname):
        self.path, self.name = os.path.split(pathname)


class Group:
    def __init__(self, src, dst, dotname):
        self.source = src
        self.destination = dst
        self.dot_rename_dst = dotname
        self.elements = []
        self.installers = []

    def create_installers(self):
        for item in self.elements:
            self.installers.append(Installer(item.get_fullpath(), self.get_destination(item)))

    def get_destination(self, item):
        pass

    def prepare_install(self):
        for installer in self.installers:
            installer.user_selection()

    def show_selection(self):
        for installer in self.installers:
            installer.show_selection()

    def install(self):
        for installer in self.installers:
            installer.user_action()

    def get_group(self):
        pass

    def wants_installation(self):
        result = False
        for installer in self.installers:
            result = result or installer.wants_installation()
        return result

    def __iter__(self):
        for installer in self.installers:
            yield installer

    def __str__(self):
        result = self.get_group()
        for installer in self.installers:
            if not installer.hidden():
                result += '\n    ' + installer.status()
        return result


class FileList(Group):
    def __init__(self, src, *files, dst='~', dotname=True):
        super().__init__(src, dst, dotname)
        for file in files:
            self.elements.append(File(src, file))
        self.create_installers()

    def get_destination(self, item):
        return os.path.join(self.destination, '.' + item.name if self.dot_rename_dst else item.name)

    def get_group(self):
        return '{}/ -> {}'.format(self.source, os.path.abspath(os.path.expanduser(self.destination)))


class Folder(Group):
    def __init__(self, src, dst):
        super().__init__(src, dst, False)
        for root, folders, files in os.walk(src):
            for file in files:
                self.elements.append(File(root, file))
        self.create_installers()

    def get_destination(self, item):
        path = pathlib.Path(item.get_fullpath())
        relative_path = str(path.relative_to(*path.parts[:1]))
        return os.path.join(self.destination, relative_path)

    def get_group(self):
        return '{}/ -> {}'.format(self.source, os.path.abspath(os.path.expanduser(self.destination)))


class SelectionFolder(Folder):
    # Choose between alternative versions of the same file in a folder
    def __init__(self, src, dst, choices):
        self.choices = choices
        super().__init__(src, dst)

    def create_installers(self):
        for item in self.elements:
            dst_path = self.get_destination(item)
            selected_link = None
            for key, value in self.choices.items():
                if key == item.get_fullpath():
                    dst_path = self.get_destination(FullFile(value))
                    selected_link = key
            self.installers.append(SelectionInstaller(item.get_fullpath(),
                dst_path, selected_link))


def filter_items(items, args):
    def hide_this(item, options):
        if options.nolinked and item.file_status == FileStatus.Linked:
            return True
        if options.nomissing and item.file_status == FileStatus.Missing:
            return True
        if options.nook and item.file_status == FileStatus.CorrectLink:
            return True
        return False
    for group in items:
        for installer in group:
            if hide_this(installer, args):
                installer.hide()


def do_installation_of(items, args):
    filter_items(items, args)
    try:
        for item in items:
            print(item)
        print()
        for legend in FileStatus:
            print('  {} means {}'.format(legend.value, legend.name))
        print()
        for item in items:
            item.prepare_install()
        installation_needed = False
        for item in items:
            installation_needed = installation_needed or item.wants_installation()
        if installation_needed:
            for item in items:
                item.show_selection()
            print()
            if Installer.go_ahead_prompt() == 'y':
                for item in items:
                    item.install()
    except KeyboardInterrupt:
        print('\n\n *** Installation Aborted ***')
        sys.exit(1)



class FeatureChoice:
    def __init__(self, name, value):
        self.name = name
        self.value = value

    def __str__(self):
        result = '{}: {}\n'.format(self.name, self.value)
        return result


class Feature:
    def __init__(self, name, value):
        self.name = name
        self.default = None
        self.dot = False
        self.destination = None
        self.choices = {}
        for key, val in value.items():
            if key == 'default':
                self.default = FeatureChoice(key, val)
            elif key == 'dot':
                self.dot = val
            elif key == 'dest':
                self.destination = val
            elif len(key):
                self.choices[key] = FeatureChoice(key, val)

    def __str__(self):
        result = '{}:\n'.format(self.name)
        result += '  {}\n'.format(self.default)
        for value in self.choices.values():
            result += '  {}\n'.format(value)
        return result


if __name__ == '__main__':
    features = []
    with open('install.yaml', 'r') as stream:
        try:
            conf = yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)
            sys.exit(-1)
        for key, value in conf.items():
            features.append(Feature(key, value))
    for f in features:
        print(f)


