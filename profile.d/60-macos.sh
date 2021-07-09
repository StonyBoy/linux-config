#! /bin/bash
# -*-sh-*-

pathappend ~/scripts ~/.local/bin ~/bin /usr/local/bin /usr/local/sbin

# set -x

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

function brew_update()
{
    brew upgrade $(brew outdated)
}

[ -d /usr/local/opt/ruby/bin ] && pathappend /usr/local/opt/ruby/bin

export BASH_SILENCE_DEPRECATION_WARNING=1

function mount_efi()
{
    sudo diskutil mount MACOS_EFI
}

