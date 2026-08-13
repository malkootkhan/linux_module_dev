#include <errno.h>
#include <arpa/inet.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>

#include "guest_ioctl.h"

#define CHAR_DEV_PATH "/dev/nfdev"

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage:\n"
		"  %s add <src_cidr|any> <dst_cidr|any> <proto:any|tcp|udp|icmp> <sport|any> <dport|any> <action:accept|drop|inject>\n"
		"  %s remove <rule-id>\n"
		"  %s list\n"
		"  %s flush\n"
		"  %s enable <0|1>\n"
		"  %s stats\n"
		"  %s simulate <src_ip> <dst_ip> <proto:any|tcp|udp|icmp> <sport|any> <dport|any> <len>\n"
		"  %s save <rules.conf>\n"
		"  %s load <rules.conf>\n",
		prog, prog, prog, prog, prog, prog, prog, prog, prog);
}

static const char *action_to_str(uint8_t action)
{
	switch (action) {
	case NFDEV_ACTION_ACCEPT:
		return "ACCEPT";
	case NFDEV_ACTION_DROP:
		return "DROP";
	case NFDEV_ACTION_INJECT:
		return "INJECT";
	default:
		return "UNKNOWN";
	}
}

static const char *proto_to_str(uint8_t proto)
{
	switch (proto) {
	case NFDEV_PROTO_ANY:
		return "any";
	case NFDEV_PROTO_TCP:
		return "tcp";
	case NFDEV_PROTO_UDP:
		return "udp";
	case NFDEV_PROTO_ICMP:
		return "icmp";
	default:
		return "invalid";
	}
}

static int parse_proto(const char *text, uint8_t *out)
{
	if (!strcmp(text, "any")) {
		*out = NFDEV_PROTO_ANY;
		return 0;
	}

	if (!strcmp(text, "tcp")) {
		*out = NFDEV_PROTO_TCP;
		return 0;
	}

	if (!strcmp(text, "udp")) {
		*out = NFDEV_PROTO_UDP;
		return 0;
	}

	if (!strcmp(text, "icmp")) {
		*out = NFDEV_PROTO_ICMP;
		return 0;
	}

	return -EINVAL;
}

static int parse_action(const char *text, uint8_t *out)
{
	if (!strcmp(text, "accept")) {
		*out = NFDEV_ACTION_ACCEPT;
		return 0;
	}

	if (!strcmp(text, "drop")) {
		*out = NFDEV_ACTION_DROP;
		return 0;
	}

	if (!strcmp(text, "inject")) {
		*out = NFDEV_ACTION_INJECT;
		return 0;
	}

	return -EINVAL;
}

static int parse_port(const char *text, uint16_t *out)
{
	char *end = NULL;
	unsigned long val;

	if (!strcmp(text, "any")) {
		*out = 0;
		return 0;
	}

	errno = 0;
	val = strtoul(text, &end, 10);
	if (errno || !end || *end != '\0' || val > 65535)
		return -EINVAL;

	*out = (uint16_t)val;
	return 0;
}

static uint32_t prefix_to_mask(unsigned int prefix)
{
	if (prefix == 0)
		return 0;
	if (prefix == 32)
		return 0xFFFFFFFFU;
	return ~((1U << (32 - prefix)) - 1U);
}

static unsigned int mask_to_prefix(uint32_t mask_be)
{
	uint32_t mask = ntohl(mask_be);
	unsigned int prefix = 0;

	while (mask & 0x80000000U) {
		prefix++;
		mask <<= 1;
	}

	return prefix;
}

static int parse_cidr(const char *text, uint32_t *ip_out, uint32_t *mask_out)
{
	char local[64];
	char *slash;
	char *end = NULL;
	unsigned long prefix = 32;
	struct in_addr addr;

	if (!strcmp(text, "any")) {
		*ip_out = 0;
		*mask_out = 0;
		return 0;
	}

	if (strlen(text) >= sizeof(local))
		return -EINVAL;

	strcpy(local, text);
	slash = strchr(local, '/');
	if (slash) {
		*slash = '\0';
		errno = 0;
		prefix = strtoul(slash + 1, &end, 10);
		if (errno || !end || *end != '\0' || prefix > 32)
			return -EINVAL;
	}

	if (inet_pton(AF_INET, local, &addr) != 1)
		return -EINVAL;

	*ip_out = addr.s_addr;
	*mask_out = htonl(prefix_to_mask((unsigned int)prefix));
	return 0;
}

static int format_cidr(uint32_t ip, uint32_t mask, char *out, size_t out_len)
{
	struct in_addr addr = { .s_addr = ip };
	char ip_buf[INET_ADDRSTRLEN];
	unsigned int prefix;

	if (!mask) {
		if (snprintf(out, out_len, "any") >= (int)out_len)
			return -ENOSPC;
		return 0;
	}

	if (!inet_ntop(AF_INET, &addr, ip_buf, sizeof(ip_buf)))
		return -EINVAL;

	prefix = mask_to_prefix(mask);
	if (snprintf(out, out_len, "%s/%u", ip_buf, prefix) >= (int)out_len)
		return -ENOSPC;

	return 0;
}

static int open_dev(void)
{
	int fd = open(CHAR_DEV_PATH, O_RDWR);

	if (fd < 0)
		perror("open /dev/nfdev");

	return fd;
}

static int cmd_add(int fd, int argc, char **argv)
{
	struct nfdev_ioctl_add_rule req;
	char src_dbg[32], dst_dbg[32];

	if (argc != 8) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	memset(&req, 0, sizeof(req));

	if (parse_cidr(argv[2], &req.rule.src_ip, &req.rule.src_mask) ||
	    parse_cidr(argv[3], &req.rule.dst_ip, &req.rule.dst_mask) ||
	    parse_proto(argv[4], &req.rule.proto) ||
	    parse_port(argv[5], &req.rule.src_port) ||
	    parse_port(argv[6], &req.rule.dst_port) ||
	    parse_action(argv[7], &req.rule.action)) {
		fprintf(stderr, "Invalid add arguments\n");
		return EXIT_FAILURE;
	}

	req.rule.enabled = 1;

	if (format_cidr(req.rule.src_ip, req.rule.src_mask, src_dbg, sizeof(src_dbg)) ||
	    format_cidr(req.rule.dst_ip, req.rule.dst_mask, dst_dbg, sizeof(dst_dbg))) {
		fprintf(stderr, "Failed to format parsed CIDR arguments\n");
		return EXIT_FAILURE;
	}

	printf("[debug] add parsed: src=%s dst=%s proto=%s sport=%u dport=%u action=%s enabled=%u\n",
	       src_dbg,
	       dst_dbg,
	       proto_to_str(req.rule.proto),
	       req.rule.src_port,
	       req.rule.dst_port,
	       action_to_str(req.rule.action),
	       req.rule.enabled);

	if (ioctl(fd, NFDEV_IOCTL_ADD_RULE, &req) < 0) {
		perror("ioctl ADD_RULE");
		return EXIT_FAILURE;
	}

	printf("Added rule id=%u\n", req.assigned_id);
	return EXIT_SUCCESS;
}

static int cmd_remove(int fd, int argc, char **argv)
{
	struct nfdev_ioctl_remove_rule req;
	char *end = NULL;
	unsigned long id;

	if (argc != 3) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	errno = 0;
	id = strtoul(argv[2], &end, 10);
	if (errno || !end || *end != '\0' || id > UINT32_MAX) {
		fprintf(stderr, "Invalid rule id\n");
		return EXIT_FAILURE;
	}

	memset(&req, 0, sizeof(req));
	req.id = (uint32_t)id;

	if (ioctl(fd, NFDEV_IOCTL_REMOVE_RULE, &req) < 0) {
		perror("ioctl REMOVE_RULE");
		return EXIT_FAILURE;
	}

	printf("Removed rule id=%u\n", req.id);
	return EXIT_SUCCESS;
}

static int fetch_rules(int fd, struct nfdev_ioctl_list_rules *list)
{
	memset(list, 0, sizeof(*list));
	if (ioctl(fd, NFDEV_IOCTL_LIST_RULES, list) < 0)
		return -1;

	return 0;
}

static int cmd_list(int fd)
{
	struct nfdev_ioctl_list_rules list;
	uint32_t i;

	if (fetch_rules(fd, &list) < 0) {
		perror("ioctl LIST_RULES");
		return EXIT_FAILURE;
	}

	printf("Rule count: %u\n", list.count);
	for (i = 0; i < list.count; ++i) {
		char src[32], dst[32];
		const struct nfdev_rule *r = &list.rules[i];

		if (format_cidr(r->src_ip, r->src_mask, src, sizeof(src)) ||
		    format_cidr(r->dst_ip, r->dst_mask, dst, sizeof(dst))) {
			fprintf(stderr, "Failed formatting rule %u\n", r->id);
			continue;
		}

		printf("id=%u src=%s dst=%s proto=%s sport=%u dport=%u action=%s enabled=%u packets=%llu bytes=%llu\n",
		       r->id,
		       src,
		       dst,
		       proto_to_str(r->proto),
		       r->src_port,
		       r->dst_port,
		       action_to_str(r->action),
		       r->enabled,
		       (unsigned long long)r->packets,
		       (unsigned long long)r->bytes);
	}

	return EXIT_SUCCESS;
}

static int cmd_flush(int fd)
{
	if (ioctl(fd, NFDEV_IOCTL_FLUSH_RULES) < 0) {
		perror("ioctl FLUSH_RULES");
		return EXIT_FAILURE;
	}

	puts("All rules flushed");
	return EXIT_SUCCESS;
}

static int cmd_enable(int fd, int argc, char **argv)
{
	struct nfdev_ioctl_filtering req;

	if (argc != 3) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	if (strcmp(argv[2], "0") && strcmp(argv[2], "1")) {
		fprintf(stderr, "enable requires 0 or 1\n");
		return EXIT_FAILURE;
	}

	memset(&req, 0, sizeof(req));
	req.enabled = (uint8_t)(argv[2][0] == '1');

	if (ioctl(fd, NFDEV_IOCTL_SET_FILTERING, &req) < 0) {
		perror("ioctl SET_FILTERING");
		return EXIT_FAILURE;
	}

	printf("Filtering %s\n", req.enabled ? "enabled" : "disabled");
	return EXIT_SUCCESS;
}

static int cmd_stats(int fd)
{
	struct nfdev_ioctl_stats stats;

	memset(&stats, 0, sizeof(stats));
	if (ioctl(fd, NFDEV_IOCTL_GET_STATS, &stats) < 0) {
		perror("ioctl GET_STATS");
		return EXIT_FAILURE;
	}

	printf("filtering=%u rules=%u total=%llu accepted=%llu dropped=%llu injected=%llu\n",
	       stats.filtering_enabled,
	       stats.rule_count,
	       (unsigned long long)stats.packets_total,
	       (unsigned long long)stats.packets_accepted,
	       (unsigned long long)stats.packets_dropped,
	       (unsigned long long)stats.packets_injected);

	return EXIT_SUCCESS;
}

static int cmd_simulate(int fd, int argc, char **argv)
{
	struct nfdev_ioctl_simulate req;
	struct in_addr src, dst;
	char src_dbg[INET_ADDRSTRLEN], dst_dbg[INET_ADDRSTRLEN];
	char *end = NULL;
	unsigned long len;

	if (argc != 8) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	memset(&req, 0, sizeof(req));

	if (inet_pton(AF_INET, argv[2], &src) != 1 ||
	    inet_pton(AF_INET, argv[3], &dst) != 1 ||
	    parse_proto(argv[4], &req.packet.proto) ||
	    parse_port(argv[5], &req.packet.src_port) ||
	    parse_port(argv[6], &req.packet.dst_port)) {
		fprintf(stderr, "Invalid simulate arguments\n");
		return EXIT_FAILURE;
	}

	errno = 0;
	len = strtoul(argv[7], &end, 10);
	if (errno || !end || *end != '\0' || len > UINT32_MAX) {
		fprintf(stderr, "Invalid packet length\n");
		return EXIT_FAILURE;
	}

	req.packet.src_ip = src.s_addr;
	req.packet.dst_ip = dst.s_addr;
	req.packet.packet_len = (uint32_t)len;

	if (!inet_ntop(AF_INET, &src, src_dbg, sizeof(src_dbg)) ||
	    !inet_ntop(AF_INET, &dst, dst_dbg, sizeof(dst_dbg))) {
		fprintf(stderr, "Failed to format simulate IP arguments\n");
		return EXIT_FAILURE;
	}

	printf("[debug] simulate parsed: src=%s dst=%s proto=%s sport=%u dport=%u len=%u\n",
	       src_dbg,
	       dst_dbg,
	       proto_to_str(req.packet.proto),
	       req.packet.src_port,
	       req.packet.dst_port,
	       req.packet.packet_len);

	if (ioctl(fd, NFDEV_IOCTL_SIMULATE_PACKET, &req) < 0) {
		perror("ioctl SIMULATE_PACKET");
		return EXIT_FAILURE;
	}

	printf("simulate action=%s matched=%u matched_rule_id=%u\n",
	       action_to_str(req.action), req.matched, req.matched_rule_id);
	return EXIT_SUCCESS;
}

static int cmd_save(int fd, int argc, char **argv)
{
	struct nfdev_ioctl_list_rules list;
	FILE *fp;
	uint32_t i;

	if (argc != 3) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	if (fetch_rules(fd, &list) < 0) {
		perror("ioctl LIST_RULES");
		return EXIT_FAILURE;
	}

	fp = fopen(argv[2], "w");
	if (!fp) {
		perror("fopen save file");
		return EXIT_FAILURE;
	}

	fprintf(fp, "# src dst proto sport dport action\n");
	for (i = 0; i < list.count; ++i) {
		char src[32], dst[32];
		const struct nfdev_rule *r = &list.rules[i];

		if (format_cidr(r->src_ip, r->src_mask, src, sizeof(src)) ||
		    format_cidr(r->dst_ip, r->dst_mask, dst, sizeof(dst))) {
			fclose(fp);
			fprintf(stderr, "Failed formatting rule %u\n", r->id);
			return EXIT_FAILURE;
		}

		fprintf(fp, "%s %s %s %u %u %s\n",
			src, dst, proto_to_str(r->proto), r->src_port, r->dst_port,
			action_to_str(r->action));
	}

	fclose(fp);
	printf("Saved %u rule(s) to %s\n", list.count, argv[2]);
	return EXIT_SUCCESS;
}

static int cmd_load(int fd, int argc, char **argv)
{
	FILE *fp;
	char line[256];
	unsigned int loaded = 0;

	if (argc != 3) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	fp = fopen(argv[2], "r");
	if (!fp) {
		perror("fopen load file");
		return EXIT_FAILURE;
	}

	while (fgets(line, sizeof(line), fp)) {
		char src[64], dst[64], proto[16], action[16], sport[16], dport[16];
		struct nfdev_ioctl_add_rule req;

		if (line[0] == '#' || line[0] == '\n')
			continue;

		if (sscanf(line, "%63s %63s %15s %15s %15s %15s",
			   src, dst, proto, sport, dport, action) != 6) {
			fprintf(stderr, "Skipping malformed line: %s", line);
			continue;
		}

		memset(&req, 0, sizeof(req));
		if (parse_cidr(src, &req.rule.src_ip, &req.rule.src_mask) ||
		    parse_cidr(dst, &req.rule.dst_ip, &req.rule.dst_mask) ||
		    parse_proto(proto, &req.rule.proto) ||
		    parse_port(sport, &req.rule.src_port) ||
		    parse_port(dport, &req.rule.dst_port) ||
		    parse_action(action, &req.rule.action)) {
			fprintf(stderr, "Skipping invalid rule: %s", line);
			continue;
		}

		req.rule.enabled = 1;
		if (ioctl(fd, NFDEV_IOCTL_ADD_RULE, &req) < 0) {
			perror("ioctl ADD_RULE (load)");
			continue;
		}

		loaded++;
	}

	fclose(fp);
	printf("Loaded %u rule(s) from %s\n", loaded, argv[2]);
	return EXIT_SUCCESS;
}

int main(int argc, char **argv)
{
	int fd;
	int rc;

	if (argc < 2) {
		usage(argv[0]);
		return EXIT_FAILURE;
	}

	fd = open_dev();
	if (fd < 0)
		return EXIT_FAILURE;

	if (!strcmp(argv[1], "add"))
		rc = cmd_add(fd, argc, argv);
	else if (!strcmp(argv[1], "remove"))
		rc = cmd_remove(fd, argc, argv);
	else if (!strcmp(argv[1], "list"))
		rc = cmd_list(fd);
	else if (!strcmp(argv[1], "flush"))
		rc = cmd_flush(fd);
	else if (!strcmp(argv[1], "enable"))
		rc = cmd_enable(fd, argc, argv);
	else if (!strcmp(argv[1], "stats"))
		rc = cmd_stats(fd);
	else if (!strcmp(argv[1], "simulate"))
		rc = cmd_simulate(fd, argc, argv);
	else if (!strcmp(argv[1], "save"))
		rc = cmd_save(fd, argc, argv);
	else if (!strcmp(argv[1], "load"))
		rc = cmd_load(fd, argc, argv);
	else {
		usage(argv[0]);
		rc = EXIT_FAILURE;
	}

	close(fd);
	return rc;
}
