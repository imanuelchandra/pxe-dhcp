#!/bin/bash

set -uo pipefail

trap "stop; exit 0;" SIGTERM SIGINT

stop(){
    dhcpd=$(pidof dhcpd)
    kill -TERM $dhcpd > /dev/null 2>&1
    echo "Terminated."
    exit
}

init(){
    # declare directory required by this image in array
    declare -a dir_req=("/config" "/data" "/scripts" "/log")
 
    # loop through the array of directory list required by this image
    for i in "${dir_req[@]}"
    do
        # check for required directory, if it is does not exits, throw exit code 1
        if [ ! -d "$i" ]; then
            echo "Please ensure config, data, scripts, and log directory exists."
            exit 1
        fi

        # check for required directory, scripts
        # list the content of scripts directory, and pipe into IO
        # and execute the script
        if [ $i = "/scripts" ]; then
            cd $i
            for scripts in $(find . -type f -atime -1 -name '*.*' | sed 's_.*/__' | sort -n);
            do
                if [ -n "$scripts" ]; then

                    if [ -x  "$scripts" ]; then
                        chmod +x $scripts
                        ./$scripts
                    fi
                fi
            done;
        fi
    done

}

start(){
init

exec /usr/sbin/dhcpd -$DHCP_PROTOCOL -f -d --no-pid -cf "$DHCPD_CONF" -lf "$DHCP_LEASES" -user dhcpd -group dhcpd $IFACE

}

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
            
            start
        fi
    fi
else
    exec ${@}
fi