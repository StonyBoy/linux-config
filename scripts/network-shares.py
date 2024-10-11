#! /usr/bin/env python3
'''
Steen Hegelund
Time-Stamp: 2024-Oct-11 13:40

Mount configured shares via CIFS or SSHFS

The scripts reads a configuration file at ~/.config/python/network-shares.yaml
The configuration can consist of a number of sections like the example below:

    <name>:
      type: cifs
      local: ~/mnt/laptop
      remote: <remote server e.g. //server/share >
      mounts:
        <mount name>: <path on remote eg. "User/name/Downloads",  This is appended on "remote" >
      options:
        username: <remote username>
        password: <remote plaintext password>
        passcmd: <command to get the remote password e.g using gpg>
        domain: <domain name>
        uid: <local username>
        gid: <local groupname>
        iocharset: utf8
        vers: <use cifs protocol version, e.g. 1.0 or 2.0>

There can be multiple mounts specified on the same server, and you use the mount name to select which one to use.

'''
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import os.path
import sys
import argparse
import subprocess
import re
import yaml

global verbose

verbose = False


def parse_arguments():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--verbose', '-v', help='Show actions', action='store_true')
    parser.add_argument('--mountall', '-a', help='Mount all listed shares', action='store_true')
    parser.add_argument('--unmountall', '-x', help='Unmount all listed shares', action='store_true')
    parser.add_argument('--unmount', '-u', nargs='*', help='Unmount this share')
    parser.add_argument('mount', nargs='*', help='Mount this share')

    return parser.parse_args()


def syscmd(cmd):
    if verbose:
        print(f'=> {cmd}')
    cp = subprocess.run(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if cp.returncode == 0:
        return cp.stdout.decode().split('\n')
    return []


def create_folders(config, mname=None):
    for name in config['mounts'].keys():
        if mname is not None and name not in mname:
            continue
        ldir = os.path.expanduser(os.path.join(config['local'], name))
        if os.path.exists(ldir):
            continue
        print(f'creating local folder: {ldir}')
        syscmd(f'mkdir -p {ldir}')


def get_password(cmdstr):
    cmd = []
    for elem in cmdstr.split():
        cmd.append(os.path.expanduser(elem))
    cp = subprocess.run(cmd, capture_output=True)
    lines = cp.stdout.decode().split('\n')
    for line in lines:
        if len(line) > 0:
            return line
    return ''


def update_options(config):
    for key, value in config['options'].items():
        if key == 'passcmd':
            value = get_password(value)
            if len(value):
                config['options']['password'] = value
            del config['options']['passcmd']
            break


def parse_options(config):
    options = []
    if config['type'] == 'cifs':
        update_options(config)
        for key, value in config['options'].items():
            if value:
                options.append(f"{key}={value}")
            else:
                options.append(f"{key}")
    return ','.join(options)


def mount_folders(config, mname=None):
    optstr = parse_options(config)
    for name, share in config['mounts'].items():
        if mname is not None and name not in mname:
            continue
        ldir = os.path.expanduser(os.path.join(config['local'], name))
        rdir = f"{config['remote']}/{share}"
        print(f'mounting local folder: {ldir}')
        syscmd(f'sudo mount -t cifs {rdir} {ldir} -o {optstr}')


def unmount_folders(config, mname=None):
    for name in config['mounts'].keys():
        if mname is not None and name not in mname:
            continue
        ldir = os.path.expanduser(os.path.join(config['local'], name))
        print(f'unmounting folder {ldir}')
        syscmd(f"sudo umount {ldir}")


def get_system_mounts(shares):
    for name, config in shares.items():
        config['systemmounts'] = {}
        if not config['mounts']:
            continue
        for name in config['mounts'].keys():
            config['systemmounts'][name] = '-'
    resp = syscmd('mount')
    regex = re.compile(r'\S+ on (\S+)')
    for line in resp:
        item = regex.match(line)
        if not item:
            continue
        for name, config in shares.items():
            if not config['mounts']:
                continue
            for sname, share in config['mounts'].items():
                ldir = os.path.expanduser(os.path.join(config['local'], sname))
                if item[1] != ldir:
                    continue
                config['systemmounts'][sname] = f'-> {item[1]}'


def show_folders(config):
    for name, share in config['mounts'].items():
        if config['type'] == 'cifs':
            rdir = f"{config['remote']}/{share}"
        elif config['type'] == 'sshfs':
            rdir = f"{config['options']['username']}@{config['remote']}:{share}"
        else:
            print(f'\"{config["type"]}\" mounts not supported')
            break
        print(f'{name:<20}: {rdir:<60} {config["systemmounts"][name]}')


def show_mounts(shares):
    get_system_mounts(shares)
    print('Currently mounted shares:\n')
    print(f'{"Name":<20}: {"Network Share":<60} Local Mounted Folder')
    print(f'{"-"*110}')
    for name, config in shares.items():
        if not config['mounts']:
            continue
        show_folders(config)
    sys.exit(0)


def command(args, cfgfile):
    with open(cfgfile, 'rt') as fobj:
        shares = yaml.safe_load(fobj)

        if args.mount:
            for name, config in shares.items():
                if not config['mounts']:
                    continue
                create_folders(config, args.mount)
                mount_folders(config, args.mount)
            show_mounts(shares)

        elif args.mountall:
            for name, config in shares.items():
                if not config['mounts']:
                    continue
                create_folders(config)
                mount_folders(config)
            show_mounts(shares)

        elif args.unmount:
            for name, config in shares.items():
                if not config['mounts']:
                    continue
                unmount_folders(config, args.unmount)
            show_mounts(shares)

        elif args.unmountall:
            for name, config in shares.items():
                if not config['mounts']:
                    continue
                unmount_folders(config)
            show_mounts(shares)

        else:
            show_mounts(shares)


if __name__ == '__main__':
    args = parse_arguments()
    verbose = args.verbose

    cfgfile = os.path.expanduser('~/.config/python/network-shares.yaml')
    if not os.path.exists(cfgfile):
        print(f'Could not find {cfgfile}')
        sys.exit(1)

    command(args, cfgfile)
