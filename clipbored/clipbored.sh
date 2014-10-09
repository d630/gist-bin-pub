#! /usr/bin/env bash

# clipboard manager (dmenu) for clipbored (https://github.com/trapd00r/clipbored)

declare xsels=${X_XDG_LIB_DIR}/clipbored/clips

printf -v xsels '%s' "$(tac "$xsels" | sed '/^$/d' | menu.sh "dmenu2" ">")"
printf "$xsels" | xsel -ib
