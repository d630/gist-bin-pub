#!/usr/bin/env bash

get_xids.sh | xwinpp print -I - --visible -P 0 | xwinreg -I - -L 1,1,maximize,alias:0,east -L 2,max,horizontal,alias:0,west
