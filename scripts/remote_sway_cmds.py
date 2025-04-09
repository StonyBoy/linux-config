#!/usr/local/pyvenv/steen/bin/python3

# Steen Hegelund
# Time-Stamp: 2025-Apr-09 20:06
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=python :

import argparse
import subprocess
import sys


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument('command', nargs='?', default='')
    parser.add_argument('--server', '-s', default='localhost')
    parser.add_argument('--verbose', '-v', action='store_true')

    return parser.parse_args()


remote_commands = {
    'refresh_wallpaper': 'output * bg ~/Pictures/Wallpapers/wallpaper.jpg fill',
    'lock_screen': 'exec swaylock',
    'toggle_monitor': 'output DP-1 toggle',
    'open_terminal': 'exec alacritty',
    'reload_sway_config': 'reload',
    'monitors': '-t get_outputs',
    'apps': '-p -t get_tree',
    'show_mainmenu': 'exec rofi -modi drun#run -show drun -theme mainmenu',
    'goto_workspace_1': 'workspace number 1',
    'goto_workspace_2': 'workspace number 2',
    'goto_workspace_3': 'workspace number 3',
    'goto_workspace_4': 'workspace number 4',
    'goto_workspace_5': 'workspace number 5',
    'goto_workspace_6': 'workspace number 6',
    'goto_workspace_7': 'workspace number 7',
    'goto_workspace_8': 'workspace number 8',
    'goto_workspace_9': 'workspace number 9',
    'goto_workspace_10': 'workspace number 10',
}


def get_cmd_list(args):
    for item in remote_commands.keys():
        print(item)


def ping_server(name):
    if len(name) == 0:
        return False

    cp = subprocess.run(['ping', '-Aqc 5', '-W 0.1', name], capture_output=True)
    return cp.returncode == 0


def get_remote_swaybg_pid(args):
    if args.server == 'localhost':
        cmd = ['pgrep', 'swaybg']
    else:
        cmd = ['ssh', '-t', args.server, 'pgrep', 'swaybg']
    cp = subprocess.run(cmd, capture_output=True)
    if cp.returncode == 0:
        lines = cp.stdout.decode().split('\n')
        for line in lines:
            return int(line)
    return 0


def get_remote_swaysock(args):
    pid = get_remote_swaybg_pid(args)
    if pid:
        if args.server == 'localhost':
            cmd = ['cat', f'/proc/{pid}/environ']
        else:
            cmd = ['ssh', '-t', args.server, 'cat', f'/proc/{pid}/environ']
        cp = subprocess.run(cmd, capture_output=True)
        if cp.returncode == 0:
            lines = cp.stdout.decode().split('\n')
            for line in lines:
                environ = line.split('\0')
                for elem in environ:
                    if len(elem) == 0:
                        continue
                    try:
                        key, value = elem.split('=', maxsplit=1)
                        if key == 'SWAYSOCK':
                            return elem
                    except ValueError:
                        return None
    elif len(args.server) > 0:
        print('Could not find any sway session')


def run(args):
    swaysock = get_remote_swaysock(args)
    if swaysock:
        cmd = ['ssh', '-t', args.server, f'{swaysock} swaymsg {remote_commands[args.command]}']

        # Specifying a pipe for the 3 std devices allows the process to run detached
        cp = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
        if cp.returncode == 0:
            print(cp.stdout.decode())


def main():
    args = parse_arguments()
    if args.command:
        run(args)
    else:
        get_cmd_list(args)


if __name__ == '__main__':
    main()

sys.exit(0)
