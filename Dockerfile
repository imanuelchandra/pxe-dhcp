FROM debian:bullseye

MAINTAINER Chandra Lefta <lefta.chandra@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive


RUN groupadd -r dhcpd && useradd -r --create-home -g dhcpd dhcpd

RUN apt-get -y update
RUN apt-get install -y iproute2 dumb-init isc-dhcp-server
RUN apt clean 

ARG DHCP_PROTO=4
ENV DHCP_PROTOCOL=$DHCP_PROTO

ARG DHCP_PREFIX_PATH=/config
ENV DHCP_PREFIX=$DHCP_PREFIX_PATH

ARG DHCP_LEASES_PREFIX_PATH=/leases
ENV DHCP_LEASES_PREFIX=$DHCP_LEASES_PREFIX_PATH

ARG DHCP_LEASES_FILE=/leases/dhcpd.leases
ENV DHCP_LEASES=$DHCP_LEASES_FILE

ARG DHCP_CONF_FILE=/config/dhcpd.conf
ENV DHCP_CONF=$DHCP_CONF_FILE

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["eth0"]