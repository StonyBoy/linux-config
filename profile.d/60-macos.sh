#! /bin/bash
# -*-sh-*-

export PATH=~/scripts:~/.local/bin:~/bin:/usr/local/bin:/usr/local/sbin:$PATH

# set -x

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

function brew_update()
{
    brew upgrade $(brew outdated)
}

export ANDROID_SDK_ROOT=~/android-sdk
export PATH=~/android-sdk/emulator:~/android-sdk/tools/bin:~/android-sdk/platform-tools:$PATH

