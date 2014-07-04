#! /usr/bin/env bash

# clipboard manager (dmenu) for clipbored (https://github.com/trapd00r/clipbored)

xsels=${XDG_DATA_HOME}/clipbored/clips
x_buffer=clipboard #primary, secondary, clipboard

tac "$xsels" | sed '/^$/d' | menu.sh "dmenu2" ">" | xclip -selection "$x_buffer" -i -l 0
