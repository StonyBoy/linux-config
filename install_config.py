'''
Install links
'''
import os
import sys
import readline
import shutil
import enum



class UserChoice(enum.Enum):
    SkipFile = '.X.'
    OverWriteFile = '=>*'
    InstallFile = '==>'
    SameFile = '==='


class Installer:
    def __init__(self, src_path, dst_path):
        self.src_path = os.path.abspath(os.path.expanduser(src_path))
        self.dst_path = os.path.abspath(os.path.expanduser(dst_path))
        self.user_choice = UserChoice.InstallFile

    def exists(self):
        return os.path.exists(self.dst_path)

    def is_same(self):
        return os.path.exists(self.dst_path) and os.path.islink(self.dst_path) and os.readlink(self.dst_path) == self.src_path

    def overwrite_existing_prompt(self):
        prompt = '{} already exists - Do you want to overwrite it: (N/y) > '.format(self.dst_path)
        response = input(prompt)
        return response.lower()

    def install_prompt(self):
        prompt = 'Do you want to install {}: (Y/n) > '.format(self.dst_path)
        response = input(prompt)
        return response.lower()

    @staticmethod
    def go_ahead_prompt():
        prompt = 'Do you want to continue: (Y/n) > '
        response = input(prompt)
        return response.lower()

    def user_selection(self):
        if self.is_same():
            print('Already: {}'.format(self.src_path))
            self.user_choice = UserChoice.SameFile
        elif self.exists():
            if self.overwrite_existing_prompt() == 'y':
                self.user_choice = UserChoice.OverWriteFile
            else:
                print('Skipping: {}'.format(self.src_path))
                self.user_choice = UserChoice.SkipFile
        elif self.install_prompt() == 'y':
            self.user_choice = UserChoice.InstallFile
        else:
            self.user_choice = UserChoice.SkipFile

    def show_selection(self):
        print('{:40s} {} {}'.format(os.path.basename(self.src_path), self.user_choice.value, self.dst_path))

    def user_action(self):
        if self.user_choice == UserChoice.SkipFile or self.user_choice == UserChoice.SameFile:
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

    def get_destination(self, item):
        pass

    def prepare_install(self):
        for item in self.elements:
            installer = Installer(item.get_fullpath(), self.get_destination(item))
            installer.user_selection()
            self.installers.append(installer)

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
        for item in self.elements:
            result += '\n    {:40s} -> {}'.format(item.name, self.get_destination(item))
        return result


class FileList(Group):
    def __init__(self, src, *files, dst='~', dotname=True):
        super().__init__(src, dst, dotname)
        for file in files:
            self.elements.append(File(src, file))

    def get_destination(self, item):
        return os.path.join(self.destination, '.' + item.name if self.dot_rename_dst else item.name)

    def get_group(self):
        return '{}/ -> {}'.format(self.source, os.path.abspath(os.path.expanduser(self.destination)))


class Folder(Group):
    def __init__(self, src, dst='~', dotname=True):
        super().__init__(src, dst, dotname)
        for root, folders, files in os.walk(src):
            for file in files:
                self.elements.append(File(root, file))

    def get_destination(self, item):
        return os.path.join(self.destination, '.' + item.get_fullpath() if self.dot_rename_dst else item.get_fullpath())

    def get_group(self):
        return '{}/ -> {}'.format(self.source, os.path.abspath(os.path.expanduser(self.destination)))


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
        'Xdefaults',
        'Xmodmap',
        'tmux.conf'),
    Folder('profile.d'),
    Folder('scripts'),
    Folder('config'),
]

if __name__ == '__main__':
    for item in elements:
        print(item)
    for elem in elements:
        elem.prepare_install()
    for elem in elements:
        elem.show_selection()
    if Installer.go_ahead_prompt() == 'y':
        for elem in elements:
            elem.install()


