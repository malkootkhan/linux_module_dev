// SPDX-License-Identifier: GPL-2.0

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/device.h>
#include <linux/err.h>
#include <linux/fs.h>
#include <linux/kdev_t.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/uaccess.h>

#include "nfdev_internal.h"
#include "nfdev_ioctl.h"
#include "nfdev_uart.h"


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

	pr_info("TEST_POINT: registered character device %s (%u:%u)\n",
		NFDEV_NAME, MAJOR(ctx->devt), MINOR(ctx->devt));

	pr_info("Device created have following info:\n");
	pr_info("  Device name: %s\n", NFDEV_NAME);
	pr_info("  Device major number: %u\n", MAJOR(ctx->devt));
	pr_info("  Device minor number: %u\n", MINOR(ctx->devt));
	pr_info("Device number MKDEV(): %u\n", MKDEV(MAJOR(ctx->devt), MINOR(ctx->devt)));
	pr_info("Device number devt: %u\n", ctx->devt);

	return 0;

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
	device_destroy(ctx->class, ctx->devt);
	ctx->device = NULL;

	class_destroy(ctx->class);
	ctx->class = NULL;

	cdev_del(&ctx->cdev);

	unregister_chrdev_region(ctx->devt, NFDEV_MINOR_COUNT);
	ctx->devt = 0;
}
