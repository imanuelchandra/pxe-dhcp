AUTHOR?=imanuelchandra
REPOSITORY?=pxe-dhcp

.PHONY: build
build_pxe_dhcp:
	docker build -t ${AUTHOR}/${REPOSITORY}:${ISC_DHCP_SERVER_VERSION}  . \
			--build-arg DHCP_PROTO=${DHCP_PROTOCOL} \
			--build-arg DHCP_PREFIX_PATH=${DHCP_PREFIX} \
			--build-arg DHCP_CONF_FILE=${DHCP_CONF} \
			--build-arg DHCP_LEASES_PREFIX_PATH=${DHCP_LEASES_PREFIX} \
			--build-arg DHCP_LEASES_FILE=${DHCP_LEASES} \
			--progress=plain \
			--no-cache
	@echo
	@echo "Build finished. Docker image name: \"${AUTHOR}/${REPOSITORY}:${ISC_DHCP_SERVER_VERSION}\"."

.PHONY: run
run_pxe_dhcp:
	docker run -it --rm --init -e DHCP_PROTOCOL=${DHCP_PROTOCOL} --net host \
			-v ./config:${DHCP_PREFIX} \
			-v ./leases:${DHCP_LEASES_PREFIX} \
			${AUTHOR}/${REPOSITORY}:${ISC_DHCP_SERVER_VERSION} eth0