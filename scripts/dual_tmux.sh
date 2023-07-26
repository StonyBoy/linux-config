#!/bin/bash
# Time-Stamp: 2023-Jul-26 17:07
# Steen Hegelund
#
# Run a named tmux session in a terminal either remotely or locally
# Shows a list of remote session names when started without an argument
# Can be used from rofi
#
# Arguments:
# 1: remote server hostname
# 2: remote server tmux session name or empty to print a list of sessions
#

function use_remote() {
    ping -c 5 -A -q -W 2 $1 &> /dev/null
    return $?
}

function remote_tmux() {
    if [ $# -gt 1 ]; then
        case "$2" in
            "Plain SSH Terminal")
                coproc (alacritty --title "Work SSH" -e ssh -t $1)
                ;;
            "X11 Forwarding SSH Terminal")
                coproc (alacritty --title "X11 FWD Work SSH" -e ssh -Y -t $1)
                ;;
            *)
                coproc (alacritty --title "$1" -e ssh -t $1 tmux -u attach-session -t $2)
                ;;
        esac
    else
        echo "Plain SSH Terminal"
        echo "X11 Forwarding SSH Terminal"
        ssh work tmux list-sessions | sed -E 's/:.*//'
    fi
}

function local_tmux() {
    if [ $# -gt 1 ]; then
        case "$2" in
            *)
                coproc (alacritty --title "$1" -e tmux -u attach-session -t $2)
                ;;
        esac
    else
        tmux list-sessions | sed -E 's/:.*//'
    fi
}

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 servername [sessionname]"
else
    if tmux info &> /dev/null; then
        local_tmux $*
    else
        if use_remote $1; then
            remote_tmux $*
        else
            echo remote server not available
        fi
    fi
fi
