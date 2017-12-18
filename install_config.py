'''
Install links
'''
import os
import sys
import readline
import shutil
import enum


class UserChoice(enum.Enum):
    SkipFile = '...'
    OverWriteFile = '=>*'
    InstallFile = '==>'


class InstallableElement:
    def __init__(self, name, path, installed_name=None, level=1, indent=3):
        self.name = name
        self.source_path = os.path.abspath(name)
        self.path = os.path.expanduser(path)
        self.installed_name = installed_name if installed_name is not None else name
        self.installed_path = os.path.join(self.path, self.installed_name)
        self.prefix = ' ' * level * indent
        self.user_choice = UserChoice.SkipFile

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
                self.user_choice = UserChoice.OverWriteFile
            else:
                print('Skipping: {}'.format(self.installed_path))
                self.user_choice = UserChoice.SkipFile
        elif self.install_prompt() == 'y':
            self.user_choice = UserChoice.InstallFile
        else:
            self.user_choice = UserChoice.SkipFile

    def show_action(self):
        if self.user_choice == UserChoice.SkipFile:
            return '{}{} Skipped'.format(self.prefix, self.source_path)
        return '{}{} {} {}'.format(self.prefix, self.source_path, self.user_choice, self.installed_path)


class SymLinkFile(InstallableElement):
    def install(self):
        if self.user_choice == UserChoice.SkipFile:
            return
        if self.user_choice == UserChoice.OverWriteFile:
            os.remove(self.installed_path)
        os.symlink(self.source_path, self.installed_path)

    def __str__(self):
        return '{}{}'.format(self.prefix, self.installed_name)


class FolderOfElements(InstallableElement):
    def __init__(self, name, path, installed_name=None, *elements, level=1, indent=3):
        super().__init__(name, path, installed_name, level=level, indent=indent)
        elements = os.listdir(name) if len(elements) == 0 else elements
        self.elements = []
        for element_name in elements:
            self.elements.append(SymLinkFile(element_name, self.installed_path, element_name, level=level+1))

    def install(self):
        print('Nothing here yet')
        # Create folder if it does not exist.  Symlink elements into folder
        # If the folder exists, the symlinks should still be refreshed

    def __str__(self):
        result = '{}{}'.format(self.prefix, self.installed_path)
        for elem in self.elements:
            result += '\n' + str(elem)
        return result


elements = [
    SymLinkFile('bash_logout', '~', '.bash_logout'),
    SymLinkFile('bash_profile', '~', '.bash_profile'),
    SymLinkFile('bashrc', '~', '.bashrc'),
    SymLinkFile('gitconfig', '~', '.gitconfig'),
    SymLinkFile('gitignore', '~', '.gitignore'),
    SymLinkFile('inputrc', '~', '.inputrc'),
    SymLinkFile('profile', '~', '.profile'),
    SymLinkFile('vimrc', '~', '.vimrc'),
    SymLinkFile('Xdefaults', '~', '.Xdefaults'),
    SymLinkFile('Xmodmap', '~', '.Xmodmap'),
    FolderOfElements('profile.d', '~', '.profile.d'),
]

if __name__ == '__main__':
    os.chdir('/home/shegelun/src/steen-linux-config')
    for elem in elements:
        print(elem)
    # for elem in elements:
    #     elem.install()


