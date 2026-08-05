CROSS_COMPILE ?= aarch64-linux-gnu-
CC := $(CROSS_COMPILE)gcc

BUILD_DIR := build
USER_APP := $(BUILD_DIR)/user_app

CPPFLAGS :=
CFLAGS := -O2 -Wall -Wextra
LDFLAGS := -static

.PHONY: all clean

all: $(USER_APP)

$(USER_APP): guest_control.c guest_ioctl.h | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $< $(LDFLAGS) -o $@

$(BUILD_DIR):
	mkdir -p $@

clean:
	$(RM) -r $(BUILD_DIR)