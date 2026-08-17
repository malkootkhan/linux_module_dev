# NFDEV Kernel Module

`/dev/nfdev` is a control plane for firewall rule management and packet filtering.
It supports both:

- in-tree static integration (`linux/drivers/misc/custom_linux_module`)
- out-of-tree module workflow (`custom_linux_module`)

## Kernel Module Lifecycle

- `nfdev_init()` registers UART backend and character device.
- `nfdev_chrdev_register()` creates `/dev/nfdev` and registers Netfilter hooks.
- `nfdev_exit()` unregisters device/hooks and releases UART resources.

All paths are cleaned on error and unload.

## Packet Processing Flow

Packet -> Netfilter hook -> Rule match -> Action

- Hook points: IPv4 `PRE_ROUTING` and `LOCAL_OUT`
- Match fields:
  - source/destination CIDR
  - source/destination port
  - protocol (`ANY`, `TCP`, `UDP`, `ICMP`)
  - optional input/output interface names
- Actions:
  - `ACCEPT` -> allow packet
  - `DROP` -> drop packet
  - `INJECT` -> mock action (counted, packet currently accepted)

## Shared UAPI (`nfdev_ioctl.h`)

Version and limits:

- `NFDEV_UAPI_VERSION`
- `NFDEV_MAX_RULES`
- `NFDEV_MAX_IFNAME_LEN`

Primary ioctls:

- `NFDEV_IOCTL_ADD_RULE` (`_IOWR`)
- `NFDEV_IOCTL_REMOVE_RULE` (`_IOWR`)
- `NFDEV_IOCTL_LIST_RULES` (`_IOWR`)
- `NFDEV_IOCTL_FLUSH_RULES` (`_IO`)
- `NFDEV_IOCTL_SET_FILTERING` (`_IOWR`)
- `NFDEV_IOCTL_GET_STATS` (`_IOWR`)
- `NFDEV_IOCTL_SIMULATE_PACKET` (`_IOWR`)

Compatibility UART ioctls (kept for legacy testing):

- `NFDEV_IOCTL_UART_WRITE`
- `NFDEV_IOCTL_UART_READ`

All userspace payloads are copied with `copy_from_user()` / `copy_to_user()` and validated.
Invalid command payloads, protocols, actions, CIDR masks, interface strings, and rule operations are rejected with kernel error codes.

## Concurrency and Safety

- Rule table and counters are protected with `spin_lock_irqsave`.
- Netfilter hook reads/writes shared state under lock.
- Rule list response is staged via `kvzalloc()` before copy-to-user.
- All device and hook resources are released on module unload.

## Build

Out-of-tree:

```bash
make -C custom_linux_module ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
```

In-tree (built-in path):

```bash
cd linux
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j"$(nproc)" Image
```

## KUnit Kernel Tests

`nfdev` KUnit coverage is implemented in `nfdev_kunit.c` and built as module object
`nfdev_kunit.o` (see `custom_linux_module/Makefile`).

### 1) Enable KUnit in kernel config

From kernel menuconfig:

```bash
cd linux
make ARCH=arm64 menuconfig
```

Enable KUnit support, then confirm `.config` contains at least:

```text
CONFIG_KUNIT=y
```

After saving config, rebuild the kernel.

### 2) Rebuild kernel and module

```bash
./manage_build.sh kernel_build
./manage_build.sh module_build
```

### 3) Test suite structure in `nfdev_kunit.c`

- Define test functions for rule validation and packet evaluation paths.
- Collect all test function entries in `struct kunit_case nfdev_test_cases[]`.
- Create `struct kunit_suite nfdev_test_suite` and assign `.test_cases = nfdev_test_cases`.
- Register suite with `kunit_test_suite(nfdev_test_suite)`.

This is the standard kernel KUnit pattern and is what the `nfdev` tests use.

### 4) Run in guest kernel

After booting the rebuilt kernel, insert the module and check kernel log:

```bash
insmod /mnt/host/nfdev_kunit.ko
dmesg | tail -n 200
```

Current status: suite loads and all defined test cases pass after build and module
insertion in the running kernel.

## Userspace CLI

CLI binary: `userspace/build/user_app`

Examples:

```bash
/mnt/host/user_app add 10.0.2.0/24 any tcp any 22 drop
/mnt/host/user_app list
/mnt/host/user_app stats
/mnt/host/user_app save /mnt/host/rules.conf
/mnt/host/user_app load /mnt/host/rules.conf
```

## Test Procedure

1. Boot QEMU.
2. Confirm device: `ls -l /dev/nfdev`.
3. Add a rule via CLI.
4. List rules and verify IDs.
5. Run `simulate` command or generate matching traffic.
6. Validate expected action and counters (`stats`).
7. Remove rule.
8. Save to `rules.conf` and reload.
9. Unload module cleanly (for modular mode).

## Known Limitations

- `INJECT` is currently a mock action (counter + accept path).
- Netfilter hooks are IPv4-only.
- Rule evaluation is linear scan (`O(n)`) up to `NFDEV_MAX_RULES`.
