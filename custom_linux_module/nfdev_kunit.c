// SPDX-License-Identifier: GPL-2.0

#include <kunit/test.h>
#include <linux/errno.h>
#include <linux/string.h>

#include "nfdev_internal.h"

#ifndef KBUILD_MODNAME
#define KBUILD_MODNAME "nfdev_kunit"
#endif

/*
 * Satisfy nfdev_chrdev.c UART dependencies locally so this test module can
 * focus on rule and packet-evaluation logic.
 */
ssize_t nfdev_uart_write(struct nfdev_uart *uart,
                const u8 *buffer,
                size_t length)
{
    return (ssize_t)length;
}

ssize_t nfdev_uart_read(struct nfdev_uart *uart,
               u8 *buffer,
               size_t length,
               bool nonblock)
{
    return -EAGAIN;
}

#include "nfdev_chrdev.c"

static struct nfdev_rule nfdev_kunit_base_rule(void)
{
    struct nfdev_rule rule;

    memset(&rule, 0, sizeof(rule));
    rule.enabled = 1;
    rule.proto = NFDEV_PROTO_ANY;
    rule.action = NFDEV_ACTION_ACCEPT;

    return rule;
}

static struct nfdev_packet_meta nfdev_kunit_base_packet(void)
{
    struct nfdev_packet_meta packet;

    memset(&packet, 0, sizeof(packet));
    packet.proto = NFDEV_PROTO_TCP;
    packet.src_ip = cpu_to_be32(0x0a000001);
    packet.dst_ip = cpu_to_be32(0x0a000002);
    packet.src_port = 12345;
    packet.dst_port = 80;
    packet.packet_len = 128;
    strscpy(packet.in_if, "eth0", sizeof(packet.in_if));
    strscpy(packet.out_if, "eth1", sizeof(packet.out_if));

    return packet;
}

static void nfdev_valid_proto_action_test(struct kunit *test)
{
    KUNIT_EXPECT_TRUE(test, nfdev_valid_proto(NFDEV_PROTO_ANY));
    KUNIT_EXPECT_TRUE(test, nfdev_valid_proto(NFDEV_PROTO_TCP));
    KUNIT_EXPECT_TRUE(test, nfdev_valid_proto(NFDEV_PROTO_UDP));
    KUNIT_EXPECT_TRUE(test, nfdev_valid_proto(NFDEV_PROTO_ICMP));
    KUNIT_EXPECT_FALSE(test, nfdev_valid_proto(0xff));

    KUNIT_EXPECT_TRUE(test, nfdev_valid_action(NFDEV_ACTION_ACCEPT));
    KUNIT_EXPECT_TRUE(test, nfdev_valid_action(NFDEV_ACTION_DROP));
    KUNIT_EXPECT_TRUE(test, nfdev_valid_action(NFDEV_ACTION_INJECT));
    KUNIT_EXPECT_FALSE(test, nfdev_valid_action(0xff));
}

static void nfdev_valid_mask_test(struct kunit *test)
{
    KUNIT_EXPECT_TRUE(test, nfdev_valid_mask(cpu_to_be32(0xffffffff)));
    KUNIT_EXPECT_TRUE(test, nfdev_valid_mask(cpu_to_be32(0xffffff00)));
    KUNIT_EXPECT_TRUE(test, nfdev_valid_mask(cpu_to_be32(0x00000000)));
    KUNIT_EXPECT_FALSE(test, nfdev_valid_mask(cpu_to_be32(0xff00ff00)));
    KUNIT_EXPECT_FALSE(test, nfdev_valid_mask(cpu_to_be32(0xf0f00000)));
}

static void nfdev_validate_rule_test(struct kunit *test)
{
    struct nfdev_rule rule = nfdev_kunit_base_rule();

    KUNIT_EXPECT_EQ(test, nfdev_validate_rule(&rule), 0);

    rule.proto = 0xff;
    KUNIT_EXPECT_EQ(test, nfdev_validate_rule(&rule), -EINVAL);
    rule.proto = NFDEV_PROTO_ANY;

    rule.action = 0xff;
    KUNIT_EXPECT_EQ(test, nfdev_validate_rule(&rule), -EINVAL);
    rule.action = NFDEV_ACTION_ACCEPT;

    rule.proto = NFDEV_PROTO_ICMP;
    rule.src_port = 53;
    KUNIT_EXPECT_EQ(test, nfdev_validate_rule(&rule), -EINVAL);
    rule.src_port = 0;

    rule.src_mask = cpu_to_be32(0xff00ff00);
    KUNIT_EXPECT_EQ(test, nfdev_validate_rule(&rule), -EINVAL);
    rule.src_mask = 0;

    memset(rule.in_if, 'x', sizeof(rule.in_if));
    KUNIT_EXPECT_EQ(test, nfdev_validate_rule(&rule), -EINVAL);
    memset(rule.in_if, 0, sizeof(rule.in_if));

    rule.src_ip = cpu_to_be32(0x0a000001);
    rule.src_mask = 0;
    KUNIT_EXPECT_EQ(test, nfdev_validate_rule(&rule), -EINVAL);
}

static void nfdev_rule_matches_packet_test(struct kunit *test)
{
    struct nfdev_rule rule = nfdev_kunit_base_rule();
    struct nfdev_packet_meta packet = nfdev_kunit_base_packet();

    rule.enabled = 0;
    KUNIT_EXPECT_FALSE(test, nfdev_rule_matches_packet(&rule, &packet));

    rule.enabled = 1;
    rule.proto = NFDEV_PROTO_TCP;
    rule.src_port = 12345;
    rule.dst_port = 80;
    rule.src_ip = cpu_to_be32(0x0a000000);
    rule.src_mask = cpu_to_be32(0xffffff00);
    rule.dst_ip = cpu_to_be32(0x0a000000);
    rule.dst_mask = cpu_to_be32(0xffffff00);
    strscpy(rule.in_if, "eth0", sizeof(rule.in_if));
    strscpy(rule.out_if, "eth1", sizeof(rule.out_if));

    KUNIT_EXPECT_TRUE(test, nfdev_rule_matches_packet(&rule, &packet));

    packet.dst_port = 22;
    KUNIT_EXPECT_FALSE(test, nfdev_rule_matches_packet(&rule, &packet));
}

static void nfdev_eval_packet_filtering_disabled_test(struct kunit *test)
{
    struct nfdev_context ctx;
    struct nfdev_packet_meta packet = nfdev_kunit_base_packet();
    u32 matched_rule_id = 123;
    bool matched = true;
    u8 action;

    memset(&ctx, 0, sizeof(ctx));
    nfdev_rules_init(&ctx);
    ctx.filtering_enabled = false;

    action = nfdev_eval_packet(&ctx, &packet, &matched_rule_id, &matched);

    KUNIT_EXPECT_EQ(test, action, (u8)NFDEV_ACTION_ACCEPT);
    KUNIT_EXPECT_FALSE(test, matched);
    KUNIT_EXPECT_EQ(test, matched_rule_id, (u32)0);
    KUNIT_EXPECT_EQ(test, ctx.packets_total, (u64)1);
    KUNIT_EXPECT_EQ(test, ctx.packets_accepted, (u64)1);
    KUNIT_EXPECT_EQ(test, ctx.packets_dropped, (u64)0);
}

static void nfdev_eval_packet_matching_rule_test(struct kunit *test)
{
    struct nfdev_context ctx;
    struct nfdev_packet_meta packet = nfdev_kunit_base_packet();
    struct nfdev_rule_slot *slot;
    u32 matched_rule_id = 0;
    bool matched = false;
    u8 action;

    memset(&ctx, 0, sizeof(ctx));
    nfdev_rules_init(&ctx);

    slot = &ctx.rules[0];
    slot->in_use = true;
    slot->rule = nfdev_kunit_base_rule();
    slot->rule.id = 77;
    slot->rule.enabled = 1;
    slot->rule.action = NFDEV_ACTION_DROP;
    slot->rule.proto = NFDEV_PROTO_TCP;
    slot->rule.dst_port = 80;
    ctx.rule_count = 1;

    action = nfdev_eval_packet(&ctx, &packet, &matched_rule_id, &matched);

    KUNIT_EXPECT_EQ(test, action, (u8)NFDEV_ACTION_DROP);
    KUNIT_EXPECT_TRUE(test, matched);
    KUNIT_EXPECT_EQ(test, matched_rule_id, (u32)77);
    KUNIT_EXPECT_EQ(test, slot->rule.packets, (u64)1);
    KUNIT_EXPECT_EQ(test, slot->rule.bytes, (u64)packet.packet_len);
    KUNIT_EXPECT_EQ(test, ctx.packets_total, (u64)1);
    KUNIT_EXPECT_EQ(test, ctx.packets_dropped, (u64)1);
    KUNIT_EXPECT_EQ(test, ctx.packets_accepted, (u64)0);
}

static struct kunit_case nfdev_test_cases[] = {
    KUNIT_CASE(nfdev_valid_proto_action_test),
    KUNIT_CASE(nfdev_valid_mask_test),
    KUNIT_CASE(nfdev_validate_rule_test),
    KUNIT_CASE(nfdev_rule_matches_packet_test),
    KUNIT_CASE(nfdev_eval_packet_filtering_disabled_test),
    KUNIT_CASE(nfdev_eval_packet_matching_rule_test),
    {}
};

static struct kunit_suite nfdev_test_suite = {
    .name = "nfdev-kunit",
    .test_cases = nfdev_test_cases,
};

kunit_test_suite(nfdev_test_suite);

MODULE_LICENSE("GPL");
