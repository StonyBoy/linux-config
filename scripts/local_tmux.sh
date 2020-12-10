#!/bin/bash
# Run a named local tmux session in a terminal
# Shows a list of session names when started without an argument
# Can be used from rofi

# Steen Hegelund
# Time-Stamp: 2020-Dec-10 09:17

if [ $# -gt 0 ]; then
    case "$1" in
        *)
            coproc (alacritty --title "$1" -e tmux -u attach-session -t $1)
            ;;
    esac
else
    tmux list-sessions | sed -E 's/:.*//'
fi

