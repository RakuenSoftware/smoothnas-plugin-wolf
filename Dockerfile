# SmoothNAS plugin image for Games-on-Whales Wolf.
#
# This image intentionally stays thin: upstream Wolf already carries
# the server, default config bootstrap, and entrypoint. The SmoothNAS
# image pins the upstream base at release time and sets defaults that
# match the SmoothNAS plugin manifests.

ARG WOLF_BASE=ghcr.io/games-on-whales/wolf:stable
ARG WOLF_DEN_IMAGE=ghcr.io/games-on-whales/wolf-den:stable

FROM ${WOLF_DEN_IMAGE} AS wolfden

FROM ${WOLF_BASE}

ENV HOST_APPS_STATE_FOLDER=/etc/wolf \
    XDG_RUNTIME_DIR=/var/lib/smoothnas/plugins/wolf/runtime \
    WOLF_DOCKER_SOCKET=/var/run/docker.sock \
    WOLF_IMAGE_TAG=fedora-43 \
    WOLF_PULSE_IMAGE=

# --- Wolf Den (management UI on :8080) ------------------------------------
# SmoothNAS plugins are single-container, so bundle Wolf Den (WolfLeash)
# alongside Wolf. Pull the published app and the .NET runtime it was built
# against straight from the upstream wolf-den image (a dotnet/aspnet:9.0
# base). Upstream Wolf runs /wolf/wolf as PID 1 via /entrypoint.sh and ships
# no s6 supervisor, so Wolf Den cannot be an /etc/services.d unit (those are
# never executed here). Instead a wrapper entrypoint launches Wolf Den in the
# background and execs Wolf's real entrypoint, keeping Wolf as PID 1.
COPY --from=wolfden /app /opt/wolf-den
COPY --from=wolfden /usr/share/dotnet /usr/share/dotnet
RUN set -e; \
    ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet; \
    if ! command -v socat >/dev/null 2>&1; then \
        apt-get update; \
        apt-get install -y --no-install-recommends socat; \
        rm -rf /var/lib/apt/lists/*; \
    fi; \
    dotnet --info >/dev/null
COPY --chmod=755 wolf-den-launch.sh /opt/wolf-den/launch.sh
COPY --chmod=755 wolf-den-entrypoint.sh /opt/wolf-den/entrypoint.sh
ENTRYPOINT ["/opt/wolf-den/entrypoint.sh"]
EXPOSE 8080
# --------------------------------------------------------------------------

COPY config/default-config.toml /opt/smoothnas/default-config.toml
COPY --chmod=755 smoothnas-startup-app.sh /opt/gow/startup-app.sh

LABEL org.opencontainers.image.source="https://github.com/RakuenSoftware/smoothnas-plugin-wolf"
LABEL org.opencontainers.image.description="SmoothNAS plugin image for Games-on-Whales Wolf (+ Wolf Den UI on :8080)"
