IMAGE := tamarin-prover

.PHONY: build
build:
	podman build \
		-t \
		local/${IMAGE} .

.PHONY: run
run:
	podman run \
		-ti \
		--rm \
		-P \
		--security-opt label=disable \
		--net=host \
		--user=root \
		local/${IMAGE}

.PHONY: run_debug
run_debug:
	podman run \
		-ti \
		--rm \
		-P \
		--security-opt label=disable \
		--net=host \
		--entrypoint=/bin/sh \
		--user=root \
		local/${IMAGE}
