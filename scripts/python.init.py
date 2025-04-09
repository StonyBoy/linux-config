#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2025-Apr-09 20:05
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
