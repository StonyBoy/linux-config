#! /usr/bin/env python3
import os
import sys

def get_mailbox_folder_list(top, account = None):
    base = top + os.sep
    if account:
        top = os.path.join(top, account) + os.sep
    else:
        top = top + os.sep
    result = []
    for dirpath, dirnames, filenames in os.walk(top):
        if 'cur' in dirnames:
            result.append('"+{}"'.format(dirpath.replace(base, '')))
    return result


if len(sys.argv) == 2:
    top = os.path.expanduser(sys.argv[1]).rstrip(os.sep)
    print(' '.join(get_mailbox_folder_list(top)))
elif len(sys.argv) == 3:
    top = os.path.expanduser(sys.argv[1]).rstrip(os.sep)
    print(' '.join(get_mailbox_folder_list(top, sys.argv[2])))
else:
    print('Usage: {} <mailbox account path>'.format(sys.argv[0]))
