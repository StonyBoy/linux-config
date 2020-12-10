#! /usr/bin/env python3
'''
Prune local git branches that do not have remote counterparts either unconditionally or by prompting the user
'''
import argparse
import sys
import subprocess
import re

def run(cmd):
    cp = subprocess.run(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if cp.returncode == 0:
        return cp.stdout.decode().split('\n')
    return cp.stderr.decode().split('\n')


def delete_branch_prompt(name):
    prompt = 'Do you want to delete this branch "{}": (N/y) > '.format(name)
    response = input(prompt)
    return response.lower()


def move_branch_prompt(name):
    prompt = 'Do you want to move this branch "{}": (N/y) > '.format(name)
    response = input(prompt)
    return response.lower()


def delete_branches(unconditionally):
    run('git remote prune origin')
    lines = run('git branch -vv')
    regex = re.compile(r'^\s+(\S+)\s+\S+\s\[\S+/\S+: gone\]')
    for line in lines:
        found = regex.findall(line)
        # print(found if len(found) else '---')
        if len(found):
            name = found[0]
            if unconditionally:
                run('git branch -D {}'.format(name))
            else:
                if delete_branch_prompt(name) == 'y':
                    run('git branch -D {}'.format(name))


def move_branches(unconditionally):
    lines = run('git branch -vv')
    regex = re.compile(r'^\s+(\S+)\s+\S+\s\[(\S+/\S+): behind \d+\]')
    for line in lines:
        found = regex.findall(line)
        # print(found if len(found) else '---')
        if len(found):
            name = found[0][0]
            remote = found[0][1]
            if unconditionally:
                run('git branch -f {} {}'.format(name, remote))
            else:
                if move_branch_prompt(name) == 'y':
                    run('git branch -f {} {}'.format(name, remote))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-d', '--delete', action='store_true', default=False, help='Delete local branches')
    parser.add_argument('-D', '--delete_unconditionally', action='store_true', default=False, help='Delete local branches unconditionally')
    parser.add_argument('-m', '--move', action='store_true', default=False, help='Move local branches')
    parser.add_argument('-M', '--move_unconditionally', action='store_true', default=False, help='Move local branches unconditionally')
    args = parser.parse_args()
    if args.delete or args.delete_unconditionally:
        delete_branches(args.delete_unconditionally)
    elif args.move or args.move_unconditionally:
        move_branches(args.move_unconditionally)
    else:
        parser.print_help()
