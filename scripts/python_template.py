#!/usr/bin/env python3

# Steen Hegelund
# Time-Stamp: 2025-Sep-02 09:42
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :
'''
Description
'''

import argparse
import sys


def parse_arguments() -> (argparse.ArgumentParser, argparse.Namespace):
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter, exit_on_error=False)

    parser.add_argument('--verbose', action='store_true', help='Provide more information')

    try:
        return parser, parser.parse_args()
    except argparse.ArgumentError:
        parser.print_help()
        sys.exit(1)


def main():
    parser, args = parse_arguments()
    if len(vars(args)) == 1:
        parser.print_help()


if __name__ == '__main__':
    main()
