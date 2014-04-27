#!/usr/bin/env bash
# Get infos from http://www.gaisma.com/

curl -s http://www.gaisma.com/en/location/"${1:-berlin}".html | scrape -be 'table.sun-data' | w3m -dump -T text/html | head