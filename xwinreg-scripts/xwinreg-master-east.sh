#!/usr/bin/env bash

get-xids.sh | xwinpp print -I - --visible -P 0 | xwinreg -I - -L 1,1,maxi,alias:0,east -L 2,max,horiz,alias:0,west
