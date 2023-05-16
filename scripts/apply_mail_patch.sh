#! /bin/bash
# Steen Hegelund
# Time-Stamp: 2023-May-16 14:51
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=sh :
#
# Args:
# 1: path to git linux repo
# 2: branch to sync

echo "Using $1"
cd $1
git checkout $2
git reset --hard origin/$2
git pull
b4 shazam
