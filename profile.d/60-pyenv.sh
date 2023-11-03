#! /bin/bash
# -*-sh-*-
# Setup pyenv for multiple python versions

if [ -e /usr/bin/pyenv ]; then
    pathprepend $PYENV_ROOT
    pathprepend /$(pyenv root)/shims
    export PYENV_ROOT="$HOME/.pyenv"
    eval "$(pyenv init -)"
fi
