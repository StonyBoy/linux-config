#!/bin/bash
# Run a named remote tmux session in a terminal
# Shows a list of remote session names when started without an argument
# Can be used from rofi
# Steen Hegelund
# Time-Stamp: 2020-Dec-08 17:23

if [ $# -gt 0 ]; then
    case "$1" in
        "Plain SSH Terminal")
            coproc (alacritty --title "Work SSH" -e ssh -t work)
            ;;
        "X11 Forwarding SSH Terminal")
            coproc (alacritty --title "X11 FWD Work SSH" -e ssh -Y -t work)
            ;;
        *)
            coproc (alacritty --title "$1" -e ssh -t work tmux -u attach-session -t $1)
            ;;
    esac
else
    echo "Plain SSH Terminal"
    echo "X11 Forwarding SSH Terminal"
    ssh work tmux list-sessions | sed -E 's/:.*//'
fi
