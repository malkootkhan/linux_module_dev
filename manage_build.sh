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

# External dependency sources (override with environment variables when needed)
LINUX_REPO_URL="${LINUX_REPO_URL:-https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git}"
LINUX_REPO_REF="${LINUX_REPO_REF:-linux-6.6.y}"
LINUX_CLONE_DEPTH="${LINUX_CLONE_DEPTH:-1}"

BUSYBOX_REPO_URL="${BUSYBOX_REPO_URL:-https://git.busybox.net/busybox}"
BUSYBOX_REPO_REF="${BUSYBOX_REPO_REF:-1_36_stable}"
BUSYBOX_CLONE_DEPTH="${BUSYBOX_CLONE_DEPTH:-1}"

# Set AUTO_FETCH_DEPS=0 to disable implicit cloning.
AUTO_FETCH_DEPS="${AUTO_FETCH_DEPS:-1}"

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
    echo "  deps_fetch - Clone Linux and BusyBox source trees if missing"
    echo "  deps_status - Show which external dependencies are present"
    echo "  fs        - Assemble standard directories, write init script, pack initramfs"
    echo "  run       - Launch the custom compiled Image and root filesystem inside QEMU"
    echo "  all       - Sequentially execute: kernel -> busybox -> fs -> run"
    echo "  module_build - Build the kernel module and copy it to the shared directory"
    echo ""
    echo "Environment overrides:"
    echo "  AUTO_FETCH_DEPS=0             Disable automatic clone of missing dependencies"
    echo "  LINUX_REPO_URL / LINUX_REPO_REF / LINUX_CLONE_DEPTH"
    echo "  BUSYBOX_REPO_URL / BUSYBOX_REPO_REF / BUSYBOX_CLONE_DEPTH"
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

require_command() {
    local cmd="$1"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: Required command not found: $cmd"
        exit 1
    fi
}

clone_if_missing() {
    local dep_name="$1"
    local dep_dir="$2"
    local dep_url="$3"
    local dep_ref="$4"
    local dep_depth="$5"

    if [ -d "$dep_dir/.git" ]; then
        echo "--> $dep_name already present at $dep_dir"
        return 0
    fi

    if [ -d "$dep_dir" ] && [ "$(find "$dep_dir" -mindepth 1 -maxdepth 1 2>/dev/null | wc -l)" -gt 0 ]; then
        echo "Error: $dep_name directory exists but is not a git checkout: $dep_dir"
        echo "Please clean it manually or rename it, then retry."
        exit 1
    fi

    require_command git

    echo "--> Cloning $dep_name"
    echo "    URL: $dep_url"
    echo "    REF: $dep_ref"
    echo "    DEPTH: $dep_depth"

    git clone --branch "$dep_ref" --depth "$dep_depth" "$dep_url" "$dep_dir"
}

fetch_dependencies() {
    echo "=== [Task] Fetching External Dependencies ==="
    clone_if_missing "Linux kernel" "$LINUX_DIR" "$LINUX_REPO_URL" "$LINUX_REPO_REF" "$LINUX_CLONE_DEPTH"
    clone_if_missing "BusyBox" "$BUSYBOX_DIR" "$BUSYBOX_REPO_URL" "$BUSYBOX_REPO_REF" "$BUSYBOX_CLONE_DEPTH"
    echo "=== Dependency Fetch Complete ==="
}

show_dependencies_status() {
    echo "=== [Task] Dependency Status ==="

    if [ -d "$LINUX_DIR/.git" ]; then
        echo "Linux: present ($LINUX_DIR)"
    else
        echo "Linux: missing ($LINUX_DIR)"
    fi

    if [ -d "$BUSYBOX_DIR/.git" ]; then
        echo "BusyBox: present ($BUSYBOX_DIR)"
    else
        echo "BusyBox: missing ($BUSYBOX_DIR)"
    fi
}

ensure_dependency() {
    local dep_name="$1"
    local dep_dir="$2"
    local dep_url="$3"
    local dep_ref="$4"
    local dep_depth="$5"

    if [ -d "$dep_dir/.git" ]; then
        return 0
    fi

    if [ "$AUTO_FETCH_DEPS" != "1" ]; then
        echo "Error: $dep_name source missing at $dep_dir"
        echo "Run: $0 deps_fetch"
        echo "(or re-enable automatic fetch with AUTO_FETCH_DEPS=1)"
        exit 1
    fi

    echo "--> Missing dependency detected: $dep_name"
    clone_if_missing "$dep_name" "$dep_dir" "$dep_url" "$dep_ref" "$dep_depth"
}

ensure_linux() {
    ensure_dependency "Linux kernel" "$LINUX_DIR" "$LINUX_REPO_URL" "$LINUX_REPO_REF" "$LINUX_CLONE_DEPTH"
}

ensure_busybox() {
    ensure_dependency "BusyBox" "$BUSYBOX_DIR" "$BUSYBOX_REPO_URL" "$BUSYBOX_REPO_REF" "$BUSYBOX_CLONE_DEPTH"
}

build_kernel() {
    echo "=== [Task] Building Linux Kernel ==="
    ensure_linux
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
    ensure_linux
    cd "$LINUX_DIR"
    
    echo "--> Compiling kernel image and modules (Threads: $JOBS)..."
    make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -j$JOBS Image modules
    echo "=== Kernel Build Complete ==="
}

build_busybox() {
    echo "=== [Task] Building BusyBox User Space ==="
    ensure_busybox
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
    ensure_linux

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
    cd "$MODULE_DIR"
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
    deps_fetch)
        fetch_dependencies
        ;;

    deps_status)
        show_dependencies_status
        ;;

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

