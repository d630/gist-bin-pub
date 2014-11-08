#!/bin/sh

# zombies - list all zombies and their parents to kill
# http://chneukirchen.org/dotfiles/bin/zombies

ps f -eo state,pid,ppid,comm | awk '
  { cmds[$2] = $NF }
  /^Z/ { print $(NF-1) "/" $2 " zombie child of " cmds[$3] "/" $3 }'
