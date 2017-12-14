'''
Install links
'''
import os
import sys
import readline
import shutil
import enum

class UserChoice(enum.Enum):
    SkipFile = 0
    OverWriteFile = 1
    InstallFile = 2



class InstallableElement:
    def __init__(self, name, installed_path):
        self.name = name
        self.source_path = os.path.abspath(name)
        self.installed_path = os.path.expanduser(installed_path)

    def exists(self):
        return os.path.exists(self.installed_path)

    def overwrite_existing_prompt(self):
        prompt = '{} already exists - Do your want to overwrite it: (N/y) > '.format(self.installed_path)
        response = input(prompt)
        return response.lower()

    def install_prompt(self):
        prompt = 'Do your want to install {}: (Y/n) > '.format(self.installed_path)
        response = input(prompt)
        return response.lower()

    def user_action(self):
        if self.exists():
            if self.overwrite_existing_prompt() == 'y':
                return UserChoice.OverWriteFile
            print('Skipping: {}'.format(self.installed_path))
            return UserChoice.SkipFile
        if self.install_prompt() == 'y':
            return UserChoice.InstallFile
        return UserChoice.SkipFile

    def __str__(self):
        return '{}: {} {}'.format(self.name, self.source_path, self.installed_path)


class SymLinkFile(InstallableElement):
    def install(self):
        action = self.user_action()
        if action == UserChoice.SkipFile:
            return
        if action == UserChoice.OverWriteFile:
            os.remove(self.installed_path)
        print('Symlink {} to {}'.format(self.installed_path , self.source_path))
        os.symlink(self.source_path, self.installed_path)

    def __str__(self):
        return '{}: {} -> {}'.format(self.name, self.source_path, self.installed_path)


class FolderOfSymlinks(InstallableElement):
    def __init__(self, name, installed_path, *elements):
        super().__init__(name, installed_path)
        self.elements = []
        for elem_name in elements:
            self.elements.append(SymLinkFile(elem_name, os.path.join(self.installed_path, elem_name)))

    def install(self):
        print('Nothing here yet')
        # Create folder if it does not exist.  Symlink elements into folder
        # If the folder exists, the symlinks should still be refreshed

    def __str__(self):
        result = super().__str__()
        for elem in self.elements:
            result += '\n' + str(elem)
        return result



elements = [
    SymLinkFile('bash_logout', '~/.bash_logout'),
    SymLinkFile('bash_profile', '~/.bash_profile'),
    SymLinkFile('bashrc', '~/.bashrc'),
    SymLinkFile('gitconfig', '~/.gitconfig'),
    SymLinkFile('gitignore', '~/.gitignore'),
    SymLinkFile('inputrc', '~/.inputrc'),
    SymLinkFile('profile', '~/.profile'),
    SymLinkFile('vimrc', '~/.vimrc'),
    SymLinkFile('Xdefaults', '~/.Xdefaults'),
    SymLinkFile('Xmodmap', '~/.Xmodmap'),
    FolderOfSymlinks('profile.d', '~/.profile.d', *os.listdir('profile.d')),
]

if __name__ == '__main__':
    for elem in elements:
        print(elem)
    for elem in elements:
        elem.install()


