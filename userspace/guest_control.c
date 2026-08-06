#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>

#include "guest_ioctl.h"

#define CHAR_DEV_PATH "/dev/nfdev"
#define UART_RX_RETRY_COUNT 20
#define UART_RX_RETRY_DELAY_US 50000

static int uart_write_ioctl(int fd, const char *buffer, size_t length)
{
	struct nfdev_ioctl_message message = { 0 };

	if (length > sizeof(message.data)) {
		errno = EMSGSIZE;
		return -1;
	}

	message.length = length;
	memcpy(message.data, buffer, length);

	if (ioctl(fd, NFDEV_IOCTL_UART_WRITE, &message) < 0)
		return -1;

	printf("[+] UART accepted %u byte(s)\n", message.length);
	return 0;
}

static int uart_read_ioctl(int fd)
{
	struct nfdev_ioctl_message message = {
		.length = NFDEV_IOCTL_MAX_MESSAGE_SIZE,
	};

	if (ioctl(fd, NFDEV_IOCTL_UART_READ, &message) < 0) {
		if (errno == EAGAIN)
			return 0;

		return -1;
	}

	printf("[+] Received %u byte(s) from UART: ", message.length);
	if (message.length)
		fwrite(message.data, 1, message.length, stdout);
	if (!message.length || message.data[message.length - 1] != '\n')
		putchar('\n');

	return 1;
}

static int wait_for_uart_data(int fd)
{
	int i;

	for (i = 0; i < UART_RX_RETRY_COUNT; ++i) {
		int ret = uart_read_ioctl(fd);

		if (ret > 0)
			return 0;

		if (ret < 0)
			return -1;

		usleep(UART_RX_RETRY_DELAY_US);
	}

	printf("[i] No UART data available yet.\n");
	return 0;
}

int main(void)
{
	char buffer[NFDEV_IOCTL_MAX_MESSAGE_SIZE];
	int dev_fd;

	dev_fd = open(CHAR_DEV_PATH, O_RDWR | O_NONBLOCK);
	if (dev_fd < 0) {
		perror("[-] Failed to open device");
		return EXIT_FAILURE;
	}

	printf("[+] Connected to kernel through ioctl.\n");

	for (;;) {
		printf("Enter message for UART (Ctrl+D to exit): ");
		fflush(stdout);

		if (!fgets(buffer, sizeof(buffer), stdin))
			break;

		if (uart_write_ioctl(dev_fd, buffer, strlen(buffer)) < 0) {
			perror("[-] NFDEV_IOCTL_UART_WRITE failed");
			continue;
		}

		printf("[+] Waiting for UART data...\n");
		if (wait_for_uart_data(dev_fd) < 0)
			perror("[-] NFDEV_IOCTL_UART_READ failed");
	}

	close(dev_fd);
	return EXIT_SUCCESS;
}
