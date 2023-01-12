#! /usr/bin/env python3
'''
Steen Hegelund
Time-Stamp: 2023-Jan-12 22:28

Mount configured shares via CIFS or SSHFS
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

def syscmd(cmd):
    if verbose:
        print(f'=> {cmd}')
    cp = subprocess.run(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    if cp.returncode == 0:
        return cp.stdout.decode().split('\n')
    return []


def create_folders(config, mname = None):
    print('create_folders', config, mname)
    for name in config['mounts']:
        if not mname or mname != name:
            continue
        ldir = os.path.expanduser(os.path.join(config['local'], name))
        if os.path.exists(ldir):
            continue
        print(f"creating local folder {ldir}")
        syscmd(f"mkdir -p {ldir}")


def mount_folders(config, mname = None):
    print('mount_folders', config, mname)
    options = []
    if config['type'] == 'cifs':
        for key, value in config['options'].items():
            if value:
                options.append(f"{key}={value}")
            else:
                options.append(f"{key}")
    optstr = ','.join(options)
    print('optstr', optstr)
    for name in config['mounts']:
        if mname and mname != name:
            continue
        ldir = os.path.expanduser(os.path.join(config['local'], name))
        rdir = f"{config['remote']}/{name}"
        print(f"mounting folder {ldir}")
        syscmd(f"sudo mount -t cifs {rdir} {ldir} -o {optstr}")


def unmount_folders(config, mname = None):
    print('unmount_folders', config, mname)
    for name in config['mounts']:
        if mname and mname != name:
            continue
        ldir = os.path.expanduser(os.path.join(config['local'], name))
        print(f"unmounting folder {ldir}")
        syscmd(f"sudo umount {ldir}")


def get_system_mounts(shares):
    for name, config in shares.items():
        config['systemmounts'] = {}
        if not config['mounts']:
            continue
        for name in config['mounts']:
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
            for lname in config['mounts']:
                ldir = os.path.expanduser(os.path.join(config['local'], lname))
                if item[1] != ldir:
                    continue
                config['systemmounts'][lname] = f'-> {item[1]}'


def show_folders(config):
    for name in config['mounts']:
        if config['type'] == 'cifs':
            rdir = f"{config['remote']}/{name}"
        elif config['type'] == 'sshfs':
            rdir = f"{config['options']['username']}@{config['remote']}:{name}"
        else:
            print(f"\"{config['type']}\" mounts not supported")
            break
        print(f"{name:<20}: {rdir:<60} {config['systemmounts'][name]}")


def show_mounts(shares):
    get_system_mounts(shares)
    print("Currently mounted shares")
    for name, config in shares.items():
        if not config['mounts']:
            continue
        show_folders(config)
    sys.exit(0)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-v', dest='verbose', help='Show actions', action='store_true')
    parser.add_argument('-m', dest='mount', help='Mount all listed shares', action='store_true')
    parser.add_argument('-u', dest='unmount', help='Unmount all listed shares', action='store_true')
    parser.add_argument('-o', dest='mountnamed', help='Mount named share', type=str)
    parser.add_argument('-n', dest='unmountnamed', help='Unmount named share', type=str)

    args = parser.parse_args()

    verbose = args.verbose

    cfgfile = os.path.expanduser('~/.config/python/network-shares.yaml')
    if not os.path.exists(cfgfile):
        print(f'Could not find #{cfgfile}')
        sys.exit(1)

    with open(cfgfile, 'rt') as fobj:
        shares = yaml.safe_load(fobj)

        if args.mountnamed:
            for name, config in shares.items():
                if not config['mounts']:
                    continue
                create_folders(config, args.mountnamed)
                mount_folders(config, args.mountnamed)
            show_mounts(shares)

        if args.mount:
            for name, config in shares.items():
                if not config['mounts']:
                    continue
                create_folders(config)
                mount_folders(config)
            show_mounts(shares)

        if args.unmountnamed:
            for name, config in shares.items():
                if not config['mounts']:
                    continue
                unmount_folders(config, args.unmountnamed)
            show_mounts(shares)

        if args.unmount:
            for name, config in shares.items():
                if not config['mounts']:
                    continue
                unmount_folders(config)
            show_mounts(shares)

        show_mounts(shares)
