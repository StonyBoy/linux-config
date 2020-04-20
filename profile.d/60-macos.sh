#! /bin/bash
# -*-sh-*-

export PATH=~/scripts:~/.local/bin:~/bin:/usr/local/bin:/usr/local/sbin:$PATH

# set -x

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

function brew_update()
{
    brew upgrade $(brew outdated)
}

export ANDROID_SDK_ROOT=~/android-sdk
export PATH=~/android-sdk/emulator:~/android-sdk/tools/bin:~/android-sdk/platform-tools:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH
export BASH_SILENCE_DEPRECATION_WARNING=1

function mount_efi()
{
    sudo diskutil mount MACOS_EFI
}

