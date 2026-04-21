#!/usr/bin/env bash
image="ghcr.io/fsrv-xyz/bootc-demo:latest"

truncate -s 4G disk.raw
loop_device=$(losetup --show -fP disk.raw)
trap 'losetup -d "$loop_device"' EXIT
podman run \
  --pull=always \
  --rm --privileged \
  --pid=host \
  -v /dev:/dev \
  -v ./:/project:Z \
  -v /var/lib/containers:/var/lib/containers \
  --security-opt label=type:unconfined_t \
  $image \
  bootc install to-disk --filesystem xfs --wipe "$loop_device"
qemu-img convert -O qcow2 disk.raw disk.qcow2 && rm disk.raw

