#! /bin/bash
# -*-sh-*-
# .bash_profile
# Time-stamp: <28-dec-17 21:09>
# Settings for all interactive shells

# Debugging
# set -x

# export PATH=~/scripts:~/.local/bin:~/bin:/usr/local/bin:$PATH
export PATH=~/scripts:~/.local/bin:~/bin:$PATH
export PAGER='less -s'

# Powerline provides avanced shell and GIT status
# Install with pip install powerline-status
# and pip install powerline-gitstatus
export XDG_CONFIG_HOME=~/.config
if [[ -e ~/scripts/powerline.sh ]]; then
    if [[ "${TERM}" == "xterm" || "${TERM}" == "xterm-256color" || "${TERM}" == "rxvt-unicode-256color" ]]; then
        export POWERLINE_BASH_CONTINUATION=1
        export POWERLINE_BASH_SELECT=1
        source ~/scripts/powerline.sh
    fi
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Avoid rvmsudo complaints
export rvmsudo_secure_path=1

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Add Rusts Cargo to path if present
if [[ -d ~/.cargo/bin ]]; then
    export PATH="$PATH:$HOME/.cargo/bin"
fi

if [[ $DISPLAY != "" ]]; then
    export PROMPT_COMMAND=prompt_command
fi

# Set core file size limit
ulimit -c unlimited

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
alias lsblk='lsblk --output NAME,FSTYPE,LABEL,UUID,PARTUUID,MOUNTPOINT'

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

function vsproj()
{
    python3 ~/src/python/vscode_workspace/vscode_workspace.py
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
    x0vncserver -display :0 -Geometry 2560x1440 -SecurityTypes vncauth,tlsvnc -rfbauth ~/.vnc/passwd -rfbport 5900
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

function title()
{
    PROMPT_COMMAND="echo -ne \"\e]0;$*\a\""
}

function prompt_command()
{
    CUR_NAME=$PWD
    TITLE_NAME=$CUR_NAME
    if [[ $CUR_NAME == $HOME ]]; then
        TITLE_NAME="Home"
    else
        elems=($(echo "${CUR_NAME}" | tr '/' '\n'))
        if [[ ${elems[1]} == $USER ]]; then
            if [[ ${elems[2]} == "src" ]]; then
                TITLE_NAME=${elems[2]}
                if [[ ${elems[3]} != "" ]]; then
                    TITLE_NAME=${elems[3]}
                    WEBSTAX_NAME=${TITLE_NAME##webstax2_}
                    if [[ ${WEBSTAX_NAME} != "" ]]; then
                        if [[ ${elems[3]} != ${elems[-1]} ]]; then
                            TITLE_NAME="${WEBSTAX_NAME} ${elems[-1]}"
                        else
                            TITLE_NAME=${WEBSTAX_NAME}
                        fi
                    fi
                fi
            else
                TITLE_NAME=${elems[-1]}
            fi
        fi
    fi
    echo -ne "\e]0;$TITLE_NAME\a"
}

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
    multimedia_keys
}

function setdk_xorg()
{
    setdk_default xorg
}

if [[ $DISPLAY != "" ]]; then
    setdk_default
fi

function set_clang()
{
    export CC=/usr/bin/clang
    export CXX=/usr/bin/clang++
}

function set_gcc()
{
    export CC=/usr/bin/gcc
    export CXX=/usr/bin/g++
}

function remotex
{
    xprop -root -remove _XKB_RULES_NAMES
}
