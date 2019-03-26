#! /bin/bash
# -*-sh-*-

export PATH=~/scripts:~/.local/bin:~/bin:/usr/local/bin:$PATH

# set -x

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

function brew_update()
{
    brew upgrade $(brew outdated)
}

export ANDROID_SDK_ROOT=~/android-sdk
export PATH=~/android-sdk/emulator:~/android-sdk/tools/bin:~/android-sdk/platform-tools:$PATH
export HOMEBREW_GITHUB_API_TOKEN=ea94f01f5bd90925c1a28976725087b5c193dffa

