# Steen Hegelund
# Time-Stamp: 2019-Dec-12 13:44
# Set env PYTHONSTARTUP to this file to have this functionality in the interpreter

import sys

def display_as_hex(item):
    if isinstance(item, int):
        print(hex(item))
    else:
        print(repr(item))

def hexon():
    sys.displayhook = display_as_hex

def hexoff():
    sys.displayhook = sys.__displayhook__
