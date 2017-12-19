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
        self.user_choice = UserChoice.InstallFile

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
            print('{}{} Skipped'.format(self.prefix, self.source_path))
        else:
            print('{}{} {} {}'.format(self.prefix, self.source_path, self.user_choice.value, self.installed_path))


class FileLink(InstallableElement):
    def install(self):
        if self.user_choice == UserChoice.SkipFile:
            return
        if self.user_choice == UserChoice.OverWriteFile:
            os.remove(self.installed_path)
        os.symlink(self.source_path, self.installed_path)

    def __str__(self):
        return '{}{} : {}'.format(self.prefix, self.installed_name, self.installed_path)


class GroupLink(InstallableElement):
    def __init__(self, name, path, installed_name=None, level=1, indent=3):
        self.elements = []
        super().__init__(name, path, installed_name, level=level, indent=indent)
        for root, folders, files in os.walk(name):
            # print('root', root)
            dst_path = os.path.join(self.installed_path, root.replace(name + '/', ''))
            # print('dst_path', dst_path)
            for file in files:
                src_path = os.path.join(root, file)
                self.elements.append(FileLink(src_path, dst_path, level=level + 1))

    def install(self):
        print('Nothing here yet')
        # Create folder if it does not exist.  Symlink elements into folder
        # If the folder exists, the symlinks should still be refreshed

    def show_action(self):
        for element in self.elements:
            element.show_action()

    def __str__(self):
        result = '{}{}'.format(self.prefix, self.installed_path)
        for elem in self.elements:
            result += '\n' + str(elem)
        return result


elements = [
    FileLink('bash_logout', '~', '.bash_logout'),
    FileLink('bash_profile', '~', '.bash_profile'),
    FileLink('bashrc', '~', '.bashrc'),
    FileLink('gitconfig', '~', '.gitconfig'),
    FileLink('gitignore', '~', '.gitignore'),
    FileLink('inputrc', '~', '.inputrc'),
    FileLink('profile', '~', '.profile'),
    FileLink('vimrc', '~', '.vimrc'),
    FileLink('Xdefaults', '~', '.Xdefaults'),
    FileLink('Xmodmap', '~', '.Xmodmap'),
    GroupLink('profile.d',          '~', '.profile.d'),
    GroupLink('scripts',            '~'),
    GroupLink('config',             '~', '.config'),
]

if __name__ == '__main__':
    for elem in elements:
        elem.show_action()
    # for elem in elements:
    #     elem.install()


