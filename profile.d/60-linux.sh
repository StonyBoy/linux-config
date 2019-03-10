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

function multimedia_keys()
{
    # Keyboard mapping for keyboards without multimedia keys (PrintScreen, ScrollLock, Pause, F11, F12)
    xmodmap -e "keycode 107 = XF86AudioLowerVolume XF86AudioLowerVolume XF86AudioLowerVolume XF86AudioLowerVolume"
    xmodmap -e "keycode 78  = XF86AudioRaiseVolume XF86AudioRaiseVolume XF86AudioRaiseVolume XF86AudioRaiseVolume"
    xmodmap -e "keycode 127 = XF86AudioPlay XF86AudioPlay XF86AudioPlay XF86AudioPlay"
    xmodmap -e "keycode 95  = XF86AudioPrev XF86AudioPrev XF86AudioPrev XF86AudioPrev"
    xmodmap -e "keycode 96  = XF86AudioNext XF86AudioNext XF86AudioNext XF86AudioNext"
}

function setdk_default()
{
    # Keymaps are handled in /etc/X11/xorg.conf.d/00-keyboard.conf via localectl
    local RULES=${1:-evdev}
    local LEVEL=${2:-0}
    # Values? check: man xkeyboard-config
    setxkbmap -rules $RULES -model pc105 -layout dk -variant "nodeadkeys" -option "caps:ctrl_modifier" -verbose $LEVEL
}

function setdk_xorg()
{
    setdk_default xorg
}

HOSTNAME=$(uname -n)
HOSTNAME=${HOSTNAME%%.*}

if [[ $HOSTNAME == "soft-dev13" ]]; then
    if [[ "$DISPLAY" != "" ]]; then
        multimedia_keys
    fi
fi

function remotex
{
    xprop -root -remove _XKB_RULES_NAMES
}

