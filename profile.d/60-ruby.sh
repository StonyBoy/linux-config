#! /bin/bash
# -*-sh-*-
# Time-stamp: 2026-Sep-12 23:11
# Ruby / RVM

[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"
[ -d "$HOME/.rvm/bin" ] && pathappend "$HOME/.rvm/bin"

# Avoid rvmsudo complaints
export rvmsudo_secure_path=1
