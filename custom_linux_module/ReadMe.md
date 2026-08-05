## Brief description of the repo:
This repo contains loadable linux kernel modules c code relevant Makefile and Kconfig files. the shell scripts build kernel modules, linux, busybox and rootfs. there is also a userspace application that interacts with kernel modules. it will take various faces but currently it works with uart character driver , later our goal is to develop netfilter.

## UART ioctl interface

`/dev/nfdev_module` supports the shared commands declared in
`nfdev_ioctl.h`:

- `NFDEV_IOCTL_UART_WRITE` sends `message.length` bytes from `message.data`.
- `NFDEV_IOCTL_UART_READ` receives up to `message.length` bytes into
  `message.data`. It blocks until UART data arrives unless the device was
  opened with `O_NONBLOCK`.

Both commands replace `message.length` with the number of bytes transferred.
The payload limit is `NFDEV_IOCTL_MAX_MESSAGE_SIZE` (256 bytes). The existing
`read()` and `write()` operations remain available for compatibility.

### manage_build.sh:
This script is used to build kernel, modules, busybox, userspace application and rootfs. It will also create a bootable image for qemu. The script will take care of all the dependencies and will build the required components in the correct order.

this is currently successful
