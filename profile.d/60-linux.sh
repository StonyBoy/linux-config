#! /bin/bash
# -*-sh-*-
alias dm='displaymode'
alias lsblk='lsblk --output NAME,FSTYPE,LABEL,UUID,PARTUUID,MOUNTPOINT'


function _complete_start_vnc()
{
    COMPREPLY=( $( compgen -W "mac pc single" -- ${COMP_WORDS[COMP_CWORD]} ) )
    return 0
}

function show_vnc()
{
    echo "VNC Service: "
    systemctl status x0vncserver | grep "Active:"
}

function start_vnc()
{
    if [[ $HOSTNAME == "soft-dev13" ]]; then
        x0vncserver -display :0 -Geometry 2560x1440 -SecurityTypes vncauth,tlsvnc -rfbauth ~/.vnc/passwd -rfbport 5900
    fi
    if [[ $HOSTNAME == "soft-dev99" ]]; then
        x0vncserver -display :0 -Geometry 1920x1080 -SecurityTypes vncauth,tlsvnc -rfbauth ~/.vnc/passwd -rfbport 5900
    fi
}
complete -F _complete_start_vnc start_vnc

function show_ip()
{
    ip addr list wan | grep 'inet ' | grep -v '127.0.0.1' | cut -d" " -f6
}

function _complete_displaymode()
{
    COMPREPLY=( $( compgen -W "dual main extra vnc show" -- ${COMP_WORDS[COMP_CWORD]} ) )
    return 0
}

function displaymode()
{
    local main_monitor=DP-3
    local extra_monitor=DP-2
    if [[ "$1" == "dual" ]]; then
        xrandr -d :0 --output $main_monitor  --mode 2560x1440
        xrandr -d :0 --output $extra_monitor --mode 2560x1440
        xrandr -d :0 --output $main_monitor  --mode 2560x1440 --primary --right-of $extra_monitor --output $extra_monitor --mode 2560x1440
    elif [[ "$1" == "main" ]]; then
        xrandr -d :0 --output $main_monitor --mode 2560x1440 --primary --output $extra_monitor --off
    elif [[ "$1" == "extra" ]]; then
        xrandr -d :0 --output $extra_monitor --mode 2560x1440 --primary --output $main_monitor --off
    elif [[ "$1" == "vnc" ]]; then
        xrandr -d :0 --output $main_monitor --mode 1920x1200 --primary --output $extra_monitor --off
    elif [[ "$1" == "show" ]]; then
        xrandr --display :0 | grep " connected" | cut -d" " -f1 
    else
        xrandr
    fi
}
complete -F _complete_displaymode displaymode dm

