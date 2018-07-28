#!/bin/bash
# Dependency checks
if [ ! $(command -v asciiquarium) ]; then
    echo "\"command not found: \"asciiquarium\"" >&2
    exit 1
fi
if [ ! $(command -v xfce4-terminal) ]; then
    echo "\"command not found: \"xfce4-terminal\"" >&2
    exit 1
fi
if [ ! $(command -v pyxtrlock) ]; then
    echo "\"command not found: \"pyxtrlock\"" >&2
    exit 1
fi

# Check for xrandr and run xterms
if [ $(command -v xrandr) ]; then
    OFFSETS=$(\xrandr | \grep -w connected | \awk '{split($0, line, " "); if (line[3] == "primary") { split(line[4], offsets, "+"); print "+"offsets[2]"+"offsets[3] } else { split(line[3], offsets, "+"); print "+"offsets[2]"+"offsets[3] }}')
    for o in $OFFSETS; do
        \xfce4-terminal --geometry 0x0$o --fullscreen --hide-menubar --hide-scrollbar --hide-borders -e asciiquarium &
    done
else
    xterm -fullscreen -e asciiquarium &
fi

# Store the current layout and set the default one
if [ $(command -v xkblayout-state) ]; then
    CURRENT=$(xkblayout-state print %c)
    xkblayout-state set 0
fi

#Lock screen and kill all the child processes on unlock
pyxtrlock && pkill -P $$

#Restore kb layout
if [ $(command -v xkblayout-state) ]; then
    xkblayout-state set $CURRENT
fi
