/* SPDX-License-Identifier: GPL-2.0 */

#ifndef _NFDEV_UART_H_
#define _NFDEV_UART_H_

#include <linux/kfifo.h>
#include <linux/mutex.h>
#include <linux/spinlock.h>
#include <linux/types.h>
#include <linux/wait.h>

#define NFDEV_UART_RX_FIFO_SIZE         1024

struct file;
struct task_struct;

struct nfdev_uart {
        struct file *file;
        struct task_struct *rx_thread;

        struct mutex tx_lock;

        spinlock_t rx_lock;
        wait_queue_head_t rx_wait;
        DECLARE_KFIFO(rx_fifo, u8, NFDEV_UART_RX_FIFO_SIZE);

        bool stopping;
};

int nfdev_uart_register(struct nfdev_uart *uart, const char *device_path);

ssize_t nfdev_uart_write(struct nfdev_uart *uart,
                         const u8 *buffer,
                         size_t length);

ssize_t nfdev_uart_read(struct nfdev_uart *uart,
                        u8 *buffer,
                        size_t length,
                        bool nonblock);

void nfdev_uart_unregister(struct nfdev_uart *uart);

#endif /* _NFDEV_UART_H_ */
