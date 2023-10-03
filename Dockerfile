FROM debian:bullseye

MAINTAINER Chandra Lefta <lefta.chandra@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get install -y iproute2 dumb-init \
                        isc-dhcp-server
RUN apt clean 

RUN groupadd -r dhcpd && useradd -r --create-home -g dhcpd dhcpd

ARG DHCP_PROTO=4
ENV DHCP_PROTOCOL=$DHCP_PROTO

ARG DHCPD_CONF_A
ENV DHCPD_CONF=$DHCPD_CONF_A

ARG DHCP_LEASES_A
ENV DHCP_LEASES=$DHCP_LEASES_A

ADD dhcpd.sh /dhcpd.sh
RUN chmod +x /dhcpd.sh

ENTRYPOINT ["/dhcpd.sh"]
CMD ["eth0"]