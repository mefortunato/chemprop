FROM python:3.11 as base

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements,target=requirements \
    python -m pip install -U pip && \
    python -m pip install -U -r requirements/requirements.torch && \
    python -m pip install -U -r requirements/requirements.torch-scatter && \
    python -m pip install -U -r requirements/requirements.lock && \
    useradd -m -s /bin/bash chemprop

USER chemprop
WORKDIR /project


FROM base

USER root

COPY . /src/chemprop

RUN python -m pip install /src/chemprop && \
    rm -r /src/chemprop

USER chemprop
WORKDIR /project