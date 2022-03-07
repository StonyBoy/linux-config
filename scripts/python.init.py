# Steen Hegelund
# Time-Stamp: 2022-Mar-02 09:57
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

# Provide a bitwise not operation with a wordsize
def bit_not(n, wordsize=8):
    return (1 << wordsize) - 1 - n
