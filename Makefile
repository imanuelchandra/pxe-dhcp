AUTHOR?=imanuelchandra
REPOSITORY?=pxe-dhcp

.PHONY: build
build_pxe_dhcp:
	docker build -t ${AUTHOR}/${REPOSITORY}:${PXE_DHCP_SERVER_VERSION}  . \
			--build-arg DHCP_PROTO=${DHCP_PROTOCOL} \
			--build-arg DHCPD_CONF_A=${DHCPD_CONF} \
			--build-arg DHCP_LEASES_A=${DHCP_LEASES} \
			--progress=plain \
			--no-cache
	@echo
	@echo "Build finished. Docker image name: \"${AUTHOR}/${REPOSITORY}:${PXE_DHCP_SERVER_VERSION}\"."

.PHONY: run
run_pxe_dhcp:
	docker run -it --rm --init \
			-e DHCP_PROTOCOL=${DHCP_PROTOCOL} \
			-e DHCPD_CONF=${DHCPD_CONF} \
			-e DHCP_LEASES=${DHCP_LEASES} \
			--net host \
			-v ./config:/config \
			-v ./log:/log \
			-v ./scripts:/scripts \
			${AUTHOR}/${REPOSITORY}:${PXE_DHCP_SERVER_VERSION} eth0