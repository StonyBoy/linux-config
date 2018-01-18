#! /bin/bash
# -*-sh-*-
# .bash_profile
# Time-stamp: <28-dec-17 21:09>
# Settings for all interactive shells

# Debugging
# set -x

export PATH=~/scripts:~/.local/bin:~/bin:/usr/local/bin:$PATH
export PAGER='less -s'

# Powerline provides avanced shell and GIT status
# Install with pip install powerline-status
# and pip install powerline-gitstatus
export XDG_CONFIG_HOME=~/.config
# if [[ -e ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh ]]; then
#     if [[ "${TERM}" == "xterm" || "${TERM}" == "xterm-256color" ]]; then
#         export POWERLINE_BASH_CONTINUATION=1
#         export POWERLINE_BASH_SELECT=1
#         source ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
#     fi
# fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Set core file size limit
ulimit -c unlimited

# Disable Capslock
# /usr/bin/setxkbmap -option "ctrl:nocaps"

# Capslock as Ctrl
# /usr/bin/setxkbmap -option "caps:ctrl_modifier"

# Keyboard mapping for keyboards without multimedia keys (PrintScreen, ScrollLock, Pause, F11, F12)
xmodmap -e "keycode 107 = XF86AudioLowerVolume XF86AudioLowerVolume XF86AudioLowerVolume XF86AudioLowerVolume"
xmodmap -e "keycode 78  = XF86AudioRaiseVolume XF86AudioRaiseVolume XF86AudioRaiseVolume XF86AudioRaiseVolume"
xmodmap -e "keycode 127 = XF86AudioPlay XF86AudioPlay XF86AudioPlay XF86AudioPlay"
xmodmap -e "keycode 95  = XF86AudioPrev XF86AudioPrev XF86AudioPrev XF86AudioPrev"
xmodmap -e "keycode 96  = XF86AudioNext XF86AudioNext XF86AudioNext XF86AudioNext"

# Global Command aliases

alias a=alias
alias h=history
alias cls='clear'
alias ll='ls -la'
alias vi=vim
alias home='env | grep --text HOME'
alias user='env | grep --text USER'
alias path='env | grep --text PATH'
alias pse='ps -o pid,user,args -eH'
alias psu='ps -o pid,user,args -u $USER -H'
alias psc='ps -o pid,user,args -H -C'

alias dm='displaymode'
alias bc='bcompare'
alias cf='clang-format -i'

# Functions

function finish 
{
    echo "Finish"
    sleep 10
}
# trap finish EXIT

function qtc()
{
    qtcreator -pid $(pgrep -of qtcreator) "$*"
}

function _complete_qtproj()
{
    COMPREPLY=( $(compgen -W "$(ls *.creator | sed -e 's/.creator//g')") )
    return 0
}

function qtproj()
{
    python3 ~/src/python/qtcreator_project/qtcreator_webstax_project.py $*
}
complete -F _complete_qtproj qtproj

function wsproj()
{
    make clang_complete
    python3 ~/src/python/qtcreator_project/qtcreator_webstax_project.py $(basename $(dirname $PWD))
}

function filtertext()
{
    if [[ $# > 0 ]]; then
        for fn in $*; do
            echo $1
            if [[ -e $1 ]]; then
                cat $1 | tr -d '\000-\011' | tr -d '\013-\037' | tr -d '\200-\377' > $1.filtered
                mv $1.filtered $1
            fi
            shift
        done
    fi
}

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
    x0vncserver -display :0 -Geometry 1920x1200 -SecurityTypes vncauth,tlsvnc -rfbauth ~/.vnc/passwd -rfbport 5900
}
complete -F _complete_start_vnc start_vnc

function show_ip()
{
    ip addr list wan | grep 'inet ' | grep -v '127.0.0.1' | cut -d" " -f6
}

function _complete_displaymode()
{
    COMPREPLY=( $( compgen -W "wide single show" -- ${COMP_WORDS[COMP_CWORD]} ) )
    return 0
}

function displaymode()
{
    local PRI=DVI-0
    local SEC=HDMI-0
    if [[ "$1" == "wide" ]]; then
        xrandr --display :0 --screen 0 --fb 3840x1200  --output ${SEC} --mode 1920x1080 --output ${PRI} --mode 1920x1200 --left-of ${SEC} --primary
    elif [[ "$1" == "single" ]]; then
        xrandr --display :0 --screen 0 --fb 1920x1200  --output ${PRI} --mode 1920x1200 --primary --output ${SEC} --off
    elif [[ "$1" == "show" ]]; then
        xrandr --display :0 | grep " connected" | cut -d" " -f1 
    else
        xrandr
    fi
}
complete -F _complete_displaymode displaymode dm

function jointime()
{
    NOW=$(date --rfc-3339=seconds)
    echo Join: $NOW  >> ~/.worklog/log.txt
}

function leavetime()
{
    NOW=$(date --rfc-3339=seconds)
    echo Leave: $NOW  >> ~/.worklog/log.txt
}

