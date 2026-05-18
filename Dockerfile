# SmoothNAS plugin image for Games-on-Whales Wolf.
#
# This image intentionally stays thin: upstream Wolf already carries
# the server, default config bootstrap, and entrypoint. The SmoothNAS
# image pins the upstream base at release time and sets defaults that
# match the SmoothNAS plugin manifests.

ARG WOLF_BASE=ghcr.io/games-on-whales/wolf:stable
FROM ${WOLF_BASE}

ENV HOST_APPS_STATE_FOLDER=/etc/wolf \
    XDG_RUNTIME_DIR=/run/user/wolf \
    WOLF_DOCKER_SOCKET=/var/run/docker.sock \
    WOLF_IMAGE_TAG=fedora-43 \
    WOLF_PULSE_IMAGE=

COPY config/default-config.toml /opt/smoothnas/default-config.toml
COPY --chmod=755 smoothnas-startup-app.sh /opt/gow/startup-app.sh

LABEL org.opencontainers.image.source="https://github.com/RakuenSoftware/smoothnas-plugin-wolf"
LABEL org.opencontainers.image.description="SmoothNAS plugin image for Games-on-Whales Wolf"
