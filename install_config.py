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

class UserChoice(enum.Enum):
    SkipFile = '...'
    OverWriteFile = '=>*'
    InstallFile = '==>'


class FileStatus(enum.Enum):
    Missing = ' .'
    DifferentContent = '-+'
    SameContent = '=='
    Linked = ' >'
    CorrectLink = '>>'


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
        if self.file_status == FileStatus.CorrectLink:
            self.user_choice = UserChoice.SkipFile
        else:
            if self.file_status == FileStatus.Missing:
                if self.missing_file_prompt() = 'y':
                    self.user_choice = UserChoice.InstallFile
                else:
                    self.user_choice = UserChoice.SkipFile
            else:
                if self.overwrite_existing_prompt() == 'y':
                    self.user_choice = UserChoice.OverWriteFile
                else:
                    self.user_choice = UserChoice.SkipFile

    def show_selection(self):
        print('{:2s} {:60s} {} {}'.format(self.file_status.value, os.path.relpath(self.src_path), self.user_choice.value, self.dst_path))

    def user_action(self):
        if self.user_choice == UserChoice.SkipFile:
            return
        if self.user_choice == UserChoice.OverWriteFile:
            os.remove(self.dst_path)
        dst_dir = os.path.dirname(self.dst_path)
        if not os.path.exists(dst_dir):
            os.makedirs(dst_dir)
        os.symlink(self.src_path, self.dst_path)


class File:
    def __init__(self, path, name):
        self.path = path
        self.name = name

    def get_fullpath(self):
        return os.path.join(self.path, self.name)

    def __str__(self):
        return '{}/{}'.format(self.path, self.name)


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

    def __str__(self):
        result = self.get_group()
        for installer in self.installers:
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
        relative_path = path.relative_to(*path.parts[:1])
        return os.path.join(self.destination, relative_path)

    def get_group(self):
        return '{}/ -> {}'.format(self.source, os.path.abspath(os.path.expanduser(self.destination)))


def do_installation_of(items):
    try:
        for item in items:
            print(item)
        print()
        for item in items:
            item.prepare_install()
        for item in items:
            item.show_selection()
        print()
        if Installer.go_ahead_prompt() == 'y':
            for item in items:
                item.install()
    except KeyboardInterrupt:
        print('\n\n *** Installation Aborted ***')
        sys.exit(1)


elements = [
    FileList('.',
        'bash_logout',
        'bash_profile',
        'bashrc',
        'gitconfig',
        'gitconfig.private',
        'gitignore',
        'inputrc',
        'profile',
        'vimrc',
        'tmux.conf'),
    Folder('profile.d', '~/.profile.d'),
    Folder('scripts', '~/scripts'),
    Folder('config', '~/.config'),
    Folder('PyCharm', '~/Library/Preferences/PyCharmCE2017.3'),
]


if __name__ == '__main__':
    do_installation_of(elements)

