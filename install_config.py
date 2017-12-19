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


class Installer:
    def __init__(self, src_path, dst_path):
        self.src_path = src_path
        self.dst_path = dst_path
        self.user_choice = UserChoice.InstallFile

    def exists(self):
        return os.path.exists(self.src_path)

    def overwrite_existing_prompt(self):
        prompt = '{} already exists - Do your want to overwrite it: (N/y) > '.format(self.src_path)
        response = input(prompt)
        return response.lower()

    def install_prompt(self):
        prompt = 'Do your want to install {}: (Y/n) > '.format(self.src_path)
        response = input(prompt)
        return response.lower()

    def user_action(self):
        if self.exists():
            if self.overwrite_existing_prompt() == 'y':
                self.user_choice = UserChoice.OverWriteFile
            else:
                print('Skipping: {}'.format(self.src_path))
                self.user_choice = UserChoice.SkipFile
        elif self.install_prompt() == 'y':
            self.user_choice = UserChoice.InstallFile
        else:
            self.user_choice = UserChoice.SkipFile

    def show_action(self):
        print('{} {}'.format(self.src_path, self.user_choice.value))


class FileLink(Installer):
    def install(self):
        if self.user_choice == UserChoice.SkipFile:
            return
        if self.user_choice == UserChoice.OverWriteFile:
            os.remove(self.installed_path)
        os.symlink(self.source_path, self.installed_path)

    def __str__(self):
        return '{}{} : {}'.format(self.prefix, self.installed_name, self.installed_path)


class File:
    def __init__(self, path, name):
        self.path = path
        self.name = name

    def get_fullpath(self):
        return os.path.join(self.path, self.name)

    def __str__(self):
        return '{}/{}'.format(self.path, self.name)


class Folder:
    def __init__(self, name):
        self.name = name
        self.elements = []
        self.destination = None
        self.destination_name = name
        for root, folders, files in os.walk(name):
            for file in files:
                self.elements.append(File(root, file))

    def set_name(self, name):
        self.destination_name = '.' + self.name if name == '.' else name

    def set_destination(self, path):
        self.destination = os.path.join(os.path.expanduser(path), self.destination_name)

    def __str__(self):
        result = '{}/ -> {}'.format(self.name, self.destination)
        for elem in self.elements:
            result += '\n' + str(elem)
        return result


class FileList:
    def __init__(self, name, *files):
        self.name = name
        self.elements = []
        self.destination = None
        self.destination_name = name
        self.dot_rename_files = False
        self.installers = []
        for file in files:
            self.elements.append(File(name, file))

    def set_name(self, name):
        self.destination_name = '.' + self.name if name == '.' else name

    def set_destination(self, path):
        self.destination = os.path.join(os.path.expanduser(path), self.destination_name)

    def dot_named_files(self):
        self.dot_rename_files = True

    def prepare_install(self):
        if self.dot_rename_files:
            for item in self.elements:
                self.installers.append(Installer(item.get_fullpath(), os.path.join(self.destination, '.' + item.name)))
        else:
            for item in self.elements:
                self.installers.append(Installer(item.get_fullpath(), os.path.join(self.destination, item.name)))

    def __str__(self):
        result = '{}/ -> {}'.format(self.name, self.destination)
        if self.dot_rename_files:
            for elem in self.elements:
                result += '\n{} -> {}/.{}'.format(elem, elem.path, elem.name)
        else:
            for elem in self.elements:
                result += '\n{}'.format(elem)
        return result


elements = [
    FileList(os.getcwd(),
        'bash_logout',
        'bash_profile',
        'bashrc',
        'gitconfig',
        'gitignore',
        'inputrc',
        'profile',
        'vimrc',
        'Xdefaults'
        'Xmodmap',
        'tmux.conf'),
    Folder('profile.d'),
    Folder('scripts'),
    Folder('config'),
]

if __name__ == '__main__':
    for item in elements[0:1]:
        item.dot_named_files()
    for item in elements[1:]:
        item.set_name('.')
        item.set_destination('~')
    for item in elements:
        print(item)
    # for elem in elements:
    #     elem.install()


