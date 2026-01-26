#! /bin/bash
# -*-sh-*-

# Debugging
# set -x

alias a=alias
alias h=history
alias ls="ls -G"
alias ll='ls -la'
alias pse='pstree -g 3 -w -U'
alias psu='pstree -g 3 -w -u $USER'
alias sudo='sudo '
alias cls='clear'
alias vi=vim
alias home='env | grep --text HOME'
alias user='env | grep --text USER'
alias path='env | grep --text PATH'

alias bcp='bcompare'
alias cf='clang-format -i'

pathappend ~/scripts
pathprepend /usr/local/sbin

export PAGER='less -s'
export PYTHONSTARTUP=~/scripts/python.init.py

# fzf shell integration
eval "$(fzf --bash)"

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

function brew_update()
{
    brew upgrade $(brew outdated)
}

export BASH_SILENCE_DEPRECATION_WARNING=1

function mount_efi()
{
    sudo diskutil mount MACOS_EFI
}
