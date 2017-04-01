# Setup the keyboard layout switch:
#exec setxkbmap -layout us,ru -option "grp:lwin_toggle" &
exec setxkbmap -layout us,ru -option "grp:caps_toggle" &

# Disable touchpad:
xinput --disable $(xinput --list | grep 'SynPS/2 Synaptics TouchPad' | sed 's/.*id=\([[:digit:]]\+\).*/\1/')
# synclient TouchpadOff=1

# Finally, initialize the window manager:
exec /usr/bin/i3
#exec startkde
