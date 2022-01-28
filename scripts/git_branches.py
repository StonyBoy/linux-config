#! /usr/bin/env python3
'''
Prune local git branches that do not have remote counterparts either unconditionally or by prompting the user
'''
import argparse
import subprocess
import re

# match values: modifier branchname unused checkoutpath unused remotebranch subject
branch_regex = re.compile(r'^([ *+])\s(\S+)\s+\S+(\s\((\S+)\)|)(\s\[(\S+)\]|)\s(.*)$')
gone_branch_regex = re.compile(r'^([ *+])\s(\S+)\s+\S+(\s\((\S+)\)|)(\s\[(\S+: gone)\])\s(.*)$')
behind_branch_regex = re.compile(r'^([ *+])\s(\S+)\s+\S+(\s\((\S+)\)|)(\s\[(\S+):[^]]+behind \d+\]\s(.*)$)')

def run(cmd):
    cp = subprocess.run(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if cp.returncode == 0:
        return cp.stdout.decode().split('\n')
    errormsg = cp.stderr.decode().split('\n')
    print(cmd, errormsg)
    return errormsg


def delete_branch_prompt(name):
    prompt = 'Do you want to delete this branch "{}": (N/y) > '.format(name)
    response = input(prompt)
    return response.lower()


def move_branch_prompt(name):
    prompt = 'Do you want to move this branch "{}": (N/y) > '.format(name)
    response = input(prompt)
    return response.lower()


class Branch:
    def __init__(self, info):
        self.status, self.name, unused, self.path, unused, self.remote, self.subject = info

    def delete_local(self, force = False):
        if self.status == '+':  # Cannot delete a branch that is checked out locally
            return
        if force or delete_branch_prompt(str(self)) == 'y':
            run('git branch -D {}'.format(self.name))

    def delete_remote(self, force = False):
        if len(self.remote) == 0:  # Ignore local-only branches
            return
        if force or delete_branch_prompt(str(self)) == 'y':
            run('git branch -D {}'.format(self.name))
            repo, branch = self.remote.split('/', 1)
            run('git push {} --delete {}'.format(repo, branch))

    def move_local(self, force = False):
        if force or move_branch_prompt(str(self)) == 'y':
            run('git branch -f {} {}'.format(self.name, self.remote))

    def __str__(self):
        if self.path and self.remote:
            fullname = '{} at {} -> {}: {}'.format(self.name, self.path, self.remote, self.subject)
        elif self.path:
            fullname = '{} at {}: {}'.format(self.name, self.path, self.subject)
        elif self.remote:
            fullname = '{} -> {}: {}'.format(self.name, self.remote, self.subject)
        else:
            fullname = '{}: {}'.format(self.name, self.subject)
        return fullname


def delete_gone_branches(force):
    lines = run('git branch -vv')
    for line in lines:
        found = gone_branch_regex.findall(line)
        if len(found) and len(found[0]) == 7:
            branch = Branch(found[0])
            branch.delete_local(force)
    run('git remote prune origin')


def delete_remote_branches():
    lines = run('git branch -vv')
    for line in lines:
        found = branch_regex.findall(line)
        if len(found) and len(found[0]) == 7:
            branch = Branch(found[0])
            branch.delete_remote()
    run('git remote prune origin')


def delete_local_branches():
    lines = run('git branch -vv')
    for line in lines:
        found = branch_regex.findall(line)
        if len(found) and len(found[0]) == 7:
            branch = Branch(found[0])
            branch.delete_local()


def move_branches(force):
    lines = run('git branch -vv')
    for line in lines:
        found = behind_branch_regex.findall(line)
        if len(found) and len(found[0]) == 7:
            branch = Branch(found[0])
            branch.move_local(force)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-d', '--delete', action='store_true', default=False, help='Delete local branches where the remote companion is gone')
    parser.add_argument('-D', '--delete_unconditionally', action='store_true', default=False, help='Delete local branches unconditionally')
    parser.add_argument('-m', '--move', action='store_true', default=False, help='Move local branches')
    parser.add_argument('-M', '--move_unconditionally', action='store_true', default=False, help='Move local branches unconditionally')
    parser.add_argument('-r', '--remotedelete', action='store_true', default=False, help='Delete both local and remote branches')
    parser.add_argument('-l', '--localdelete', action='store_true', default=False, help='Delete local branches')
    args = parser.parse_args()
    if args.delete or args.delete_unconditionally:
        delete_gone_branches(args.delete_unconditionally)
    elif args.localdelete:
        delete_local_branches()
    elif args.remotedelete:
        delete_remote_branches()
    elif args.move or args.move_unconditionally:
        move_branches(args.move_unconditionally)
    else:
        parser.print_help()
