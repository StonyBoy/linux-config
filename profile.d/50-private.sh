#! /bin/bash
# -*-sh-*-
# .bash_profile
# Time-stamp: <23-may-18 21:24>
# Settings for all interactive shells

# Debugging
# set -x

export PATH=~/scripts:~/.local/bin:~/bin:/usr/local/bin:$PATH
export PAGER='less -s'

# Powerline provides advanced shell and GIT status
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

# Avoid rvmsudo complaints
export rvmsudo_secure_path=1

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Add Rusts Cargo to path if present
if [[ -d ~/.cargo/bin ]]; then
    export PATH="$PATH:$HOME/.cargo/bin"
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

# setdk_default

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
