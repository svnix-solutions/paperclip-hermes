# syntax=docker/dockerfile:1.7
#
# Paperclip with Hermes Agent CLI baked in, for use with the
# built-in hermes_local adapter (Paperclip v2026.626.0+).
#
# Build:   docker build -t paperclip-hermes .
# Pin:     PAPERCLIP_TAG=2026.1012.0 docker build --build-arg PAPERCLIP_TAG ...

ARG PAPERCLIP_TAG=2026.1012.0
ARG HERMES_VERSION=
ARG WITH_BROWSER_TOOLSET=1

FROM ghcr.io/paperclipai/paperclip:${PAPERCLIP_TAG}

ARG HERMES_VERSION
ARG WITH_BROWSER_TOOLSET

RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip python3-venv \
      ripgrep ffmpeg git \
      gcc python3-dev libffi-dev ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Isolated venv: pip can't replace Debian-managed packages (e.g. packaging)
# pulled in by the base image.
RUN python3 -m venv /opt/hermes \
    && /opt/hermes/bin/pip install --no-cache-dir \
      "hermes-agent${HERMES_VERSION:+==$HERMES_VERSION}[all]" \
    && ln -s /opt/hermes/bin/hermes /usr/local/bin/hermes

RUN if [ "$WITH_BROWSER_TOOLSET" = "1" ]; then \
      npx --yes playwright install --with-deps chromium ; \
    fi

ENV HERMES_HOME=/paperclip/.hermes
RUN mkdir -p /paperclip/.hermes && chown -R node:node /paperclip