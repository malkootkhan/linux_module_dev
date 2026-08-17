// SPDX-License-Identifier: GPL-2.0

#undef pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/device.h>
#include <linux/err.h>
#include <linux/fs.h>
#include <linux/kdev_t.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/netdevice.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/skbuff.h>
#include <linux/slab.h>
#include <linux/string.h>
#include <linux/uaccess.h>
#include <linux/vmalloc.h>
#include <net/ip.h>
#include <net/net_namespace.h>
#include <net/tcp.h>
#include <net/udp.h>

#include "nfdev_internal.h"
#include "nfdev_ioctl.h"
#include "nfdev_uart.h"

struct nfdev_packet_meta {
	__u32 src_ip;
	__u32 dst_ip;
	__u16 src_port;
	__u16 dst_port;
	__u8 proto;
	char in_if[NFDEV_MAX_IFNAME_LEN];
	char out_if[NFDEV_MAX_IFNAME_LEN];
	__u32 packet_len;
};

static bool nfdev_valid_proto(u8 proto)
{
	return proto == NFDEV_PROTO_ANY ||
	       proto == NFDEV_PROTO_TCP ||
	       proto == NFDEV_PROTO_UDP ||
	       proto == NFDEV_PROTO_ICMP;
}

static bool nfdev_valid_action(u8 action)
{
	return action == NFDEV_ACTION_ACCEPT ||
	       action == NFDEV_ACTION_DROP ||
	       action == NFDEV_ACTION_INJECT;
}

static bool nfdev_valid_mask(__u32 mask_be)
{
	u32 mask = ntohl(mask_be);
	bool zero_seen = false;
	int bit;

	for (bit = 31; bit >= 0; --bit) {
		bool set = (mask >> bit) & 0x1;

		if (!set) {
			zero_seen = true;
			continue;
		}

		if (zero_seen)
			return false;
	}

	return true;
}

static bool nfdev_valid_ifname_field(const char ifname[NFDEV_MAX_IFNAME_LEN])
{
	return memchr(ifname, '\0', NFDEV_MAX_IFNAME_LEN) != NULL;
}

static bool nfdev_rule_matches_packet(const struct nfdev_rule *rule,
					      const struct nfdev_packet_meta *packet)
{
	if (!rule->enabled)
		return false;

	if (rule->src_mask &&
	    ((packet->src_ip & rule->src_mask) != (rule->src_ip & rule->src_mask)))
		return false;

	if (rule->dst_mask &&
	    ((packet->dst_ip & rule->dst_mask) != (rule->dst_ip & rule->dst_mask)))
		return false;

	if (rule->proto != NFDEV_PROTO_ANY && rule->proto != packet->proto)
		return false;

	if (rule->src_port && rule->src_port != packet->src_port)
		return false;

	if (rule->dst_port && rule->dst_port != packet->dst_port)
		return false;

	if (rule->in_if[0] && strncmp(rule->in_if, packet->in_if,
				     NFDEV_MAX_IFNAME_LEN) != 0)
		return false;

	if (rule->out_if[0] && strncmp(rule->out_if, packet->out_if,
				      NFDEV_MAX_IFNAME_LEN) != 0)
		return false;

	return true;
}

static u8 nfdev_eval_packet(struct nfdev_context *ctx,
			    const struct nfdev_packet_meta *packet,
			    u32 *matched_rule_id,
			    bool *matched)
{
	unsigned long flags;
	u8 action = NFDEV_ACTION_ACCEPT;
	int i;

	*matched = false;
	*matched_rule_id = 0;

	spin_lock_irqsave(&ctx->rules_lock, flags);

	ctx->packets_total++;

	if (!ctx->filtering_enabled) {
		ctx->packets_accepted++;
		spin_unlock_irqrestore(&ctx->rules_lock, flags);
		return NFDEV_ACTION_ACCEPT;
	}

	for (i = 0; i < NFDEV_MAX_RULES; ++i) {
		struct nfdev_rule_slot *slot = &ctx->rules[i];

		if (!slot->in_use)
			continue;

		if (!nfdev_rule_matches_packet(&slot->rule, packet))
			continue;

		*matched = true;
		*matched_rule_id = slot->rule.id;
		action = slot->rule.action;
		slot->rule.packets++;
		slot->rule.bytes += packet->packet_len;
		break;
	}

	switch (action) {
	case NFDEV_ACTION_DROP:
		ctx->packets_dropped++;
		break;
	case NFDEV_ACTION_INJECT:
		ctx->packets_injected++;
		break;
	default:
		ctx->packets_accepted++;
		break;
	}

	spin_unlock_irqrestore(&ctx->rules_lock, flags);

	return action;
}

static unsigned int nfdev_netfilter_hook(void *priv,
					 struct sk_buff *skb,
					 const struct nf_hook_state *state)
{
	struct nfdev_context *ctx = priv;
	struct nfdev_packet_meta packet;
	struct iphdr *iph;
	unsigned int thoff;
	u8 action;
	u32 matched_rule_id;
	bool matched;

	if (!ctx || !skb)
		return NF_ACCEPT;

	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
		return NF_ACCEPT;

	iph = ip_hdr(skb);
	if (!iph)
		return NF_ACCEPT;

	memset(&packet, 0, sizeof(packet));
	packet.src_ip = iph->saddr;
	packet.dst_ip = iph->daddr;
	packet.proto = iph->protocol;
	packet.packet_len = ntohs(iph->tot_len);

	if (!packet.packet_len)
		packet.packet_len = skb->len;

	thoff = ip_hdrlen(skb);
	if (packet.proto == IPPROTO_TCP) {
		struct tcphdr _tcph;
		const struct tcphdr *tcph;

		tcph = skb_header_pointer(skb, thoff, sizeof(_tcph), &_tcph);
		if (tcph) {
			packet.src_port = ntohs(tcph->source);
			packet.dst_port = ntohs(tcph->dest);
		}
	} else if (packet.proto == IPPROTO_UDP) {
		struct udphdr _udph;
		const struct udphdr *udph;

		udph = skb_header_pointer(skb, thoff, sizeof(_udph), &_udph);
		if (udph) {
			packet.src_port = ntohs(udph->source);
			packet.dst_port = ntohs(udph->dest);
		}
	}

	if (state->in)
		strscpy(packet.in_if, state->in->name, sizeof(packet.in_if));

	if (state->out)
		strscpy(packet.out_if, state->out->name, sizeof(packet.out_if));

	action = nfdev_eval_packet(ctx, &packet, &matched_rule_id, &matched);
	if (action == NFDEV_ACTION_DROP)
		return NF_DROP;

	return NF_ACCEPT;
}

static void nfdev_rules_init(struct nfdev_context *ctx)
{
	spin_lock_init(&ctx->rules_lock);
	memset(ctx->rules, 0, sizeof(ctx->rules));
	ctx->rule_count = 0;
	ctx->next_rule_id = 1;
	ctx->filtering_enabled = true;
	ctx->packets_total = 0;
	ctx->packets_accepted = 0;
	ctx->packets_dropped = 0;
	ctx->packets_injected = 0;
	ctx->hooks_registered = false;
}

static int nfdev_register_hooks(struct nfdev_context *ctx)
{
	int ret;

	ctx->hook_ops_prerouting.hook = nfdev_netfilter_hook;
	ctx->hook_ops_prerouting.pf = PF_INET;
	ctx->hook_ops_prerouting.hooknum = NF_INET_PRE_ROUTING;
	ctx->hook_ops_prerouting.priority = NF_IP_PRI_FIRST;
	ctx->hook_ops_prerouting.priv = ctx;

	ctx->hook_ops_local_out.hook = nfdev_netfilter_hook;
	ctx->hook_ops_local_out.pf = PF_INET;
	ctx->hook_ops_local_out.hooknum = NF_INET_LOCAL_OUT;
	ctx->hook_ops_local_out.priority = NF_IP_PRI_FIRST;
	ctx->hook_ops_local_out.priv = ctx;

	ret = nf_register_net_hook(&init_net, &ctx->hook_ops_prerouting);
	if (ret)
		return ret;

	ret = nf_register_net_hook(&init_net, &ctx->hook_ops_local_out);
	if (ret) {
		nf_unregister_net_hook(&init_net, &ctx->hook_ops_prerouting);
		return ret;
	}

	ctx->hooks_registered = true;

	return 0;
}

static void nfdev_unregister_hooks(struct nfdev_context *ctx)
{
	if (!ctx->hooks_registered)
		return;

	nf_unregister_net_hook(&init_net, &ctx->hook_ops_local_out);
	nf_unregister_net_hook(&init_net, &ctx->hook_ops_prerouting);
	ctx->hooks_registered = false;
}

static int nfdev_validate_rule(const struct nfdev_rule *rule)
{
	if (!nfdev_valid_proto(rule->proto))
		return -EINVAL;

	if (!nfdev_valid_action(rule->action))
		return -EINVAL;

	if ((rule->proto != NFDEV_PROTO_TCP && rule->proto != NFDEV_PROTO_UDP) &&
	    (rule->src_port || rule->dst_port))
		return -EINVAL;

	if (!nfdev_valid_mask(rule->src_mask) || !nfdev_valid_mask(rule->dst_mask))
		return -EINVAL;

	if (!nfdev_valid_ifname_field(rule->in_if) ||
	    !nfdev_valid_ifname_field(rule->out_if))
		return -EINVAL;

	if (!rule->src_mask && rule->src_ip)
		return -EINVAL;

	if (!rule->dst_mask && rule->dst_ip)
		return -EINVAL;

	return 0;
}

static long nfdev_ioctl_add_rule(struct nfdev_context *ctx, void __user *argp)
{
	struct nfdev_ioctl_add_rule req;
	unsigned long flags;
	int i;
	int free_idx = -1;
	int ret;

	if (copy_from_user(&req, argp, sizeof(req)))
		return -EFAULT;

	ret = nfdev_validate_rule(&req.rule);
	if (ret)
		return ret;

	spin_lock_irqsave(&ctx->rules_lock, flags);

	for (i = 0; i < NFDEV_MAX_RULES; ++i) {
		if (!ctx->rules[i].in_use) {
			free_idx = i;
			break;
		}
	}

	if (free_idx < 0) {
		spin_unlock_irqrestore(&ctx->rules_lock, flags);
		return -ENOSPC;
	}

	ctx->rules[free_idx].in_use = true;
	ctx->rules[free_idx].rule = req.rule;
	ctx->rules[free_idx].rule.id = ctx->next_rule_id++;
	if (!ctx->next_rule_id)
		ctx->next_rule_id = 1;

	ctx->rules[free_idx].rule.packets = 0;
	ctx->rules[free_idx].rule.bytes = 0;
	ctx->rules[free_idx].rule.enabled = req.rule.enabled ? 1 : 0;
	ctx->rule_count++;

	req.assigned_id = ctx->rules[free_idx].rule.id;
	req.status = 0;

	spin_unlock_irqrestore(&ctx->rules_lock, flags);

	if (copy_to_user(argp, &req, sizeof(req)))
		return -EFAULT;

	return 0;
}

static long nfdev_ioctl_remove_rule(struct nfdev_context *ctx, void __user *argp)
{
	struct nfdev_ioctl_remove_rule req;
	unsigned long flags;
	int i;

	if (copy_from_user(&req, argp, sizeof(req)))
		return -EFAULT;

	spin_lock_irqsave(&ctx->rules_lock, flags);

	for (i = 0; i < NFDEV_MAX_RULES; ++i) {
		if (!ctx->rules[i].in_use)
			continue;

		if (ctx->rules[i].rule.id != req.id)
			continue;

		memset(&ctx->rules[i], 0, sizeof(ctx->rules[i]));
		ctx->rule_count--;
		req.status = 0;
		spin_unlock_irqrestore(&ctx->rules_lock, flags);

		if (copy_to_user(argp, &req, sizeof(req)))
			return -EFAULT;

		return 0;
	}

	spin_unlock_irqrestore(&ctx->rules_lock, flags);
	return -ENOENT;
}

static long nfdev_ioctl_list_rules(struct nfdev_context *ctx, void __user *argp)
{
	struct nfdev_ioctl_list_rules *resp;
	unsigned long flags;
	u32 out_idx = 0;
	int i;
	long ret = 0;

	resp = kvzalloc(sizeof(*resp), GFP_KERNEL);
	if (!resp)
		return -ENOMEM;

	spin_lock_irqsave(&ctx->rules_lock, flags);

	for (i = 0; i < NFDEV_MAX_RULES; ++i) {
		if (!ctx->rules[i].in_use)
			continue;

		if (out_idx >= NFDEV_MAX_RULES)
			break;

		resp->rules[out_idx++] = ctx->rules[i].rule;
	}

	resp->version = NFDEV_UAPI_VERSION;
	resp->count = out_idx;
	resp->status = 0;

	spin_unlock_irqrestore(&ctx->rules_lock, flags);

	if (copy_to_user(argp, resp, sizeof(*resp)))
		ret = -EFAULT;

	kvfree(resp);
	return ret;
}

static long nfdev_ioctl_flush_rules(struct nfdev_context *ctx)
{
	unsigned long flags;

	spin_lock_irqsave(&ctx->rules_lock, flags);
	memset(ctx->rules, 0, sizeof(ctx->rules));
	ctx->rule_count = 0;
	spin_unlock_irqrestore(&ctx->rules_lock, flags);

	return 0;
}

static long nfdev_ioctl_set_filtering(struct nfdev_context *ctx,
					     void __user *argp)
{
	struct nfdev_ioctl_filtering req;
	unsigned long flags;

	if (copy_from_user(&req, argp, sizeof(req)))
		return -EFAULT;

	spin_lock_irqsave(&ctx->rules_lock, flags);
	ctx->filtering_enabled = !!req.enabled;
	spin_unlock_irqrestore(&ctx->rules_lock, flags);

	req.status = 0;
	if (copy_to_user(argp, &req, sizeof(req)))
		return -EFAULT;

	return 0;
}

static long nfdev_ioctl_get_stats(struct nfdev_context *ctx, void __user *argp)
{
	struct nfdev_ioctl_stats stats;
	unsigned long flags;

	memset(&stats, 0, sizeof(stats));

	spin_lock_irqsave(&ctx->rules_lock, flags);
	stats.packets_total = ctx->packets_total;
	stats.packets_accepted = ctx->packets_accepted;
	stats.packets_dropped = ctx->packets_dropped;
	stats.packets_injected = ctx->packets_injected;
	stats.rule_count = ctx->rule_count;
	stats.filtering_enabled = ctx->filtering_enabled ? 1 : 0;
	spin_unlock_irqrestore(&ctx->rules_lock, flags);

	stats.status = 0;

	if (copy_to_user(argp, &stats, sizeof(stats)))
		return -EFAULT;

	return 0;
}

static long nfdev_ioctl_simulate_packet(struct nfdev_context *ctx,
					void __user *argp)
{
	struct nfdev_ioctl_simulate req;
	struct nfdev_packet_meta packet;
	u32 matched_rule_id;
	bool matched;
	u8 action;

	if (copy_from_user(&req, argp, sizeof(req)))
		return -EFAULT;

	if (!nfdev_valid_proto(req.packet.proto))
		return -EINVAL;

	if (!nfdev_valid_ifname_field(req.packet.in_if) ||
	    !nfdev_valid_ifname_field(req.packet.out_if))
		return -EINVAL;

	memset(&packet, 0, sizeof(packet));
	packet.src_ip = req.packet.src_ip;
	packet.dst_ip = req.packet.dst_ip;
	packet.src_port = req.packet.src_port;
	packet.dst_port = req.packet.dst_port;
	packet.proto = req.packet.proto;
	packet.packet_len = req.packet.packet_len;

	if (req.packet.in_if_valid)
		strscpy(packet.in_if, req.packet.in_if, sizeof(packet.in_if));

	if (req.packet.out_if_valid)
		strscpy(packet.out_if, req.packet.out_if, sizeof(packet.out_if));

	action = nfdev_eval_packet(ctx, &packet, &matched_rule_id, &matched);

	req.matched_rule_id = matched_rule_id;
	req.action = action;
	req.matched = matched ? 1 : 0;
	req.status = 0;

	if (copy_to_user(argp, &req, sizeof(req)))
		return -EFAULT;

	return 0;
}


static int nfdev_open(struct inode *inode, struct file *file)
{
	struct nfdev_context *ctx;

	ctx = container_of(inode->i_cdev,
			   struct nfdev_context,
			   cdev);

	file->private_data = ctx;

	pr_debug("device opened\n");

	return nonseekable_open(inode, file);
}

static int nfdev_release(struct inode *inode, struct file *file)
{
	file->private_data = NULL;

	pr_debug("device closed\n");

	return 0;
}

static ssize_t nfdev_read(struct file *file,
			  char __user *user_buffer,
			  size_t count,
			  loff_t *offset)
{
	struct nfdev_context *ctx = file->private_data;
	u8 kernel_buffer[NFDEV_IOCTL_MAX_MESSAGE_SIZE];
	size_t requested;
	ssize_t ret;

	if (!ctx)
		return -ENODEV;

	if (!count)
		return 0;

	requested = min_t(size_t, count, sizeof(kernel_buffer));

	ret = nfdev_uart_read(&ctx->uart, kernel_buffer, requested,
			      file->f_flags & O_NONBLOCK);
	if (ret <= 0)
		return ret;

	if (copy_to_user(user_buffer, kernel_buffer, ret))
		return -EFAULT;

	return ret;
}

static ssize_t nfdev_write(struct file *file,
			   const char __user *user_buffer,
			   size_t count,
			   loff_t *offset)
{
	struct nfdev_context *ctx = file->private_data;
	u8 kernel_buffer[NFDEV_IOCTL_MAX_MESSAGE_SIZE];
	ssize_t written;

	if (!ctx)
		return -ENODEV;

	if (!count)
		return 0;

	if (count > sizeof(kernel_buffer))
		return -EMSGSIZE;

	if (copy_from_user(kernel_buffer, user_buffer, count))
		return -EFAULT;

	written = nfdev_uart_write(&ctx->uart, kernel_buffer, count);
	if (written < 0) {
		pr_err("UART transmission failed: %zd\n", written);
		return written;
	}

	pr_debug("transmitted %zd bytes through UART\n", written);

	return written;
}

static long nfdev_ioctl_uart_write(struct nfdev_context *ctx,
				   void __user *argp)
{
	struct nfdev_ioctl_message message;
	ssize_t written;

	if (copy_from_user(&message, argp, sizeof(message)))
		return -EFAULT;

	if (message.length > NFDEV_IOCTL_MAX_MESSAGE_SIZE)
		return -EMSGSIZE;

	written = nfdev_uart_write(&ctx->uart, message.data, message.length);
	if (written < 0)
		return written;

	message.length = written;
	if (copy_to_user(argp, &message, sizeof(message)))
		return -EFAULT;

	return 0;
}

static long nfdev_ioctl_uart_read(struct file *file,
				  struct nfdev_context *ctx,
				  void __user *argp)
{
	struct nfdev_ioctl_message message;
	ssize_t bytes_read;

	if (copy_from_user(&message, argp, sizeof(message)))
		return -EFAULT;

	if (message.length > NFDEV_IOCTL_MAX_MESSAGE_SIZE)
		return -EMSGSIZE;

	memset(message.data, 0, sizeof(message.data));
	bytes_read = nfdev_uart_read(&ctx->uart, message.data, message.length,
				     file->f_flags & O_NONBLOCK);
	if (bytes_read < 0)
		return bytes_read;

	message.length = bytes_read;
	if (copy_to_user(argp, &message, sizeof(message)))
		return -EFAULT;

	return 0;
}

static long nfdev_ioctl(struct file *file, unsigned int cmd,
			unsigned long arg)
{
	struct nfdev_context *ctx = file->private_data;
	void __user *argp = (void __user *)arg;

	if (!ctx)
		return -ENODEV;

	switch (cmd) {
	case NFDEV_IOCTL_UART_WRITE:
		return nfdev_ioctl_uart_write(ctx, argp);
	case NFDEV_IOCTL_UART_READ:
		return nfdev_ioctl_uart_read(file, ctx, argp);
	case NFDEV_IOCTL_ADD_RULE:
		return nfdev_ioctl_add_rule(ctx, argp);
	case NFDEV_IOCTL_REMOVE_RULE:
		return nfdev_ioctl_remove_rule(ctx, argp);
	case NFDEV_IOCTL_LIST_RULES:
		return nfdev_ioctl_list_rules(ctx, argp);
	case NFDEV_IOCTL_FLUSH_RULES:
		return nfdev_ioctl_flush_rules(ctx);
	case NFDEV_IOCTL_SET_FILTERING:
		return nfdev_ioctl_set_filtering(ctx, argp);
	case NFDEV_IOCTL_GET_STATS:
		return nfdev_ioctl_get_stats(ctx, argp);
	case NFDEV_IOCTL_SIMULATE_PACKET:
		return nfdev_ioctl_simulate_packet(ctx, argp);
	default:
		return -ENOTTY;
	}
}

static const struct file_operations nfdev_fops = {
	.owner		= THIS_MODULE,
	.open		= nfdev_open,
	.read		= nfdev_read,
	.write		= nfdev_write,
	.unlocked_ioctl = nfdev_ioctl,
	.compat_ioctl	= compat_ptr_ioctl,
	.release	= nfdev_release,
	.llseek		= noop_llseek,
};

int nfdev_chrdev_register(struct nfdev_context *ctx)
{
	int ret;

	nfdev_rules_init(ctx);

	ret = alloc_chrdev_region(&ctx->devt, 0, NFDEV_MINOR_COUNT,
				  NFDEV_NAME);
	if (ret) {
		pr_err("failed to allocate device number: %d\n", ret);
		return ret;
	}

	cdev_init(&ctx->cdev, &nfdev_fops);
	ctx->cdev.owner = THIS_MODULE;

	ret = cdev_add(&ctx->cdev, ctx->devt, NFDEV_MINOR_COUNT);
	if (ret) {
		pr_err("failed to add cdev: %d\n", ret);
		goto err_unregister_region;
	}

	ctx->class = class_create(NFDEV_CLASS_NAME);
	if (IS_ERR(ctx->class)) {
		ret = PTR_ERR(ctx->class);
		ctx->class = NULL;

		pr_err("failed to create device class: %d\n", ret);
		goto err_delete_cdev;
	}

	ctx->device = device_create(ctx->class, NULL, ctx->devt, ctx,
				    NFDEV_NAME);
	if (IS_ERR(ctx->device)) {
		ret = PTR_ERR(ctx->device);
		ctx->device = NULL;

		pr_err("failed to create device: %d\n", ret);
		goto err_destroy_class;
	}

	ret = nfdev_register_hooks(ctx);
	if (ret) {
		pr_err("failed to register netfilter hooks: %d\n", ret);
		goto err_destroy_device;
	}

	pr_info("TEST_POINT: registered character device %s (%u:%u)\n",
		NFDEV_NAME, MAJOR(ctx->devt), MINOR(ctx->devt));

	pr_info("Device created have following info:\n");
	pr_info("  Device name: %s\n", NFDEV_NAME);
	pr_info("  Device major number: %u\n", MAJOR(ctx->devt));
	pr_info("  Device minor number: %u\n", MINOR(ctx->devt));
	pr_info("Device number MKDEV(): %u\n", MKDEV(MAJOR(ctx->devt), MINOR(ctx->devt)));
	pr_info("Device number devt: %u\n", ctx->devt);

	return 0;

err_destroy_device:
	device_destroy(ctx->class, ctx->devt);
	ctx->device = NULL;

err_destroy_class:
	class_destroy(ctx->class);
	ctx->class = NULL;

err_delete_cdev:
	cdev_del(&ctx->cdev);

err_unregister_region:
	unregister_chrdev_region(ctx->devt, NFDEV_MINOR_COUNT);
	ctx->devt = 0;

	return ret;
}

void nfdev_chrdev_unregister(struct nfdev_context *ctx)
{
	nfdev_unregister_hooks(ctx);

	device_destroy(ctx->class, ctx->devt);
	ctx->device = NULL;

	class_destroy(ctx->class);
	ctx->class = NULL;

	cdev_del(&ctx->cdev);

	unregister_chrdev_region(ctx->devt, NFDEV_MINOR_COUNT);
	ctx->devt = 0;
}
