// SPDX-License-Identifier: GPL-2.0

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/delay.h>
#include <linux/err.h>
#include <linux/fcntl.h>
#include <linux/fs.h>
#include <linux/kernel.h>
#include <linux/kfifo.h>
#include <linux/kthread.h>
#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/sched.h>
#include <linux/spinlock.h>
#include <linux/wait.h>

#include "nfdev_uart.h"

#define NFDEV_UART_RX_CHUNK_SIZE        64
#define NFDEV_UART_POLL_DELAY_MS        20

static bool nfdev_uart_rx_available(struct nfdev_uart *uart)
{
        unsigned long flags;
        bool available;

        spin_lock_irqsave(&uart->rx_lock, flags);
        available = !kfifo_is_empty(&uart->rx_fifo);
        spin_unlock_irqrestore(&uart->rx_lock, flags);

        return available;
}

static int nfdev_uart_rx_thread(void *data)
{
        struct nfdev_uart *uart = data;
        u8 buffer[NFDEV_UART_RX_CHUNK_SIZE];
        unsigned long flags;
        unsigned int copied;
        ssize_t ret;

        while (!kthread_should_stop()) {
                ret = kernel_read(uart->file,
                                  buffer,
                                  sizeof(buffer),
                                  NULL);
                if (ret > 0) {
                        spin_lock_irqsave(&uart->rx_lock, flags);

                        copied = kfifo_in(&uart->rx_fifo,
                                         buffer,
                                         ret);

                        spin_unlock_irqrestore(&uart->rx_lock, flags);

                        if (copied < ret)
                                pr_warn_ratelimited(
                                        "UART RX FIFO full, dropped %zd bytes\n",
                                        ret - copied);

                        if (copied)
                                wake_up_interruptible(&uart->rx_wait);

                        pr_debug("received %u UART bytes\n", copied);
                        continue;
                }

                if (ret == -EAGAIN ||
                    ret == -EWOULDBLOCK ||
                    ret == 0) {
                        msleep_interruptible(NFDEV_UART_POLL_DELAY_MS);
                        continue;
                }

                if (ret == -ERESTARTSYS || ret == -EINTR)
                        continue;

                pr_err_ratelimited("UART read failed: %zd\n", ret);
                msleep_interruptible(100);
        }

        return 0;
}

int nfdev_uart_register(struct nfdev_uart *uart, const char *device_path)
{
        struct file *file;
        int ret;

        if (!uart || !device_path)
                return -EINVAL;

        mutex_init(&uart->tx_lock);
        spin_lock_init(&uart->rx_lock);
        init_waitqueue_head(&uart->rx_wait);
        INIT_KFIFO(uart->rx_fifo);

        uart->file = NULL;
        uart->rx_thread = NULL;
        uart->stopping = false;

        /*
         * O_NONBLOCK prevents the RX kernel thread from remaining blocked
         * forever when the module is being removed.
         */
        file = filp_open(device_path,
                         O_RDWR | O_NOCTTY | O_NONBLOCK,
                         0);
        if (IS_ERR(file)) {
                ret = PTR_ERR(file);
                pr_err("failed to open %s: %d\n",
                       device_path, ret);
                return ret;
        }

        uart->file = file;

        uart->rx_thread = kthread_run(nfdev_uart_rx_thread,
                                      uart,
                                      "nfdev_uart_rx");
        if (IS_ERR(uart->rx_thread)) {
                ret = PTR_ERR(uart->rx_thread);
                uart->rx_thread = NULL;

                pr_err("failed to start UART RX thread: %d\n", ret);

                filp_close(uart->file, NULL);
                uart->file = NULL;

                return ret;
        }

        pr_info("UART %s opened for TX and RX\n", device_path);

        return 0;
}

ssize_t nfdev_uart_write(struct nfdev_uart *uart,
                         const u8 *buffer,
                         size_t length)
{
        ssize_t ret;

        if (!uart || !buffer)
                return -EINVAL;

        if (!length)
                return 0;

        if (!uart->file)
                return -ENODEV;

        mutex_lock(&uart->tx_lock);

        ret = kernel_write(uart->file,
                           buffer,
                           length,
                           NULL);

        mutex_unlock(&uart->tx_lock);

        return ret;
}

ssize_t nfdev_uart_read(struct nfdev_uart *uart,
                        u8 *buffer,
                        size_t length,
                        bool nonblock)
{
        unsigned long flags;
        unsigned int copied;
        int ret;

        if (!uart || !buffer)
                return -EINVAL;

        if (!length)
                return 0;

        if (nonblock && !nfdev_uart_rx_available(uart))
                return -EAGAIN;

        ret = wait_event_interruptible(
                uart->rx_wait,
                nfdev_uart_rx_available(uart) ||
                READ_ONCE(uart->stopping));

        if (ret)
                return ret;

        if (READ_ONCE(uart->stopping) &&
            !nfdev_uart_rx_available(uart))
                return -ENODEV;

        spin_lock_irqsave(&uart->rx_lock, flags);

        copied = kfifo_out(&uart->rx_fifo,
                           buffer,
                           length);

        spin_unlock_irqrestore(&uart->rx_lock, flags);

        return copied;
}

void nfdev_uart_unregister(struct nfdev_uart *uart)
{
        if (!uart)
                return;

        WRITE_ONCE(uart->stopping, true);
        wake_up_all(&uart->rx_wait);

        if (uart->rx_thread) {
                kthread_stop(uart->rx_thread);
                uart->rx_thread = NULL;
        }

        if (uart->file) {
                filp_close(uart->file, NULL);
                uart->file = NULL;
        }

        pr_info("UART closed\n");
}
