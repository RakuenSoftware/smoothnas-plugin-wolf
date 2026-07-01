# smoothnas-plugin-wolf

SmoothNAS plugin manifests for [Games-on-Whales Wolf](https://github.com/games-on-whales/wolf), a game streaming host for Moonlight clients.

Wolf is a different shape from the llama.cpp and gh-runner reference plugins: the Wolf container is a control plane that starts per-session application containers on demand. This repo keeps that shape and uses the SmoothNAS plugin protocol rather than baking a static game container list into the manifest.

## Variants

| Manifest | GPU profile | Use when |
|----------|-------------|----------|
| `smoothnas-plugin.yaml` | `gpu-nvidia` | Host has an NVIDIA GPU |
| `smoothnas-plugin-amd.yaml` | `gpu-amd` | Host has an AMD GPU |
| `smoothnas-plugin-intel.yaml` | `gpu-intel` | Host has an Intel iGPU |


## Compose-native variants (plugins-11)

SmoothNAS plugins can now be installed as docker-compose projects directly (tierd
drives `docker compose` against LXC2Docker). `deploy/compose/` holds compose-native
equivalents of the three manifests:

| Compose file | GPU |
|--------------|-----|
| `deploy/compose/wolf.compose.yaml` | NVIDIA (CDI via `deploy.resources`) |
| `deploy/compose/wolf-amd.compose.yaml` | AMD (`/dev/dri`) |
| `deploy/compose/wolf-intel.compose.yaml` | Intel (`/dev/dri`) |

The `wolf-runtime` profile maps to standard compose that LXC2Docker honors:
`devices:` (uinput/uhid + GPU render node, bound with auto cgroup-allow),
`device_cgroup_rules:` (the exact allows the profile set), `cap_add:`, and plain
host bind mounts for the runtime socket + udev. State lives on a smoothfs SSD tier
via `x-smoothnas`; set `tier:` to your pool. Wolf still launches per-session app
containers on demand through the mounted socket — those are pulled on first use
(the manifest's `containerRefs` pre-pull has no compose analogue). See the SmoothNAS
`docs/compose-plugins.md` authoring guide.

All variants use the same image: `ghcr.io/rakuensoftware/smoothnas-plugin-wolf:VERSION`. The release workflow builds that image from upstream `ghcr.io/games-on-whales/wolf:stable`, pins the pushed digest, and attaches digest-pinned manifests to each GitHub release.

## Protocol Requirements

Wolf needs two SmoothNAS plugin protocol features beyond a plain HTTP service:

1. SmoothNAS must provide the `wolf-runtime` plugin profile. Current SmoothNAS builds include it as a built-in profile; older builds can sideload `profiles/wolf-runtime.yaml`. It mounts `/run/smoothnas-runtime/docker.sock` into the Wolf container as `/var/run/docker.sock`, passes input and udev devices, and grants the capabilities Wolf needs for virtual input and per-session application containers.
2. `ports[].hostExpose: true` must publish Wolf's Moonlight ports directly on the SmoothNAS host. The nginx `/plugins/<name>/` proxy path is HTTP-only and is not sufficient for Moonlight RTSP/RTP traffic.

The manifests intentionally omit `ui.embed`: Wolf UI is launched from Moonlight as a streamed application, not as a browser iframe in the SmoothNAS UI.

## Operator Workflow

On older SmoothNAS builds, install the runtime profile on the host:

```sh
sudo install -m 0644 profiles/wolf-runtime.yaml /etc/smoothnas/plugin-profiles.d/wolf-runtime.yaml
sudo systemctl restart tierd
```

Current SmoothNAS builds show one Wolf card in the plugin catalog and already carry the required runtime/GPU profiles. Select the host GPU during install; SmoothNAS chooses the matching NVIDIA, AMD, or Intel manifest, applies the corresponding GPU profile, and pre-fills the render node when the selected GPU uses `/dev/dri`. Pick an SSD-backed tier for the `state` volume, then start the plugin. Wolf stores config, TLS material, paired clients, app profiles, and app state under:

```text
/mnt/<tier>/.plugins/wolf/state/
```

The plugin also mounts a flat runtime volume at `/run/user/wolf` for Wolf sockets used by per-session containers.

`WOLF_IMAGE_TAG` defaults to `fedora-43` and controls the Games-on-Whales app images seeded into Wolf's `config.toml` plus the default PulseAudio helper image. Change it during install or later from the SmoothNAS plugin config to move the default app images to another tag. Set `WOLF_PULSE_IMAGE` only when you need to override the full PulseAudio image reference.

## Exposed Ports

Wolf expects the standard Moonlight ports to be reachable directly:

| Name | Port | Protocol |
|------|------|----------|
| HTTPS | 47984 | TCP |
| HTTP | 47989 | TCP |
| Control | 47999 | UDP |
| RTSP | 48010 | TCP |
| Video | 48100 | UDP |
| Audio | 48200 | UDP |

If Moonlight discovery does not see the host through mDNS, connect manually from Moonlight. For hosts that need Wolf to advertise a specific address, add a non-empty `WOLF_INTERNAL_IP` config/env override before installing the manifest.

## Current Caveat

These manifests validate against the SmoothNAS v1 schema. Full production use still depends on live-host verification that LXC2Docker handles the Docker API options Wolf passes when it creates application containers.

## Local Development

```sh
docker buildx build -t smoothnas-plugin-wolf:dev .
```

To sideload a dev image into a SmoothNAS test host, edit the chosen manifest's `artifact.image` to your local tag and install it through the SmoothNAS plugin wizard or `tierd-cli plugin install`.

## Release Flow

`.github/workflows/release.yml` runs on tag push (`v*`):

1. Builds and pushes `ghcr.io/rakuensoftware/smoothnas-plugin-wolf:VERSION`.
2. Reads the pushed manifest-list digest from buildx.
3. Rewrites all plugin manifests to `image: ...:VERSION@sha256:...`.
4. Attaches the three manifests, `wolf-runtime-profile.yaml`, and `index.json` to the GitHub release.

`release-please` owns version bumps for the manifests.

## License

Add a LICENSE file at publish time. This repo only contains SmoothNAS packaging. Upstream Wolf and its image layers carry their own license terms.
