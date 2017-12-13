# -*-sh-*- 
# .bash_profile
# Time-stamp: <06-dec-17 21:09
# Settings for all interactive shells

# Debugging
# set -x

export PATH=~/scripts:~/.local/bin:~/bin:$PATH
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

# Set core file size limit
ulimit -c unlimited

# Disable Capslock
# /usr/bin/setxkbmap -option "ctrl:nocaps"

# Capslock as Ctrl
# /usr/bin/setxkbmap -option "caps:ctrl_modifier"

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

function start_vnc()
{
    x0vncserver -display :0 -Geometry 1920x1200 -SecurityTypes vncauth,tlsvnc -rfbauth ~/.vnc/passwd -rfbport 5900
}
complete -F _complete_start_vnc start_vnc

function show_ip()
{
    ip addr list wan | grep 'inet ' | grep -v '127.0.0.1' | cut -d" " -f6
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

function gitpatchsha()
{
    git format-patch -M -C $1~1..$1
}
