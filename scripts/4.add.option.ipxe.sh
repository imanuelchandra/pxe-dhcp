#!/bin/bash

IPXE_OPT_CONF=/config/dhcpd/ipxe/ipxe-option.conf
if [ ! -r "$IPXE_OPT_CONF" ]; then
    echo "Please ensure '$IPXE_OPT_CONF' exists and is readable."
    exit 1
else
    cp $IPXE_OPT_CONF /etc/dhcp/ipxe-option.conf
    echo "===================================\n"
    echo "/etc/dhcp/ipxe-option.conf....\n"
    echo "===================================\n"
    cat /etc/dhcp/ipxe-option.conf
    echo "\n"
fi
