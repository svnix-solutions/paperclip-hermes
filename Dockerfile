# syntax=docker/dockerfile:1.7
#
# Paperclip with Hermes Agent CLI baked in, for use with the
# hermes-paperclip-adapter installed at runtime via /api/adapters/install.
#
# Build:   docker build -t paperclip-hermes .
# Pin:     PAPERCLIP_TAG=sha-3e6610f docker build --build-arg PAPERCLIP_TAG ...

ARG PAPERCLIP_TAG=sha-3e6610f
ARG HERMES_VERSION=
ARG WITH_BROWSER_TOOLSET=0

FROM ghcr.io/paperclipai/paperclip:${PAPERCLIP_TAG}

USER root

ARG HERMES_VERSION
ARG WITH_BROWSER_TOOLSET

RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv \
      ripgrep ffmpeg git \
      gcc python3-dev libffi-dev ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --break-system-packages \
      "hermes-agent${HERMES_VERSION:+==$HERMES_VERSION}[all]"

RUN if [ "$WITH_BROWSER_TOOLSET" = "1" ]; then \
      npx --yes playwright install --with-deps chromium ; \
    fi

ENV HERMES_HOME=/paperclip/.hermes
RUN mkdir -p /paperclip/.hermes && chown -R node:node /paperclip

USER node