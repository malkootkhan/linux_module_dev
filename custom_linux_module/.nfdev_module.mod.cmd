savedcmd_nfdev_module.mod := printf '%s\n'   nfdev_chrdev.o nfdev_main.o nfdev_uart.o | awk '!x[$$0]++ { print("./"$$0) }' > nfdev_module.mod
