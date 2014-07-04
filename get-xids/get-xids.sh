#!/usr/bin/env bash

# Fastest way to get x window ids?

read -r _ _ _ _ xids < <(xprop -root _NET_CLIENT_LIST) && printf '%s\n' ${xids//,/}
