#!/bin/bash
# Steen Hegelund
# Time-Stamp: 2024-Jan-03 18:36
# vim: set ts=4 sw=4 sts=4 tw=120 cc=120 et ft=sh :

while true ; do
    printf '{"text": "%s", "class": "custom-uptime", "tooltip": "Computer uptime in Days>Hours>Minutes"}\n' $(~/scripts/strict_uptime)
    sleep 60
done
