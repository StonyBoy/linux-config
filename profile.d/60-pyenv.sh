#! /bin/bash
# -*-sh-*-
# Setup pyenv for multiple python versions

export PYENV_ROOT="$HOME/.pyenv"
[ -e /usr/bin/pyenv ] && pathprepend $PYENV_ROOT
eval "$(pyenv init -)"
