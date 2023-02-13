#!/bin/bash

# TODO: make this work a little better

IFNAME="fillmein"
CONNAME="static1"
STATIC_IP="192.168.1.80/24"
GATEWAY_IP="192.168.1.1"
DNS_IP="192.168.1.1"



nmcli con add con-name "${CONNAME}" ifname "${IFNAME}" type ethernet ip4 "${STATIC_IP}" gw4 "${GATEWAY_IP}"
nmcli con mod "${CONNAME}" ipv4.dns "${DNS_IP}"
nmcli con up "${CONNAME}"
