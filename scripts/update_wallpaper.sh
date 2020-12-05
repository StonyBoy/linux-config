#!/bin/bash
# Steen Hegelund
# Time-Stamp: 2020-Dec-04 23:55

# the userid is: $(id -u)
# the swap process id is: pgrep sway$
# the output is: waymsg -t get_outputs
export $(cat ~/.swaysocket)
swaymsg -s $SWAYSOCKET output "DP-2" background /opt/wallpapers/i3wallpaper.jpg fill
