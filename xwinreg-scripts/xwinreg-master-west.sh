#!/usr/bin/env bash

get-xids.sh | xwinpp print -I - --visible -P 0 | xwinreg -I - -L 1,1,maximize,alias:0,west -L 2,max,horizontal,alias:0,east
