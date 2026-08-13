# Linux Module Development (ARM64 + QEMU + BusyBox)

This project builds and tests a custom Linux kernel module in an ARM64 QEMU guest.

Main pieces:
- Linux kernel source (external dependency)
- BusyBox source (external dependency)
- Custom module in custom_linux_module/
- Userspace app in userspace/
- Build entry script: manage_build.sh

## 1) One-Time Prerequisites

Install required host tools (example for Ubuntu/Debian):

```bash
sudo apt update
sudo apt install -y \
  git make gcc-aarch64-linux-gnu qemu-system-arm \
  cpio gzip bc bison flex libssl-dev libelf-dev \
  picocom
```

Make the build script executable:

```bash
chmod +x manage_build.sh
```

## 2) External Dependencies (Linux + BusyBox)

Dependencies are now fetched on demand.

Check current dependency state:

```bash
./manage_build.sh deps_status
```

Fetch explicitly (manual mode):

```bash
./manage_build.sh deps_fetch
```

Default behavior:
- If linux/ or busybox/ is missing, required tasks auto-clone them.

Disable auto-fetch (strict/manual mode):

```bash
AUTO_FETCH_DEPS=0 ./manage_build.sh kernel_build
```

Optional: override dependency source or branch:

```bash
LINUX_REPO_REF=linux-6.6.y BUSYBOX_REPO_REF=1_36_stable ./manage_build.sh deps_fetch
```

## 3) Daily Workflows

### A. First full build + run

```bash
./manage_build.sh all
```

This does:
1. Kernel build
2. BusyBox build
3. Initramfs pack
4. QEMU run

### B. Rebuild only kernel (without cleaning)

```bash
./manage_build.sh kernel_build
```

### C. Build module and copy artifacts to host-share

```bash
./manage_build.sh module_build
```

This copies to $HOME/qemu-share:
- nfdev_module.ko
- user_app

### D. Repack filesystem and run

```bash
./manage_build.sh fs
./manage_build.sh qemu_run
```

### E. Run QEMU paused for GDB debugging

```bash
./manage_build.sh qemu_gdb_run
```

Then connect from another host terminal:

```bash
gdb-multiarch linux/vmlinux
(gdb) target remote :1234
```

## 4) QEMU File Share and UART

QEMU mounts host directory at:

- Host: $HOME/qemu-share
- Guest: /mnt/host

UART serial side terminal:
1. Start QEMU using ./manage_build.sh qemu_run
2. In QEMU logs, find the generated /dev/pts/X
3. Open another terminal and connect:

```bash
picocom -b 115200 /dev/pts/X
```

Replace X each run (it changes every boot).

## 5) Required Kernel Config Options

Make sure these are enabled in kernel config:

```text
CONFIG_MODULES=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MMIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_9P_FS=y
CONFIG_DEVTMPFS=y
```

Notes:
- 9P has options in both Networking and File Systems. Both are required.
- /dev is mounted via devtmpfs from init script.

## 6) Common Recovery Commands

If build is broken and you want a clean restart:

```bash
./manage_build.sh kernel_clean_build
./manage_build.sh busybox
./manage_build.sh fs
./manage_build.sh qemu_run
```

If you only need help menu:

```bash
./manage_build.sh help
```

## 7) Git Policy in This Repo

This repo is configured to keep source files and ignore generated outputs.

Primary source extensions kept:
- .c
- .h
- .sh
- .md

Ignored examples:
- linux/
- busybox/
- *.o, *.ko, *.cmd, *.mod.c, Module.symvers, modules.order

## 8) Recommended Repeatable Flow (Short Version)

```bash
./manage_build.sh module_build
./manage_build.sh fs
./manage_build.sh qemu_run
```

Inside guest:
1. Insert module
2. Run user app
3. Verify behavior from guest shell and UART terminal

## 9) Firewall Rule CLI (nfdev)

`/mnt/host/user_app` now works as a rule-management CLI for `/dev/nfdev`.

Examples:

```bash
/mnt/host/user_app add 10.0.2.0/24 any tcp any 22 drop
/mnt/host/user_app list
/mnt/host/user_app stats
/mnt/host/user_app enable 1
/mnt/host/user_app simulate 10.0.2.15 1.1.1.1 tcp 12345 22 60
/mnt/host/user_app remove 1
/mnt/host/user_app flush
/mnt/host/user_app save /mnt/host/rules.conf
/mnt/host/user_app load /mnt/host/rules.conf
```

Sample configuration file is available at `userspace/rules.conf`.

Supported actions:

- `accept`
- `drop`
- `inject` (mock action)

Supported protocols:

- `any`
- `tcp`
- `udp`
- `icmp`

