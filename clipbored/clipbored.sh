#! /usr/bin/env bash

# clipboard manager (dmenu) for clipbored (https://github.com/trapd00r/clipbored)

declare xsels=${XDG_DATA_HOME}/clipbored/clips

printf -v xsels '%s' "$(tac "$xsels" | sed '/^$/d' | menu.sh "dmenu2" ">")"
printf "$xsels" | xsel -ib
