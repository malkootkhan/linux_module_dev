obj-m += nfdev_module.o
nfdev_module-objs := nfdev_chrdev.o nfdev_main.o nfdev_uart.o # Add other source files here if split

PWD := $(shell pwd)

# Path to the kernel top-level directory
KDIR := $(PWD)/../linux

# Allow overriding ARCH/CROSS_COMPILE from the environment
ARCH ?= arm64
CROSS_COMPILE ?= aarch64-linux-gnu-

.PHONY: all clean

all:
	$(MAKE) -C $(KDIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) M=$(PWD) clean

