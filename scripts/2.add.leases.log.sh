#!/bin/bash

leases_log="/log/leases"

if [ ! -d "$leases_log" ]; then 
    echo "Please ensure '$leases_log' directory exists and is readable."
    exit 1
fi

chown dhcpd:dhcpd "$leases_log"

[ -e "$DHCP_LEASES" ] || touch "$DHCP_LEASES"

chown dhcpd:dhcpd "$DHCP_LEASES"
if [ -e "$DHCP_LEASES~" ]; then
    chown dhcpd:dhcpd "$DHCP_LEASES~"
fi