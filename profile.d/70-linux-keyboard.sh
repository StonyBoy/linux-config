#! /bin/bash
# -*-sh-*-

function multimedia_keys()
{
    # Keyboard mapping for keyboards without multimedia keys (PrintScreen, ScrollLock, Pause, F11, F12)
    xmodmap -e "keycode 107 = XF86AudioLowerVolume XF86AudioLowerVolume XF86AudioLowerVolume XF86AudioLowerVolume"
    xmodmap -e "keycode 78  = XF86AudioRaiseVolume XF86AudioRaiseVolume XF86AudioRaiseVolume XF86AudioRaiseVolume"
    xmodmap -e "keycode 127 = XF86AudioPlay XF86AudioPlay XF86AudioPlay XF86AudioPlay"
    xmodmap -e "keycode 95  = XF86AudioPrev XF86AudioPrev XF86AudioPrev XF86AudioPrev"
    xmodmap -e "keycode 96  = XF86AudioNext XF86AudioNext XF86AudioNext XF86AudioNext"
}

function optional_multimedia_keys()
{
    local HOSTNAME=$(uname -n)
    local HOSTNAME=${HOSTNAME%%.*}

    if [[ $HOSTNAME == "soft-dev13" || $HOSTNAME == "mchp-dev-shegelun" ]]; then
        if [[ "$DISPLAY" != "" ]]; then
            multimedia_keys
        fi
    fi
}

function set_us_kbd() {
    # Keymaps are handled in /etc/X11/xorg.conf.d/00-keyboard.conf via localectl
    # Values? check: man xkeyboard-config

    if [[ ! -z $DISPLAY ]]; then
        # setxkbmap -layout usdk -model pc104 -option "caps:escape" -rules evdev
        setxkbmap -layout usdk -model pc105 -option "caps:escape" -rules evdev
    fi
}

function set_dk_kbd() {
    # Keymaps are handled in /etc/X11/xorg.conf.d/00-keyboard.conf via localectl
    # Values? check: man xkeyboard-config

    if [[ ! -z $DISPLAY ]]; then
        setxkbmap -layout dk -model pc105 -option "caps:escape" -variant "nodeadkeys" -rules evdev
    fi
}

function set_dk_xorg()
{
    set_dk_kbd xorg
}


function remotex
{
    xprop -root -remove _XKB_RULES_NAMES
}
