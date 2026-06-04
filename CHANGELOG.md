# Changelog

## [0.3.0](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/compare/v0.2.3...v0.3.0) (2026-06-04)


### Features

* **manifest:** migrate smoothnas-plugin-amd.yaml to compose-services schema ([0a7d888](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/0a7d88818e80ca94afbc2f88305f10a4dc4be5c5))
* **manifest:** migrate smoothnas-plugin-intel.yaml to compose-services schema ([263b33b](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/263b33bd27659fe4c83da82a7d2c38023d801f4b))
* **manifest:** migrate smoothnas-plugin.yaml to compose-services schema ([455562f](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/455562f2a50c4bc71bb6e8a6c1fe651711b2f218))
* **manifest:** migrate to compose-services schema ([c44625b](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/c44625b61cca75beb6bbf3995e88c3e7d6b24bab))

## [0.2.3](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/compare/v0.2.2...v0.2.3) (2026-06-04)


### Bug Fixes

* **wolf-den:** add entrypoint wrapper that backgrounds Wolf Den then execs Wolf ([2a8b7d9](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/2a8b7d9422754a61b6f0e1d1abde3f73f4c945c3))
* **wolf-den:** launch via entrypoint wrapper, not s6 ([31a1984](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/31a198438b00f38e60ea369417d2cac5ea499113))
* **wolf-den:** remove dead /etc/services.d unit (no s6 in base image) ([c0dd553](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/c0dd55310901010334b974b5d7e1fdaec353cdf4))
* **wolf-den:** start via entrypoint wrapper, not a dead s6 unit ([3f988fd](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/3f988fd592f895ba51cb0c9b1db0594d008f273f))
* **wolf-den:** start Wolf Den from an entrypoint wrapper instead of a dead s6 unit ([b32c156](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/b32c1569f3278afd8b6ce3f21f3c52568bda5446))

## [0.2.2](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/compare/v0.2.1...v0.2.2) (2026-06-04)


### Bug Fixes

* **manifest:** restore the Wolf Den port (8080) lost in the merge ([0e599f7](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/0e599f764dcf951ca541228e9fb7ab5a02e914b5))
* **manifest:** restore the Wolf Den port (8080) lost in the merge ([f4dbe94](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/f4dbe94a5904bb7823ee2ed5d75ed49e1f53e7ce))
* **manifest:** restore the Wolf Den port (8080) lost in the merge ([8b58e90](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/8b58e90cf7adc9c777dd5e8f3523ad0037a4e5ac))
* **manifest:** restore the Wolf Den port (8080) lost in the merge ([5d92041](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/5d92041ec3cac6a2ac09b3fe74e23c9c4b3e6ae5))

## [0.2.1](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/compare/v0.2.0...v0.2.1) (2026-06-04)


### Bug Fixes

* **runtime:** identity-map XDG_RUNTIME_DIR so sibling mounts resolve ([#5](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/issues/5)) ([bcf1ee0](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/bcf1ee02b2d9f71b4ce7f566ea35a2fb6dc42234))

## [0.2.0](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/compare/v0.1.0...v0.2.0) (2026-05-18)


### Features

* configure Wolf app image tag ([30a8d01](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/30a8d01a6cd2471580146e498be85af1461cf52b))
* configure Wolf app image tag ([4a2d984](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/4a2d984aa29c3f024290372be97aa894c968301d))
* select Wolf GPU during install ([1f34aa4](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/1f34aa449e84f020e0881afc0b4acef1ebb28f48))
* select Wolf GPU during install ([480190c](https://github.com/RakuenSoftware/smoothnas-plugin-wolf/commit/480190c0696894de60e110b840028a9cdf392671))
