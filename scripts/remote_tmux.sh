#!/bin/bash
# Run a named remote tmux session in a terminal
# Shows a list of remote session names when started without an argument
# Can be used from rofi
# Steen Hegelund
# Time-Stamp: 2020-Dec-08 09:17

if [ $# -gt 0 ]; then
    coproc (rofi-sensible-terminal -title "$1" -e "ssh -t work tmux -u attach-session -t $1")
else
    ssh work tmux list-sessions | sed -E 's/:.*//'
fi
