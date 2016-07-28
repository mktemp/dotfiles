#!/bin/bash

# Used in fcrontab, syncronizes the pacman database
# and together with .zshrc allows tracking the number of packages that can be upgraded now

num=$(/usr/bin/pacman -Syuwp | /usr/bin/grep ^http | /usr/bin/wc -l)
/usr/bin/echo $num > /usr/local/share/sysautoupdate/count
echo $num
