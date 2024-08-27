#!/bin/bash
# Steen Hegelund
# Time-Stamp: 2024-Aug-27 13:00

# the userid is: $(id -u)
# the swap process id is: pgrep sway$
# the output is: waymsg -t get_outputs
export $(cat ~/.swaysocket)
swaymsg -s $SWAYSOCKET output "DP-1" background ~/Pictures/Wallpapers/i3wallpaper.jpg fill
