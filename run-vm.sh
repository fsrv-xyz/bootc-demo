qemu-system-x86_64 \
  -accel kvm \
  -cpu host \
  -m 2G \
  -smp 4 \
  -nographic \
  -serial mon:stdio \
  disk.qcow2
