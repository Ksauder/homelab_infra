#!/bin/bash

nmcli con add con-name "static-ens33" ifname ens33 type ethernet ip4 192.168.174.80/24 gw 192.168.174.2
nmcli con mod "static-ens33" ipv4.dns "192.168.174.2,8.8.8.8"
nmcli con up "static-ens33"