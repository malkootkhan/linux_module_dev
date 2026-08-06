/* SPDX-License-Identifier: GPL-2.0 */

#ifndef NFDEV_INTERNAL_H
#define NFDEV_INTERNAL_H

#include <linux/cdev.h>
#include <linux/types.h>

#include "nfdev_uart.h"

#define NFDEV_NAME		"nfdev"
#define NFDEV_CLASS_NAME	"nfdev"
#define NFDEV_MINOR_COUNT	1

struct class;
struct device;

/*
 * Main module context.
 *
 * The rule table and Netfilter state will be added here in later stages.
 */
struct nfdev_context {
	dev_t devt;
	struct cdev cdev;
	struct class *class;
	struct device *device;
    struct nfdev_uart uart;
};
/*
 *later we need to add the rule table and netfilter hook ops to the context struct


 struct nfdev_context {
	dev_t devt;
	struct cdev cdev;
	struct class *class;
	struct device *device;

	struct nfdev_rule_table rules;
	struct nf_hook_ops hook_ops;
};


 */

int nfdev_chrdev_register(struct nfdev_context *ctx);
void nfdev_chrdev_unregister(struct nfdev_context *ctx);
#endif
