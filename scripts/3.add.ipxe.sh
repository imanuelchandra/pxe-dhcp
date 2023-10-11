#!/bin/bash

IPXE_CONF=/config/dhcpd/ipxe/ipxe.conf
if [ ! -r "$IPXE_CONF" ]; then
    echo "Please ensure '$IPXE_CONF' exists and is readable."
    exit 1
else
    cp $IPXE_CONF /etc/dhcp/ipxe.conf
    echo "===================================\n"
    echo echo "/etc/dhcp/ipxe.conf....\n"
    echo "===================================\n"
    cat /etc/dhcp/ipxe.conf
    echo "\n"
fi
