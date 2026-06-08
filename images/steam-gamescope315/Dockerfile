# GOW steam:fedora-43 app image with gamescope downgraded to a 3.15.x release.
#
# Why: gamescope 3.16.x regressed Wine/Proton input handling — Unity games that
# rely on Win32 raw input get NO keyboard or controller in-game under Wolf's
# nested gamescope, while SDL games are unaffected. Pinning gamescope back to the
# last 3.15.x restores input. The gow steam image installs gamescope from the
# Fedora 43 repo (3.16.x), so we rebuild the requested 3.15.x from source and
# overlay the binary + matching WSI Vulkan layer onto the stock image.
ARG STEAM_BASE=ghcr.io/games-on-whales/steam:fedora-43
ARG GAMESCOPE_VERSION=3.15.17

########################################################################
# Build gamescope from source in a matching Fedora 43 toolchain.
FROM fedora:43 AS gsbuild
ARG GAMESCOPE_VERSION
RUN set -eux; \
    dnf install -y dnf-plugins-core git meson ninja-build gcc gcc-c++ glslang cmake hwdata \
        xorg-x11-server-Xwayland xorg-x11-server-Xwayland-devel; \
    dnf builddep -y gamescope; \
    dnf clean all
RUN set -eux; \
    git clone --depth 1 --branch "${GAMESCOPE_VERSION}" --recurse-submodules \
        https://github.com/ValveSoftware/gamescope.git /src; \
    cd /src; \
    meson setup build --prefix=/usr \
        -Denable_openvr_support=false \
        -Dbenchmark=disabled; \
    ninja -C build; \
    DESTDIR=/out ninja -C build install; \
    echo "--- built files ---"; find /out -maxdepth 4 -type f | sort

########################################################################
# Overlay onto the stock gow steam image, replacing the 3.16.x gamescope.
FROM ${STEAM_BASE}
ARG GAMESCOPE_VERSION
# Keep the distro binary around for reference/rollback, then overlay 3.15.x.
RUN if [ -x /usr/bin/gamescope ]; then cp -a /usr/bin/gamescope /usr/bin/gamescope.fedora316 || true; fi
COPY --from=gsbuild /out/usr/ /usr/
RUN set -eux; \
    ldconfig || true; \
    echo "gamescope now: $(gamescope --version 2>&1 | head -1 || true)"
LABEL org.opencontainers.image.source="https://github.com/RakuenSoftware/smoothnas-plugin-wolf"
LABEL org.opencontainers.image.description="GOW steam:fedora-43 with gamescope ${GAMESCOPE_VERSION} (workaround for 3.16.x Wine raw-input regression)"
