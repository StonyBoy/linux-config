# How to use the usdk keyboard layout

## Update the xkb configuration

- Copy the usdk file to /usr/share/X11/xkb/symbols directory
- Modify the files in /usr/share/X11/xkb/rules
-- base.lst: add the usdk entry under ! layout
-- evdev.lst: identical to base.lst
-- base.xml: add a layout section under <layoutList>
-- evdev.xml: identical to base.xml

# Select the new keyboard layout

setxkbmap -layout usdk -model pc105 -option "caps:escape" -rules evdev

# Change the default keyboard config when starting X

Edit /etc/X11/xorg.conf.d/00-keyboard.conf
and add a section

Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "usdk"
        Option "XkbModel" "pc105"
        Option "XkbOptions" "caps:escape"
EndSection


