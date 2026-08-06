// SPDX-License-Identifier: GPL-2.0

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/init.h>
#include <linux/module.h>

#include "nfdev_internal.h"

static struct nfdev_context nfdev_ctx;
static char *uart_path = "/dev/ttyS0";

module_param(uart_path, charp, 0644);
MODULE_PARM_DESC(uart_path, "Path to host UART device node (default: /dev/ttyS0)");

static int __init nfdev_init(void)
{
	int ret;

	ret = nfdev_uart_register(&nfdev_ctx.uart, uart_path);
	if (ret) {
		pr_err("failed to initialize UART backend (%s): %d\n", uart_path, ret);
		return ret;
	}

	ret = nfdev_chrdev_register(&nfdev_ctx);
	if (ret) {
		pr_err("failed to register character device: %d\n", ret);
		return ret;
	}

	pr_info("TEST_POINT: module loaded\n");

	return 0;
}

static void __exit nfdev_exit(void)
{
	nfdev_chrdev_unregister(&nfdev_ctx);

    nfdev_uart_unregister(&nfdev_ctx.uart);

	pr_info("TEST_POINT: module unloaded\n");
}

module_init(nfdev_init);
module_exit(nfdev_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Malkoot Khan");
MODULE_DESCRIPTION("Character-device control plane for a Netfilter rule engine");
MODULE_VERSION("0.1.0");
