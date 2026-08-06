ifneq ($(KERNELRELEASE),)
obj-y += nfdev_module.o
nfdev_module-y := nfdev_chrdev.o nfdev_main.o nfdev_uart.o
else
KDIR ?= $(CURDIR)/../linux
ARCH ?= arm64
CROSS_COMPILE ?= aarch64-linux-gnu-
export CONFIG_NFDEV_MODULE ?= m

.PHONY: all clean
all:
	$(MAKE) -C $(KDIR) M=$(CURDIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
endif