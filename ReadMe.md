# How to Use the Script
## Make the script executable:
```chmod +x manage_build.sh```
## Use code with caution.Execute specific tasks depending on your needs:
### If you just updated your driver module and want to repack the disk image and test it:
```./manage_build.sh fs && ./manage_build.sh run```
## Use code with caution.If your environment is totally broken and you want to clean build everything from scratch and launch it:
```./manage_build.sh all```
## Use code with caution.If you just want to spin up the existing build without waiting for modifications:
```./manage_build.sh run```
## Run ```./manage_build.sh help``` to see all available options.


# the following scripts are run within qemu to create and mount a share directory for sharing files across host development linux and qemu


### 1. Loadable-module support

From the main menu(menuconfig0):

<*> Enable loadable module support

*Required result:*

CONFIG_MODULES=y
### 2. 9P network protocol

Navigate to:

*Networking support*
    <*> Plan 9 Resource Sharing Support (9P2000)

Press Y, not M.

*Required:*

CONFIG_NET_9P=y

*Enter its submenu:*

Networking support
    <*> Plan 9 Resource Sharing Support (9P2000)
        <*> 9P 

Virtio Transport

Required:

CONFIG_NET_9P_VIRTIO=y

We do not need Xen, USB gadget, or debug support.

### 3. 9P filesystem

This is the option that was previously missed:

File systems
    Network File Systems
        <*> Plan 9 Resource Sharing Support (9P2000)

Required:

CONFIG_9P_FS=y

Although it has nearly the same name, this is a separate option from the one under Networking support.

### 4. Virtio MMIO transport

Navigate approximately to:

Device Drivers
    Virtio drivers
        <*> Platform bus driver for memory mapped virtio devices

Required:

CONFIG_VIRTIO=y
CONFIG_VIRTIO_MMIO=y

CONFIG_VIRTIO may be automatically selected by the visible Virtio transport option.

### 5. Automatic /dev nodes

For automatic creation of /dev/nfdev, search in menuconfig by pressing / and entering:

DEVTMPFS

Enable:

[*] Maintain a devtmpfs filesystem to mount at /dev

Required:

CONFIG_DEVTMPFS=y

Your init script must still mount it:

mount -t devtmpfs devtmpfs /dev
Final required configuration

Enable all below in ```arch/arm64/configs/defconfig``` or menuconfig

CONFIG_MODULES=y

CONFIG_VIRTIO=y
CONFIG_VIRTIO_MMIO=y

CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_9P_FS=y

CONFIG_DEVTMPFS=y

## UART communication:
Run qemu then on other wsl terminal run ```picocom -b 115200 /dev/pts/2``` now serial uart is connected with qemu
when user write some thing to file it apear on uart or writing to uart terminal will appear on file which can be read by userspace

**NOTE:**
I faced some trouble because of already available nfdev device in kernel I changed my module name to nfdev_module.ko, now it is working fine. once you build the kernel, build the module and then run the qemu then insert the module and then run the user_app (guest_control.c) you will be able to prompted to enter a message and press enter, this message will be transmitted from user to uart and displayed on uart terminal but you will need to specify the correct uart port, to confirm it you will need to look at qemu output log specifically the start, there is /dev/pts/x where x : 0,,,n it changes every time you run qemu, in other terminal on host linux; run ```picocom -b 115200 /dev/pts/x``` to connect to uart terminal.
