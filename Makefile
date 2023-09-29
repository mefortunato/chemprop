REGISTRY ?= ghcr.io/mefortunato/chemprop
VERSION ?= $(shell python setup.py --version)

PLATFORM ?= cpu

default: build

pip-lock:
	@docker build \
		--build-arg PLATFORM=$(PLATFORM) \
		-t $(REGISTRY):$(VERSION)-$(PLATFORM)-lock \
		-f docker/Dockerfile.lock \
		.
	@docker run -it --rm \
		$(REGISTRY):$(VERSION)-$(PLATFORM)-lock \
			> requirements/requirements.$(PLATFORM).lock
	

build:
	@docker build \
		--build-arg=PLATFORM=$(PLATFORM) \
		-t $(REGISTRY):$(VERSION)-$(PLATFORM) \
		-f docker/Dockerfile \
		.

build-base:
	@docker build \
		--build-arg=PLATFORM=$(PLATFORM) \
		-t $(REGISTRY):$(VERSION)-$(PLATFORM)-base \
		-f docker/Dockerfile.base \
		.

build-prod:
	@docker build \
		--build-arg=PLATFORM=$(PLATFORM) \
		-t $(REGISTRY):$(VERSION)-$(PLATFORM) \
		-f docker/Dockerfile.prod \
		.

push:
	@docker push $(REGISTRY):$(VERSION)-$(PLATFORM)

pull:
	@docker pull $(REGISTRY):$(VERSION)-$(PLATFORM)

debug:
	@docker run -it --rm \
		-v $(shell pwd)/chemprop:/usr/local/lib/python3.11/site-packages/chemprop \
		$(VOLUMES) \
		-w /project \
		--entrypoint bash \
		$(REGISTRY):$(VERSION)-$(PLATFORM)

run:
	@docker run -it --rm \
		$(VOLUMES) \
		-w /project \
		--entrypoint bash \
		$(REGISTRY):$(VERSION)-$(PLATFORM)

