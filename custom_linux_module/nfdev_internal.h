/* SPDX-License-Identifier: GPL-2.0 */

#ifndef NFDEV_INTERNAL_H
#define NFDEV_INTERNAL_H

#include <linux/cdev.h>
#include <linux/netfilter.h>
#include <linux/spinlock.h>
#include <linux/types.h>

#include "nfdev_ioctl.h"
#include "nfdev_uart.h"

#define NFDEV_NAME		"nfdev"
#define NFDEV_CLASS_NAME	"nfdev"
#define NFDEV_MINOR_COUNT	1

struct class;
struct device;

struct nfdev_rule_slot {
	bool in_use;
	struct nfdev_rule rule;
};

struct nfdev_context {
	dev_t devt;
	struct cdev cdev;
	struct class *class;
	struct device *device;
	struct nfdev_uart uart;

	spinlock_t rules_lock;
	struct nfdev_rule_slot rules[NFDEV_MAX_RULES];
	u32 rule_count;
	u32 next_rule_id;
	bool filtering_enabled;

	u64 packets_total;
	u64 packets_accepted;
	u64 packets_dropped;
	u64 packets_injected;

	struct nf_hook_ops hook_ops_prerouting;
	struct nf_hook_ops hook_ops_local_out;
	bool hooks_registered;
};

int nfdev_chrdev_register(struct nfdev_context *ctx);
void nfdev_chrdev_unregister(struct nfdev_context *ctx);
#endif
