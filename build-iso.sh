#!/usr/bin/env bash

image="ghcr.io/fsrv-xyz/bootc-demo:main"

mkdir -p output
touch config.toml
podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
  --security-opt label=type:unconfined_t \
  -v ./config.toml:/config.toml:ro \
  -v ./output:/output \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --type iso \
  --rootfs ext4 \
  --use-librepo=True \
  $image
