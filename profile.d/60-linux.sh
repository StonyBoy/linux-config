#! /bin/bash
# -*-sh-*-

# Debugging
# set -x

alias a=alias
alias h=history
alias ls="ls --color=tty"
alias ll='ls -la'
alias pse='ps -o pid,user,args -eH'
alias psu='ps -o pid,user,args -u $USER -H'
alias psc='ps -o pid,user,args -H -C'
alias pst="ps -AfH f"
alias pstl="ps -fH f -u `id -u`"
alias lsofi="lsof -i -n -P"
alias sudo='sudo '
alias du_sorted='du -abx | sort -n | gawk '\''{if(match($0, /^([[:digit:]]+)[\t ]+(.+)/, a)){ s = int(a[1]); n = a[2]; u = "B "; if(s >= 1024){s = s/1024; u = "KB";} if(s >= 1024){s = s/1024; u = "MB";} if(s >= 1024){s = s/1024; u = "GB";} if(s >= 1024){s = s/1024; u = "TB";} printf("%8.2f%s %s\n", s, u, n)}}'\'''
alias fzfp='fzf --preview="bat --style=full --color=always {}" --multi --bind "enter:execute(nvim {})" --bind "space:execute(nvim -O {+})"'
alias ncal='ncal -M -W 4 -w -y'
alias devs='ll /dev/ | rg ^l'
alias cls='clear'
alias vi=vim
alias home='env | grep --text HOME'
alias user='env | grep --text USER'
alias path='env | grep --text PATH'

alias bcp='bcompare'
alias cf='clang-format -i'

alias lsblk='lsblk --output NAME,FSTYPE,LABEL,SIZE,UUID,PARTUUID,MOUNTPOINT'
alias gdrive='rclone mount "GoogleDrive": ~/GoogleDrive &'
alias stopgdrive='pkill  -f "rclone.*GoogleDrive"'

pathappend ~/scripts
pathprepend /usr/local/sbin

export PAGER='less -s'
export PYTHONSTARTUP=~/scripts/python.init.py

# Avoid rvmsudo complaints
export rvmsudo_secure_path=1

# Set core file size limit
ulimit -c unlimited

# Powerline provides advanced shell and GIT status
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

# Functions

