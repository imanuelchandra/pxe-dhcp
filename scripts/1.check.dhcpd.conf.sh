#!/bin/bash

if [ ! -r "$DHCPD_CONF" ]; then
    echo "Please ensure '$DHCPD_CONF' exists and is readable."
    exit 1
fi