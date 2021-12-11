#! /bin/bash
# -*-sh-*-

pathappend ~/scripts ~/.local/bin ~/bin /usr/local/bin /usr/local/sbin

# set -x

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

function brew_update()
{
    brew upgrade $(brew outdated)
}

export GEMVER=3.0.0
[ -d /usr/local/opt/ruby/bin ] && pathprepend /usr/local/opt/ruby/bin
[ -d /usr/local//lib/ruby/gems/${GEMVER}/bin ] && pathprepend /usr/local//lib/ruby/gems/${GEMVER}/bin

export BASH_SILENCE_DEPRECATION_WARNING=1

function mount_efi()
{
    sudo diskutil mount MACOS_EFI
}

