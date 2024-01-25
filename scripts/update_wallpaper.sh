#!/bin/bash
# Steen Hegelund
# Time-Stamp: 2024-Jan-24 14:47

# the userid is: $(id -u)
# the swap process id is: pgrep sway$
# the output is: waymsg -t get_outputs
export $(cat ~/.swaysocket)
swaymsg -s $SWAYSOCKET output "DP-1" background /opt/wallpapers/i3wallpaper.jpg fill
