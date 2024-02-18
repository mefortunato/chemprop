REGISTRY ?= ghcr.io/mefortunato/chemprop
VERSION ?= $(shell bumpversion --dry-run --list --allow-dirty patch | grep current_version | sed -r s,"^.*=",,)

default: build

get-version:
	@bumpversion --dry-run --list --allow-dirty patch | grep current_version | sed -r s,"^.*=",,

bump-build:
	@bumpversion --allow-dirty build

bump-patch:
	@bumpversion --allow-dirty patch

bump-minor:
	@bumpversion --allow-dirty minor

bump-major:
	@bumpversion --allow-dirty major

bump-release:
	@bumpversion --allow-dirty release

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
		-t $(REGISTRY):$(VERSION) \
		-f docker/Dockerfile \
		.

build-base:
	@docker build \
		-t $(REGISTRY):$(VERSION)-base \
		-f docker/Dockerfile.base \
		.

build-prod:
	@docker build \
		-t $(REGISTRY):$(VERSION) \
		-f docker/Dockerfile.prod \
		.

push:
	@docker push $(REGISTRY):$(VERSION)

pull:
	@docker pull $(REGISTRY):$(VERSION)

debug:
	@docker run -it --rm \
		-v $(shell pwd)/chemprop:/usr/local/lib/python3.11/site-packages/chemprop \
		$(VOLUMES) \
		-w /project \
		--entrypoint bash \
		$(REGISTRY):$(VERSION)

run:
	@docker run -it --rm \
		$(VOLUMES) \
		-w /project \
		--entrypoint bash \
		$(REGISTRY):$(VERSION)