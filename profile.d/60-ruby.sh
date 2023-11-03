#! /bin/bash
# -*-sh-*-
# Time-stamp: 2021-Jul-08 22:29
# Ruby configuration

# Debugging
# set -x


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
[ -d "~/.rvm/bin" ] && pathappend ~/.rvm/bin
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

