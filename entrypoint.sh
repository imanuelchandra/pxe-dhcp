#!/bin/bash


set -e 


if [ $# -eq 1 -a -n "$1" ]; then
    if ! which "$1" >/dev/null; then
       
        NEXT_WAIT_TIME=1
        until [ -e "/sys/class/net/$1" ] || [ $NEXT_WAIT_TIME -eq 4 ]; do
            sleep $(( NEXT_WAIT_TIME++ ))
            echo "Waiting for interface '$1' to become available... ${NEXT_WAIT_TIME}"
        done
        if [ -e "/sys/class/net/$1" ]; then
            IFACE="$1"

            container_id=$(grep docker /proc/self/cgroup | sort -n | head -n 1 | cut -d: -f3 | cut -d/ -f3)
            if perl -e '($id,$name)=@ARGV;$short=substr $id,0,length $name;exit 1 if $name ne $short;exit 0' $container_id $HOSTNAME; then
                echo "You must add the 'docker run' option '--net=host' if you want to provide DHCP service to the host network."
            fi

            if [ ! -r "$DHCP_CONF" ]; then
                echo "Please ensure '$DHCP_CONF' exists and is readable."
                exit 1
            fi
            
            if [ -d "$DHCP_LEASES_PREFIX" ]; then 
                chown dhcpd:dhcpd "$DHCP_LEASES_PREFIX"
            fi

            [ -e "$DHCP_LEASES" ] || touch "$DHCP_LEASES"
            chown dhcpd:dhcpd "$DHCP_LEASES"
            if [ -e "$DHCP_LEASES~" ]; then
                chown dhcpd:dhcpd "$DHCP_LEASES~"
            fi


            exec /usr/sbin/dhcpd -$DHCP_PROTOCOL -f -d --no-pid -cf "$DHCP_CONF" -lf "$DHCP_LEASES" -user dhcpd -group dhcpd $IFACE
        fi
    fi
else
    exec ${@}
fi