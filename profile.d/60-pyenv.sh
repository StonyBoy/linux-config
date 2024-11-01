#! /bin/bash
# -*-sh-*-
# Setup pyenv for multiple python versions

if [ -e $HOME/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    pathprepend $PYENV_ROOT/bin
    pathprepend $(pyenv root)/shims
    eval "$(pyenv init -)"
fi
