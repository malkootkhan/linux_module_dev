#!/bin/bash

# Exit immediately if any command fails
set -e

# Create a shared directory for QEMU file sharing if it doesn't exist
SHARE_DIR="$HOME/qemu-share"
mkdir -p "$SHARE_DIR"
SHARE_DIR="$(realpath "$SHARE_DIR")"

# ==============================================================================
# CONFIGURATION & PATHS
# ==============================================================================
# Define absolute paths based on where this script is located
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINUX_DIR="${WORKSPACE_DIR}/linux"
BUSYBOX_DIR="${WORKSPACE_DIR}/busybox"
INITRAMFS_OUT="${WORKSPACE_DIR}/initramfs_arm64.cpio.gz"

# Build execution settings
export ARCH="arm64"
export CROSS_COMPILE="aarch64-linux-gnu-"
JOBS=$(nproc)

# ==============================================================================
# HELP MENU FUNCTION
# ==============================================================================
show_help() {
    echo "Usage: $0 [task]"
    echo ""
    echo "Tasks:"
    echo "  kernel_clean_build    - Clean config, build the Linux kernel Image and core modules"
    echo "  kernel_build          - Build the Linux kernel Image and core modules without cleaning"
    echo "  busybox   - Reset, patch out broken utilities, build static BusyBox"
    echo "  fs        - Assemble standard directories, write init script, pack initramfs"
    echo "  run       - Launch the custom compiled Image and root filesystem inside QEMU"
    echo "  all       - Sequentially execute: kernel -> busybox -> fs -> run"
    echo "  module_build - Build the kernel module and copy it to the shared directory"
    echo ""
    echo "Example: $0 run"
    exit 1
}

# Ensure an argument was provided
if [ -z "$1" ]; then
    show_help
fi

# ==============================================================================
# TASK MODULES
# ==============================================================================

build_kernel() {
    echo "=== [Task] Building Linux Kernel ==="
    if [ ! -d "$LINUX_DIR" ]; then
        echo "Error: Linux source tree folder missing at $LINUX_DIR"
        exit 1
    fi
    cd "$LINUX_DIR"
    
    echo "--> Cleaning up old build artifacts..."
    make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE mrproper
    
    echo "--> Applying default arm64 defconfig..."
    make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE defconfig
    
    echo "--> Compiling kernel image and modules (Threads: $JOBS)..."
    make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -j$JOBS Image modules
    echo "=== Kernel Build Complete ==="
}

just_kernel_build() {
    echo "=== [Task] Building Linux Kernel (No Clean) ==="
    if [ ! -d "$LINUX_DIR" ]; then
        echo "Error: Linux source tree folder missing at $LINUX_DIR"
        exit 1
    fi
    cd "$LINUX_DIR"
    
    echo "--> Compiling kernel image and modules (Threads: $JOBS)..."
    make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -j$JOBS Image modules
    echo "=== Kernel Build Complete ==="
}

build_busybox() {
    echo "=== [Task] Building BusyBox User Space ==="
    if [ ! -d "$BUSYBOX_DIR" ]; then
        echo "Error: BusyBox folder missing at $BUSYBOX_DIR"
        exit 1
    fi
    cd "$BUSYBOX_DIR"
    
    echo "--> Purging old configurations..."
    make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE mrproper
    
    echo "--> Generating baseline default configuration..."
    make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE defconfig
    
    echo "--> Disabling incompatible SHA1 hardware acceleration..."
    sed -i 's/^CONFIG_SHA1_HWACCEL=y/# CONFIG_SHA1_HWACCEL is not set/' .config
    
    echo "--> Tweaking config: Enabling Static build & patching broken 'tc' driver..."
    sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
    sed -i 's/CONFIG_TC=y/CONFIG_TC=n/' .config
    sed -i 's/CONFIG_FEATURE_TC_INGRESS=y/CONFIG_FEATURE_TC_INGRESS=n/' .config
    
    echo "--> Compiling and executing local directory install..."
    make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -j$JOBS install
    echo "=== BusyBox Build Complete ==="
}


pack_filesystem() {
    echo "=== [Task] Assembling Root Filesystem Architecture ==="

    if [ ! -d "$BUSYBOX_DIR/_install" ]; then
        echo "Error: BusyBox installation directory does not exist:"
        echo "$BUSYBOX_DIR/_install"
        echo "Run: $0 busybox"
        exit 1
    fi

    cd "$BUSYBOX_DIR/_install"

    echo "--> Generating standard filesystem directories..."
    mkdir -p dev proc sys mnt

    echo "--> Creating init script..."

cat > init << 'EOF'
#!/bin/sh

mount -t proc proc /proc
mount -t sysfs sysfs /sys

mkdir -p /dev
mount -t devtmpfs devtmpfs /dev

mkdir -p /mnt/host
mount -t 9p \
        -o trans=virtio,version=9p2000.L \
        hostshare /mnt/host

echo "=============================================="
echo " SUCCESS: Welcome to 64-Bit ARM Linux on QEMU!"
echo "=============================================="

exec /bin/sh
EOF

    chmod +x init

    echo "--> Compressing filesystem into initramfs..."

    find . -print0 |
        cpio --null -ov --format=newc |
        gzip -9 > "$INITRAMFS_OUT"

    echo "=== Filesystem Packaging Complete ==="
    echo "Created: $INITRAMFS_OUT"
}

run_qemu() {
    echo "=== [Task] Launching virtual environment inside QEMU ==="
    KERNEL_IMG="${LINUX_DIR}/arch/arm64/boot/Image"
    
    if [ ! -f "$KERNEL_IMG" ] || [ ! -f "$INITRAMFS_OUT" ]; then
        echo "Error: Missing required execution targets. Please build 'kernel' and 'fs' targets first."
        exit 1
    fi
    echo "--> QEMU shared directory: $SHARE_DIR"
    echo "--> Current shared-directory contents:"
    ls -la "$SHARE_DIR"

    #print all the variables to know the paths better
    echo "=== Current Execution Paths ==="
    echo "Workspace Directory: $WORKSPACE_DIR"
    echo "Linux Source Directory: $LINUX_DIR"
    echo "BusyBox Source Directory: $BUSYBOX_DIR"
    echo "Initramfs Output File: $INITRAMFS_OUT"


    echo "--> Running simulation wrapper (Exit command: Ctrl+A then X)..."
   # qemu-system-aarch64 \
   # -M virt \
   # -cpu cortex-a57 \
   # -m 1G \
   # -kernel "$KERNEL_IMG" \
   # -initrd "$INITRAMFS_OUT" \
   # -append "console=ttyAMA0 loglevel=8" \
   # -fsdev local,id=hostshare,path="$SHARE_DIR",security_model=none \
   # -device virtio-9p-device,fsdev=hostshare,mount_tag=hostshare \
   # -nographic
  qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a57 \
    -m 1G \
    -kernel "$KERNEL_IMG" \
    -initrd "$INITRAMFS_OUT" \
    -append "console=ttyAMA0,115200 loglevel=8" \
    -fsdev local,id=hostshare,path="$SHARE_DIR",security_model=none \
    -device virtio-9p-device,fsdev=hostshare,mount_tag=hostshare \
    -serial mon:stdio \
    -chardev pty,id=uart1 \
    -device pci-serial,chardev=uart1 \
    -display none
}

build_module() {
    echo "=== [Task] Building Kernel Module ==="

    MODULE_DIR="${WORKSPACE_DIR}/custom_linux_module"
    MODULE_FILE="${MODULE_DIR}/nfdev_module.ko"
    USERSPACE_APP_DIR=${WORKSPACE_DIR}/userspace
    USER_APP_FILE="${USERSPACE_APP_DIR}/build/user_app"

    if [ ! -d "$MODULE_DIR" ]; then
        echo "Error: Module directory not found: $MODULE_DIR"
        exit 1
    fi

    if [ ! -d "$USERSPACE_APP_DIR" ]; then
        echo "Error: Userspace directory not found: $USERSPACE_APP_DIR"
        exit 1
    fi

    # Clean module build artifacts via kernel build system
    #make -C "$LINUX_DIR" M="$MODULE_DIR" ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE clean
    cd custom_linux_module
    make clean
    # Build userspace first (do NOT clean it afterwards)
    #make -C "$USERSPACE_APP_DIR" CROSS_COMPILE=$CROSS_COMPILE -j"$JOBS"

    make
    # Build the external kernel module using the kernel tree
    #make -C "$LINUX_DIR" M="$MODULE_DIR" ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -j"$JOBS" modules

    if [ ! -f "$MODULE_FILE" ]; then
        echo "Error: Module was not generated: $MODULE_FILE"
        exit 1
    fi

    if [ ! -f "$USER_APP_FILE" ]; then
        echo "Error: Userspace app not found: $USER_APP_FILE"
        exit 1
    fi

    cp -v "$MODULE_FILE" "$SHARE_DIR/nfdev_module.ko"
    cp -v "$USER_APP_FILE" "$SHARE_DIR/user_app"

    echo "=== Module Build Complete ==="
    echo "Workspace Directory: $WORKSPACE_DIR"
    echo "Linux Source Directory: $LINUX_DIR"
    echo "BusyBox Source Directory: $BUSYBOX_DIR"
    echo "Initramfs Output File: $INITRAMFS_OUT"
    echo "Shared Directory for QEMU: $SHARE_DIR"
}
# ==============================================================================
# ARGUMENT ROUTER STRATEGY
# ==============================================================================
case "$1" in
    kernel_clean_build)
        build_kernel
        ;;

    kernel_build)
        just_kernel_build
        ;;

    busybox)
        build_busybox
        ;;
    fs)
        pack_filesystem
        ;;
    run)
        run_qemu
        ;;
    all)
        build_kernel
        build_busybox
        pack_filesystem
        run_qemu
        ;;
    module_build)
        build_module
        ;;
    *)
        show_help
        ;;
esac

