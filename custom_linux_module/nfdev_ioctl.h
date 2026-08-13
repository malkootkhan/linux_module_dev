/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */

#ifndef _NFDEV_IOCTL_H_
#define _NFDEV_IOCTL_H_

#include <linux/ioctl.h>
#include <linux/types.h>

/*
 * Shared ioctl ABI for /dev/nfdev.
 *
 * Keeping the payload inline and using fixed-width types makes the same
 * command encoding usable by native and compat userspace processes.
 */
#define NFDEV_IOCTL_MAGIC		'N'
#define NFDEV_UAPI_VERSION		1U
#define NFDEV_IOCTL_MAX_MESSAGE_SIZE	256U
#define NFDEV_MAX_RULES			128U
#define NFDEV_MAX_IFNAME_LEN		16U

enum nfdev_rule_action {
	NFDEV_ACTION_ACCEPT = 0,
	NFDEV_ACTION_DROP = 1,
	NFDEV_ACTION_INJECT = 2,
};

enum nfdev_rule_proto {
	NFDEV_PROTO_ANY = 0,
	NFDEV_PROTO_TCP = 6,
	NFDEV_PROTO_UDP = 17,
	NFDEV_PROTO_ICMP = 1,
};

struct nfdev_rule {
	__u32 id;
	__u32 src_ip;
	__u32 src_mask;
	__u32 dst_ip;
	__u32 dst_mask;
	__u16 src_port;
	__u16 dst_port;
	__u8 proto;
	__u8 action;
	__u8 enabled;
	__u8 reserved0;
	char in_if[NFDEV_MAX_IFNAME_LEN];
	char out_if[NFDEV_MAX_IFNAME_LEN];
	__u64 packets;
	__u64 bytes;
};

struct nfdev_ioctl_add_rule {
	struct nfdev_rule rule;
	__u32 assigned_id;
	__s32 status;
};

struct nfdev_ioctl_remove_rule {
	__u32 id;
	__s32 status;
};

struct nfdev_ioctl_list_rules {
	__u32 version;
	__u32 count;
	struct nfdev_rule rules[NFDEV_MAX_RULES];
	__s32 status;
};

struct nfdev_ioctl_filtering {
	__u8 enabled;
	__u8 reserved[3];
	__s32 status;
};

struct nfdev_ioctl_stats {
	__u64 packets_total;
	__u64 packets_accepted;
	__u64 packets_dropped;
	__u64 packets_injected;
	__u32 rule_count;
	__u8 filtering_enabled;
	__u8 reserved[3];
	__s32 status;
};

struct nfdev_ioctl_packet {
	__u32 src_ip;
	__u32 dst_ip;
	__u16 src_port;
	__u16 dst_port;
	__u8 proto;
	__u8 in_if_valid;
	__u8 out_if_valid;
	__u8 reserved0;
	char in_if[NFDEV_MAX_IFNAME_LEN];
	char out_if[NFDEV_MAX_IFNAME_LEN];
	__u32 packet_len;
};

struct nfdev_ioctl_simulate {
	struct nfdev_ioctl_packet packet;
	__u32 matched_rule_id;
	__u8 action;
	__u8 matched;
	__u8 reserved[2];
	__s32 status;
};

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

#define NFDEV_IOCTL_ADD_RULE \
	_IOWR(NFDEV_IOCTL_MAGIC, 0x10, struct nfdev_ioctl_add_rule)
#define NFDEV_IOCTL_REMOVE_RULE \
	_IOWR(NFDEV_IOCTL_MAGIC, 0x11, struct nfdev_ioctl_remove_rule)
#define NFDEV_IOCTL_LIST_RULES \
	_IOWR(NFDEV_IOCTL_MAGIC, 0x12, struct nfdev_ioctl_list_rules)
#define NFDEV_IOCTL_FLUSH_RULES \
	_IO(NFDEV_IOCTL_MAGIC, 0x13)
#define NFDEV_IOCTL_SET_FILTERING \
	_IOWR(NFDEV_IOCTL_MAGIC, 0x14, struct nfdev_ioctl_filtering)
#define NFDEV_IOCTL_GET_STATS \
	_IOWR(NFDEV_IOCTL_MAGIC, 0x15, struct nfdev_ioctl_stats)
#define NFDEV_IOCTL_SIMULATE_PACKET \
	_IOWR(NFDEV_IOCTL_MAGIC, 0x16, struct nfdev_ioctl_simulate)

#endif /* _NFDEV_IOCTL_H_ */
