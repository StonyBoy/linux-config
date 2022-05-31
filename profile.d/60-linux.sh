#! /bin/bash
# -*-sh-*-
alias lsblk='lsblk --output NAME,FSTYPE,LABEL,UUID,PARTUUID,MOUNTPOINT'


function _complete_start_vnc()
{
    COMPREPLY=( $( compgen -W "mac pc single" -- ${COMP_WORDS[COMP_CWORD]} ) )
    return 0
}

function show_vnc()
{
    echo "VNC Service: "
    systemctl status vncserver@:1
    # systemctl status x0vncserver | grep "Active:"
}

function start_vnc()
{
    # Add user in /etc/tigervnc/vncserver.users
    # Set session in ~/.vnc/config
    sudo systemctl start vncserver@:1
    # x0vncserver -display :0 -SecurityTypes vncauth,tlsvnc -rfbauth ~/.vnc/passwd -rfbport 5900
}
complete -F _complete_start_vnc start_vnc

function show_ip()
{
    ip addr list wan | grep 'inet ' | grep -v '127.0.0.1' | cut -d" " -f6
}

function tmux_go_vim()
{
    tmux switch -t $(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_tty}' | grep $(ps -o tty= -p $(lsof -t $1))$ | awk '{ print $1 }')
}

