/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */

#ifndef _NFDEV_IOCTL_H_
#define _NFDEV_IOCTL_H_

#include <linux/ioctl.h>
#include <linux/types.h>

/*
 * Shared ioctl ABI for /dev/nfdev_module.
 *
 * Keeping the payload inline and using fixed-width types makes the same
 * command encoding usable by native and compat userspace processes.
 */
#define NFDEV_IOCTL_MAGIC		'N'
#define NFDEV_IOCTL_MAX_MESSAGE_SIZE	256U

struct nfdev_ioctl_message {
	__u32 length;
	__u8 data[NFDEV_IOCTL_MAX_MESSAGE_SIZE];
};

/*
 * On input, length is the number of bytes to write or the maximum number of
 * bytes to read.  On success, length is replaced with the transferred size.
 */
#define NFDEV_IOCTL_UART_WRITE \
	_IOWR(NFDEV_IOCTL_MAGIC, 0x01, struct nfdev_ioctl_message)
#define NFDEV_IOCTL_UART_READ \
	_IOWR(NFDEV_IOCTL_MAGIC, 0x02, struct nfdev_ioctl_message)

#endif /* _NFDEV_IOCTL_H_ */
