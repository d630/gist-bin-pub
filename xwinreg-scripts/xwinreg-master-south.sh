#!/usr/bin/env bash

get-xids.sh | xwinpp print -I - --visible -P 0 | xwinreg -I - -L 1,1,maximize,alias:0,south -L 2,max,vertical,alias:0,north
