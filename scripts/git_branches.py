#!/usr/local/pyvenv/steen/bin/python3

'''
Manage local and remote git branches: delete, fast-forward, or prune stale refs
'''
import argparse
import curses
import subprocess
import re

# match values: modifier branchname unused checkoutpath unused remotebranch subject
branch_regex = re.compile(r'^([ *+])\s(\S+)\s+\S+(\s\((\S+)\)|)(\s\[(\S+)\]|)\s(.*)$')
gone_branch_regex = re.compile(r'^([ *+])\s(\S+)\s+\S+(\s\((\S+)\)|)(\s\[(\S+: gone)\])\s(.*)$')
behind_branch_regex = re.compile(r'^([ *+])\s(\S+)\s+\S+(\s\((\S+)\)|)(\s\[(\S+): behind \d+\]\s(.*)$)')

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

    def move_local(self):
        if move_branch_prompt(str(self)) == 'y':
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


PROTECTED_BRANCHES = {'master', 'main'}


class CleanupBranch:
    def __init__(self, fields):
        head, self.name, self.upstream, track, self.subject = fields
        self.current = head == '*'
        self.gone = track == '[gone]'
        self.shared_upstream = False  # set by get_cleanup_branches when >1 branch tracks the same upstream
        self.checked_out_elsewhere = False  # set by get_cleanup_branches when checked out in another worktree

    def status(self):
        if self.upstream and self.shared_upstream:
            return 'SHARED'
        if self.upstream and self.gone:
            return 'GONE'
        if self.upstream:
            return 'LIVE'
        return 'LOCAL'

    def has_live_remote(self):
        return bool(self.upstream) and not self.gone and not self.shared_upstream

    def is_protected(self):
        return self.current or self.checked_out_elsewhere or self.name in PROTECTED_BRANCHES

    def delete_local(self):
        run('git branch -D {}'.format(self.name))

    def push_delete_command(self):
        repo, remote_branch = self.upstream.split('/', 1)
        return 'git push {} --delete {}'.format(repo, remote_branch)

    def delete_remote(self):
        run(self.push_delete_command())


def worktree_branch_names():
    lines = run('git worktree list --porcelain')
    names = set()
    for line in lines:
        if line.startswith('branch refs/heads/'):
            names.add(line[len('branch refs/heads/'):])
    return names


def get_cleanup_branches():
    fmt = '%(HEAD)|%(refname)|%(upstream:short)|%(upstream:track)|%(subject)'
    lines = run('git for-each-ref refs/heads --format={}'.format(fmt))
    branches = []
    for line in lines:
        fields = line.split('|', 4)
        if len(fields) == 5:
            fields[1] = fields[1][len('refs/heads/'):]
            branches.append(CleanupBranch(fields))

    upstream_counts = {}
    for b in branches:
        if b.upstream:
            upstream_counts[b.upstream] = upstream_counts.get(b.upstream, 0) + 1
    for b in branches:
        if b.upstream and upstream_counts[b.upstream] > 1:
            b.shared_upstream = True

    checked_out = worktree_branch_names()
    for b in branches:
        if not b.current and b.name in checked_out:
            b.checked_out_elsewhere = True

    return branches


def prune_with_hourglass(stdscr, remote):
    stdscr.addstr(3, 0, 'Fetching from {}, please wait...'.format(remote)[:curses.COLS - 1])
    stdscr.clrtoeol()
    stdscr.refresh()
    prune_remote_refs(remote)
    curses.flushinp()  # discard any keys buffered while the prune was blocking


def confirm_remote_deletes(stdscr, both):
    curses.nocbreak()
    stdscr.keypad(False)
    curses.echo()
    curses.endwin()

    print('The following remote branches will be deleted:')
    for branch in both:
        print('  {}  ({})'.format(branch.push_delete_command(), branch.name))
    proceed = input('Type "yes" to proceed with the remote deletions above: ') == 'yes'
    if not proceed:
        print('Remote deletions cancelled, local-only deletions still apply')

    stdscr.keypad(True)
    curses.noecho()
    curses.cbreak()
    curses.curs_set(0)
    stdscr.refresh()
    return proceed


def checklist(stdscr, branches, local_path, remotes, remote_urls, remote_idx):
    curses.curs_set(0)
    marks = {b: {'local': False, 'remote': False} for b in branches}
    idx = 0
    name_width = max(len(b.name) for b in branches)
    while True:
        remote = remotes[remote_idx]
        stdscr.erase()
        stdscr.addstr(0, 0, 'local:  {}'.format(local_path)[:curses.COLS - 1], curses.A_BOLD)
        stdscr.addstr(1, 0, '{}: {}'.format(remote, remote_urls[remote])[:curses.COLS - 1], curses.A_BOLD)
        controls = 'ENTER/SPACE: local, r: remote (disabled for SHARED), TAB/S-TAB: change remote, X: apply, q: quit - State: * current, + other worktree, # protected'
        stdscr.addstr(2, 0, controls[:curses.COLS - 1])
        for row, b in enumerate(branches, start=4):
            if b.current:
                mark = '* '
            elif b.checked_out_elsewhere:
                mark = '+ '
            elif b.name in PROTECTED_BRANCHES:
                mark = '# '
            else:
                mark = '{}{}'.format('L' if marks[b]['local'] else ' ', 'R' if marks[b]['remote'] else ' ')
            line = '[{}] {:<5} {:<{name_width}}  {}'.format(mark, b.status(), b.name, b.subject, name_width=name_width)
            attr = curses.A_REVERSE if row - 4 == idx else curses.A_NORMAL
            stdscr.addstr(row, 0, line[:curses.COLS - 1], attr)
        stdscr.refresh()
        key = stdscr.getch()
        if key in (curses.KEY_UP, ord('k')):
            idx = (idx - 1) % len(branches)
        elif key in (curses.KEY_DOWN, ord('j')):
            idx = (idx + 1) % len(branches)
        elif key == ord('\t') and len(remotes) > 1:
            remote_idx = (remote_idx + 1) % len(remotes)
            prune_with_hourglass(stdscr, remotes[remote_idx])
        elif key == curses.KEY_BTAB and len(remotes) > 1:
            remote_idx = (remote_idx - 1) % len(remotes)
            prune_with_hourglass(stdscr, remotes[remote_idx])
        elif key in (ord(' '), curses.KEY_ENTER, 10, 13):
            branch = branches[idx]
            if not branch.is_protected():
                marks[branch]['local'] = not marks[branch]['local']
                if not marks[branch]['local']:
                    marks[branch]['remote'] = False
        elif key == ord('r'):
            branch = branches[idx]
            if not branch.is_protected() and branch.has_live_remote():
                marks[branch]['remote'] = not marks[branch]['remote']
                if marks[branch]['remote']:
                    marks[branch]['local'] = True
        elif key == ord('X'):
            local_only = [b for b in branches if marks[b]['local'] and not marks[b]['remote']]
            both = [b for b in branches if marks[b]['local'] and marks[b]['remote']]
            if both and not confirm_remote_deletes(stdscr, both):
                both = []
            for branch in local_only + both:
                branch.delete_local()
            for branch in both:
                branch.delete_remote()

            branches = get_cleanup_branches()
            if not branches:
                return
            marks = {b: {'local': False, 'remote': False} for b in branches}
            idx = min(idx, len(branches) - 1)
            name_width = max(len(b.name) for b in branches)
        elif key == ord('q'):
            return


def cleanup_branches(remote):
    print('Fetching from {}, please wait...'.format(remote))
    print(prune_remote_refs(remote))
    branches = get_cleanup_branches()
    if not branches:
        print('No local branches to clean up')
        return

    toplevel = run('git rev-parse --show-toplevel')
    local_path = toplevel[0] if toplevel else ''

    remotes = [r for r in run('git remote') if r]
    if remote not in remotes:
        remotes.insert(0, remote)
    remote_idx = remotes.index(remote)
    remote_urls = {r: (run('git remote get-url {}'.format(r)) or ['none'])[0] for r in remotes}

    curses.wrapper(checklist, branches, local_path, remotes, remote_urls, remote_idx)


def prune_remote_refs(remote):
    cp = subprocess.run('git remote prune {}'.format(remote).split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = (cp.stdout.decode() + cp.stderr.decode()).strip()
    return output if output else 'No stale {}/* refs to prune'.format(remote)


def move_branches():
    lines = run('git branch -vv')
    for line in lines:
        found = behind_branch_regex.findall(line)
        if len(found) and len(found[0]) == 7:
            branch = Branch(found[0])
            branch.move_local()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-c', '--cleanup', action='store_true', default=False, help='Prune stale REMOTE refs, then show a checklist to pick local branches to delete and which of those to also delete on REMOTE')
    parser.add_argument('-m', '--move-behind', action='store_true', default=False, help='Fast-forward local branches behind their remote to the remote tip, prompting for each')
    parser.add_argument('remote', nargs='?', default='origin', metavar='REMOTE', help='Remote to prune with -c, defaults to origin')
    args = parser.parse_args()
    if args.cleanup:
        cleanup_branches(args.remote)
    elif args.move_behind:
        move_branches()
    else:
        parser.print_help()
