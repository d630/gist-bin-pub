#!/usr/bin/env bash

# cvlc via xterm

(exec xterm -name cvlc -e "cvlc $1;exit;bash" &)
