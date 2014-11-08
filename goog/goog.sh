#!/usr/bin/env bash

# goog QUERY... - search google
# http://chneukirchen.org/dotfiles/bin/goog

Q=$*
echo -e "$(curl -A Mozilla/4.0 -skLm 10 \
           http://www.google.com/search?nfpr=\&q="${Q// /+}" |
           grep -oP '\/url\?q=.+?&amp' | sed 's/\/url?q=//;s/&amp//;s/\%/\\x/g')"
