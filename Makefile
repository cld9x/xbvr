GOLANG_CROSS_VERSION  ?= v1.17.5

SYSROOT_DIR     ?= sysroots
SYSROOT_ARCHIVE ?= sysroots.tar.bz2

.PHONY: sysroot-pack
sysroot-pack:
	@tar cf - $(SYSROOT_DIR) -P | pv -s $[$(du -sk $(SYSROOT_DIR) | awk '{print $1}') * 1024] | pbzip2 > $(SYSROOT_ARCHIVE)

.PHONY: sysroot-unpack
sysroot-unpack:
	@pv $(SYSROOT_ARCHIVE) | pbzip2 -cd | tar -xf -

.PHONY: release-dry-run-snapshot
release-dry-run-snapshot:
	@docker run \
		--rm \
		--privileged \
		-e CGO_ENABLED=1 \
		-e GITHUB_USER=${GITHUB_USER} \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v `pwd`:/go/src \
		-v `pwd`/sysroot:/sysroot \
		-w /go/src \
		ghcr.io/troian/golang-cross:${GOLANG_CROSS_VERSION} \
		--rm-dist --skip-validate --skip-publish --snapshot

.PHONY: release-dry-run
release-dry-run:
	@docker run \
		--rm \
		--privileged \
		-e CGO_ENABLED=1 \
		-e GITHUB_USER=${GITHUB_USER} \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v `pwd`:/go/src \
		-v `pwd`/sysroot:/sysroot \
		-w /go/src \
		ghcr.io/troian/golang-cross:${GOLANG_CROSS_VERSION} \
		--rm-dist --skip-validate --skip-publish

.PHONY: release-snapshot
release-snapshot:
	@if [ ! -f ".release-env" ]; then \
		echo "\033[91m.release-env is required for release\033[0m";\
		exit 1;\
	fi
	docker run \
		--rm \
		--privileged \
		-e CGO_ENABLED=1 \
		-e GITHUB_USER=${GITHUB_USER} \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		--env-file .release-env \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v `pwd`:/go/src \
		-v `pwd`/sysroot:/sysroot \
		-w /go/src \
		ghcr.io/troian/golang-cross:${GOLANG_CROSS_VERSION} \
		release --rm-dist --snapshot

.PHONY: release
release:
	@if [ ! -f ".release-env" ]; then \
		echo "\033[91m.release-env is required for release\033[0m";\
		exit 1;\
	fi
	docker run \
		--rm \
		--privileged \
		-e CGO_ENABLED=1 \
		-e GITHUB_USER=${GITHUB_USER} \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v `pwd`:/go/src \
		-v `pwd`/sysroot:/sysroot \
		-w /go/src \
		ghcr.io/troian/golang-cross:${GOLANG_CROSS_VERSION} \
		release --rm-dist
