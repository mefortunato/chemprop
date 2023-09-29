FROM python:3.11-slim

ARG PLATFORM cpu

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements/requirements.${PLATFORM}.lock,target=requirements.${PLATFORM}.lock \
    python -m pip install -U pip && \
    python -m pip install -U \
        --extra-index-url https://download.pytorch.org/whl/${PLATFORM} \
        -r requirements.${PLATFORM}.lock

COPY . /src/chemprop

RUN python -m pip install /src/chemprop && \
    rm -r /src/chemprop

ENV DGLBACKEND=pytorch
