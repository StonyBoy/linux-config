#! /usr/bin/env python3
import os
import sys

def get_mailbox_folder_list(top):
    base = os.path.dirname(top) + os.sep
    account = os.path.basename(top)
    result = []
    for dirpath, dirnames, filenames in os.walk(top):
        if 'cur' in dirnames:
            result.append('"+{}"'.format(dirpath.replace(base, '')))
    return result


if len(sys.argv) > 1:
    top = os.path.expanduser(sys.argv[1]).rstrip(os.sep)
    print(' '.join(get_mailbox_folder_list(top)))
else:
    print('Usage: {} <mailbox account path>'.format(sys.argv[0]))
