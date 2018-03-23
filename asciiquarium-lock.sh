#!/bin/bash
# Dependency checks
if [ ! $(command -v asciiquarium) ]; then
    echo "\"command not found: \"asciiquarium\"" >&2
    exit 1
fi
if [ ! $(command -v xterm) ]; then
    echo "\"command not found: \"xterm\"" >&2
    exit 1
fi
if [ ! $(command -v xtrlock) ]; then
    echo "\"command not found: \"xtrlock\"" >&2
    exit 1
fi

# Check for xrandr and run xterms
if [ $(command -v xrandr) ]; then
    OFFSETS=$(\xrandr | \grep -w connected | awk '{split($0, line, " "); if (line[3] == "primary") { split(line[4], offsets, "+"); print "+"offsets[2]"+"offsets[3] } else { split(line[3], offsets, "+"); print "+"offsets[2]"+"offsets[3] }}')
    for o in $OFFSETS; do
        xterm -geometry "0x0$o" -fullscreen -e asciiquarium &
    done
else
    xterm -fullscreen -e asciiquarium &
fi

# Backup kb layout
LAYOUTS=$(setxkbmap -query | grep layout | cut -d' ' -f6)
if [ $(command -v xkblayout-state) ]; then
    CURRENT=$(xkblayout-state print %c)
fi

#Set US layout
setxkbmap us

#Lock screen and kill all the child processes on unlock
xtrlock && pkill -P $$

#Restore kb layout
setxkbmap $LAYOUTS
if [ $(command -v xkblayout-state) ]; then
    xkblayout-state set $CURRENT
fi
