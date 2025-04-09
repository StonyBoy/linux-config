#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2025-Apr-09 20:09
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :
# Return a list of neomutt formatted maildir foldernames

import os
import sys


def get_mailbox_folder_list(top, account=None):
    base = top + os.sep
    if account:
        top = os.path.join(top, account) + os.sep
    else:
        top = top + os.sep
    result = []
    for dirpath, dirnames, filenames in os.walk(top):
        if 'cur' in dirnames:
            mname = dirpath.replace(base, '')
            if 'Inbox' in mname:
                result.insert(0, f'"+{mname}"')
            else:
                result.append(f'"+{mname}"')
    return result


if len(sys.argv) == 2:
    top = os.path.expanduser(sys.argv[1]).rstrip(os.sep)
    print(' '.join(get_mailbox_folder_list(top)))
elif len(sys.argv) == 3:
    top = os.path.expanduser(sys.argv[1]).rstrip(os.sep)
    print(' '.join(get_mailbox_folder_list(top, sys.argv[2])))
else:
    print(f'Usage: {sys.argv[0]} <mailbox account path> <foldername>')
