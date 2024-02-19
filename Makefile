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

pip-compile:
	@python -m piptools compile --output-file=requirements/requirements.lock pyproject.toml
	@grep torch== requirements/requirements.lock > requirements/requirements.torch
	@grep torch-scatter== requirements/requirements.lock > requirements/requirements.torch-scatter


build:
	@docker build \
		-t $(REGISTRY):$(VERSION) \
		-f docker/Dockerfile \
		.

build-base:
	@docker build \
		-t $(REGISTRY):$(VERSION)-base \
		-f docker/Dockerfile \
		--target base \
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
		-v $(shell pwd)/example.py:/project/example.py \
		-v $(shell pwd)/examples:/project/examples \
		-v $(shell pwd)/tests:/project/tests \
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