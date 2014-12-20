#!/usr/bin/env bash

get-xids.sh | xwinpp print --visible -P 0 | xwinreg -I - -L 1,max,grid-verti,alias:0,all
