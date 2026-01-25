#! /bin/bash
# -*-sh-*-
# .bash_profile
# Time-stamp: 2026-Jan-25 16:33
# Settings for all interactive shells

# Debugging
# set -x


function jointime()
{
    NOW=$(date --rfc-3339=seconds)
    echo Join: $NOW  >> ~/.worklog/log.txt
}

function leavetime()
{
    NOW=$(date --rfc-3339=seconds)
    echo Leave: $NOW  >> ~/.worklog/log.txt
}

