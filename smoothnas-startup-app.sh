#!/bin/bash
set -euo pipefail

: "${HOST_APPS_STATE_FOLDER:=/etc/wolf}"
export HOST_APPS_STATE_FOLDER

: "${WOLF_CFG_FOLDER:=$HOST_APPS_STATE_FOLDER/cfg}"
mkdir -p "$WOLF_CFG_FOLDER"
export WOLF_CFG_FOLDER

: "${WOLF_CFG_FILE:=$WOLF_CFG_FOLDER/config.toml}"
: "${WOLF_PRIVATE_KEY_FILE:=$WOLF_CFG_FOLDER/key.pem}"
: "${WOLF_PRIVATE_CERT_FILE:=$WOLF_CFG_FOLDER/cert.pem}"
export WOLF_CFG_FILE WOLF_PRIVATE_KEY_FILE WOLF_PRIVATE_CERT_FILE

: "${WOLF_RENDER_NODE:=/dev/dri/renderD128}"
: "${WOLF_ENCODER_NODE:=$WOLF_RENDER_NODE}"
: "${GST_GL_DRM_DEVICE:=$WOLF_ENCODER_NODE}"
export WOLF_RENDER_NODE WOLF_ENCODER_NODE GST_GL_DRM_DEVICE

: "${WOLF_IMAGE_TAG:=fedora-43}"
if [[ ! "$WOLF_IMAGE_TAG" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "Invalid WOLF_IMAGE_TAG: $WOLF_IMAGE_TAG" >&2
  exit 1
fi
export WOLF_IMAGE_TAG

if [[ -z "${WOLF_PULSE_IMAGE:-}" ]]; then
  export WOLF_PULSE_IMAGE="ghcr.io/games-on-whales/pulseaudio:$WOLF_IMAGE_TAG"
fi

if [[ ! -f "$WOLF_CFG_FILE" ]]; then
  {
    echo "# A unique identifier for this host"
    echo "uuid = \"$(cat /proc/sys/kernel/random/uuid)\""
    cat /opt/smoothnas/default-config.toml
  } > "$WOLF_CFG_FILE"
fi

sed -i -E \
  "s#(image[[:space:]]*=[[:space:]]*['\"]ghcr\\.io/games-on-whales/(firefox|retroarch|steam|pegasus|lutris|prismlauncher|xfce|es-de|kodi):)[^'\"]+(['\"])#\\1${WOLF_IMAGE_TAG}\\3#g" \
  "$WOLF_CFG_FILE"

: "${WOLF_DOCKER_FAKE_UDEV_PATH:=$HOST_APPS_STATE_FOLDER/fake-udev}"
export WOLF_DOCKER_FAKE_UDEV_PATH
cp /wolf/fake-udev "$WOLF_DOCKER_FAKE_UDEV_PATH"

exec /wolf/wolf
