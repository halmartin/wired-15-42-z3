current_dir:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SHELL = /bin/sh
CURRENT_UID := $(shell id -u)
CURRENT_GID := $(shell id -g)

.PHONY: all

target: all

docker-image:
	docker build -t ubuntu1804-meraki-yocto -f Dockerfile --build-arg=UID=$(CURRENT_UID) --build-arg=GID=$(CURRENT_GID) .

docker-build:
	git submodule update
	docker run -it --rm -v $(current_dir):/src ubuntu1804-meraki-yocto  sudo -u meraki /src/build.sh

docker-build-dbg:
	docker run -it --rm -v $(current_dir):/src --entrypoint=/bin/bash ubuntu1804-meraki-yocto

all: docker-image docker-build

