#!/usr/bin/env bash

# Show network connections

echo
ifconfig | awk /'inet Adresse/ {print $2}'
echo "IP-ISP: $(w3m -dump ddg.gg/?q=ip | grep '^Your IP address is')"
echo
ifconfig | awk /'Bcast/ {print $3}'
echo
ifconfig | awk /'inet Adresse/ {print $4}'
echo
sudo netstat -tapen
echo
lsof -i :1-10000
echo
