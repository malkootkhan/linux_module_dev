savedcmd_nfdev_chrdev.o := aarch64-linux-gnu-gcc -Wp,-MMD,./.nfdev_chrdev.o.d -nostdinc -I/home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include -I/home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated -I/home/khan/workspace/linux_kernel_module_development/linux/include -I/home/khan/workspace/linux_kernel_module_development/linux/include -I/home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi -I/home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/uapi -I/home/khan/workspace/linux_kernel_module_development/linux/include/uapi -I/home/khan/workspace/linux_kernel_module_development/linux/include/generated/uapi -include /home/khan/workspace/linux_kernel_module_development/linux/include/linux/compiler-version.h -include /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kconfig.h -include /home/khan/workspace/linux_kernel_module_development/linux/include/linux/compiler_types.h -D__KERNEL__ -mlittle-endian -DKASAN_SHADOW_SCALE_SHIFT= -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -std=gnu11 -fms-extensions -mgeneral-regs-only -DCONFIG_CC_HAS_K_CONSTRAINT=1 -Wno-psabi -mabi=lp64 -fno-asynchronous-unwind-tables -fno-unwind-tables -mbranch-protection=pac-ret -Wa,-march=armv8.5-a -DARM64_ASM_ARCH='"armv8.5-a"' -DKASAN_SHADOW_SCALE_SHIFT= -fno-delete-null-pointer-checks -O2 -fno-allow-store-data-races -fstack-protector-strong -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-stack-clash-protection -falign-functions=4 -fno-strict-overflow -fno-stack-check -fconserve-stack -fno-builtin-wcslen -Wall -Wextra -Wundef -Werror=implicit-function-declaration -Werror=implicit-int -Werror=return-type -Werror=strict-prototypes -Wno-format-security -Wno-trigraphs -Wno-frame-address -Wno-address-of-packed-member -Wmissing-declarations -Wmissing-prototypes -Wframe-larger-than=2048 -Wno-main -Wno-type-limits -Wvla-larger-than=1 -Wno-pointer-sign -Wcast-function-type -Wno-array-bounds -Wno-stringop-overflow -Wno-alloc-size-larger-than -Wimplicit-fallthrough=5 -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init -Wenum-conversion -Wunused -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-packed-not-aligned -Wno-format-overflow -Wno-format-truncation -Wno-stringop-truncation -Wno-override-init -Wno-missing-field-initializers -Wno-shift-negative-value -Wno-maybe-uninitialized -Wno-sign-compare -Wno-unused-parameter -g -fno-var-tracking -femit-struct-debug-baseonly -mstack-protector-guard=sysreg -mstack-protector-guard-reg=sp_el0 -mstack-protector-guard-offset=1344  -DMODULE  -DKBUILD_BASENAME='"nfdev_chrdev"' -DKBUILD_MODNAME='"nfdev_module"' -D__KBUILD_MODNAME=nfdev_module -c -o nfdev_chrdev.o nfdev_chrdev.c  

source_nfdev_chrdev.o := nfdev_chrdev.c

deps_nfdev_chrdev.o := \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/compiler_types.h \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/CC_HAS_SANE_FUNCTION_ALIGNMENT) \
    $(wildcard include/config/X86_64) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/LD_DEAD_CODE_DATA_ELIMINATION) \
    $(wildcard include/config/LTO_CLANG) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/KCSAN) \
    $(wildcard include/config/CC_HAS_ASSUME) \
    $(wildcard include/config/CC_HAS_COUNTED_BY) \
    $(wildcard include/config/FORTIFY_SOURCE) \
    $(wildcard include/config/UBSAN_BOUNDS) \
    $(wildcard include/config/CC_HAS_COUNTED_BY_PTR) \
    $(wildcard include/config/CC_HAS_MULTIDIMENSIONAL_NONSTRING) \
    $(wildcard include/config/CFI) \
    $(wildcard include/config/ARCH_USES_CFI_GENERIC_LLVM_PASS) \
    $(wildcard include/config/CC_HAS_BROKEN_COUNTED_BY_REF) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/compiler-context-analysis.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/compiler_attributes.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/compiler-gcc.h \
    $(wildcard include/config/ARCH_USE_BUILTIN_BSWAP) \
    $(wildcard include/config/SHADOW_CALL_STACK) \
    $(wildcard include/config/KCOV) \
    $(wildcard include/config/CC_HAS_TYPEOF_UNQUAL) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/compiler.h \
    $(wildcard include/config/ARM64_PTR_AUTH_KERNEL) \
    $(wildcard include/config/ARM64_PTR_AUTH) \
    $(wildcard include/config/BUILTIN_RETURN_ADDRESS_STRIPS_PAC) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/percpu_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/percpu_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/device.h \
    $(wildcard include/config/DEBUG_LOCK_ALLOC) \
    $(wildcard include/config/GENERIC_MSI_IRQ) \
    $(wildcard include/config/ENERGY_MODEL) \
    $(wildcard include/config/PINCTRL) \
    $(wildcard include/config/ARCH_HAS_DMA_OPS) \
    $(wildcard include/config/DMA_DECLARE_COHERENT) \
    $(wildcard include/config/DMA_CMA) \
    $(wildcard include/config/SWIOTLB) \
    $(wildcard include/config/SWIOTLB_DYNAMIC) \
    $(wildcard include/config/NUMA) \
    $(wildcard include/config/PM) \
    $(wildcard include/config/PM_SLEEP) \
    $(wildcard include/config/LOCKDEP) \
    $(wildcard include/config/OF) \
    $(wildcard include/config/DEVTMPFS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/dev_printk.h \
    $(wildcard include/config/PRINTK) \
    $(wildcard include/config/DYNAMIC_DEBUG) \
    $(wildcard include/config/DYNAMIC_DEBUG_CORE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/rwonce.h \
    $(wildcard include/config/LTO) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/rwonce.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kasan-checks.h \
    $(wildcard include/config/KASAN_GENERIC) \
    $(wildcard include/config/KASAN_SW_TAGS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/types.h \
    $(wildcard include/config/HAVE_UID16) \
    $(wildcard include/config/UID16) \
    $(wildcard include/config/ARCH_DMA_ADDR_T_64BIT) \
    $(wildcard include/config/PHYS_ADDR_T_64BIT) \
    $(wildcard include/config/64BIT) \
    $(wildcard include/config/ARCH_32BIT_USTAT_F_TINODE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/uapi/asm/types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/int-ll64.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/int-ll64.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/bitsperlong.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitsperlong.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/bitsperlong.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/posix_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/stddef.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/stddef.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/posix_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/posix_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kcsan-checks.h \
    $(wildcard include/config/KCSAN_WEAK_MEMORY) \
    $(wildcard include/config/KCSAN_IGNORE_ATOMICS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/ratelimit.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/ratelimit_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/bits.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/bits.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/const.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/const.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/bits.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/build_bug.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/overflow.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/limits.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/limits.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/limits.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/const.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/param.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/param.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/param.h \
    $(wildcard include/config/HZ) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/param.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/spinlock_types_raw.h \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/DEBUG_SPINLOCK) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/spinlock_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/qspinlock_types.h \
    $(wildcard include/config/NR_CPUS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/qrwlock_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/byteorder.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/byteorder/little_endian.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/byteorder/little_endian.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/swab.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/swab.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/uapi/asm/swab.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/swab.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/byteorder/generic.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/lockdep_types.h \
    $(wildcard include/config/PROVE_RAW_LOCK_NESTING) \
    $(wildcard include/config/LOCK_STAT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched.h \
    $(wildcard include/config/DEBUG_ATOMIC_SLEEP) \
    $(wildcard include/config/PREEMPT_RT) \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_NATIVE) \
    $(wildcard include/config/SCHED_INFO) \
    $(wildcard include/config/SCHEDSTATS) \
    $(wildcard include/config/SCHED_CORE) \
    $(wildcard include/config/FAIR_GROUP_SCHED) \
    $(wildcard include/config/RT_GROUP_SCHED) \
    $(wildcard include/config/RT_MUTEXES) \
    $(wildcard include/config/UCLAMP_TASK) \
    $(wildcard include/config/UCLAMP_BUCKETS_COUNT) \
    $(wildcard include/config/KMAP_LOCAL) \
    $(wildcard include/config/THREAD_INFO_IN_TASK) \
    $(wildcard include/config/MEM_ALLOC_PROFILING) \
    $(wildcard include/config/SCHED_CLASS_EXT) \
    $(wildcard include/config/CGROUP_SCHED) \
    $(wildcard include/config/CFS_BANDWIDTH) \
    $(wildcard include/config/PREEMPT_NOTIFIERS) \
    $(wildcard include/config/BLK_DEV_IO_TRACE) \
    $(wildcard include/config/PREEMPT_RCU) \
    $(wildcard include/config/TASKS_RCU) \
    $(wildcard include/config/TASKS_TRACE_RCU) \
    $(wildcard include/config/TRIVIAL_PREEMPT_RCU) \
    $(wildcard include/config/MEMCG_V1) \
    $(wildcard include/config/LRU_GEN) \
    $(wildcard include/config/COMPAT_BRK) \
    $(wildcard include/config/CGROUPS) \
    $(wildcard include/config/BLK_CGROUP) \
    $(wildcard include/config/PSI) \
    $(wildcard include/config/PAGE_OWNER) \
    $(wildcard include/config/EVENTFD) \
    $(wildcard include/config/ARCH_HAS_CPU_PASID) \
    $(wildcard include/config/X86_BUS_LOCK_DETECT) \
    $(wildcard include/config/TASK_DELAY_ACCT) \
    $(wildcard include/config/STACKPROTECTOR) \
    $(wildcard include/config/ARCH_HAS_SCALED_CPUTIME) \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_GEN) \
    $(wildcard include/config/NO_HZ_FULL) \
    $(wildcard include/config/POSIX_CPUTIMERS) \
    $(wildcard include/config/POSIX_CPU_TIMERS_TASK_WORK) \
    $(wildcard include/config/KEYS) \
    $(wildcard include/config/SYSVIPC) \
    $(wildcard include/config/DETECT_HUNG_TASK) \
    $(wildcard include/config/IO_URING) \
    $(wildcard include/config/AUDIT) \
    $(wildcard include/config/AUDITSYSCALL) \
    $(wildcard include/config/DETECT_HUNG_TASK_BLOCKER) \
    $(wildcard include/config/TRACE_IRQFLAGS) \
    $(wildcard include/config/UBSAN) \
    $(wildcard include/config/UBSAN_TRAP) \
    $(wildcard include/config/COMPACTION) \
    $(wildcard include/config/TASK_XACCT) \
    $(wildcard include/config/CPUSETS) \
    $(wildcard include/config/X86_CPU_RESCTRL) \
    $(wildcard include/config/PERF_EVENTS) \
    $(wildcard include/config/DEBUG_PREEMPT) \
    $(wildcard include/config/NUMA_BALANCING) \
    $(wildcard include/config/SCHED_CACHE) \
    $(wildcard include/config/ARCH_HAS_LAZY_MMU_MODE) \
    $(wildcard include/config/FAULT_INJECTION) \
    $(wildcard include/config/LATENCYTOP) \
    $(wildcard include/config/KMSAN) \
    $(wildcard include/config/KUNIT) \
    $(wildcard include/config/FUNCTION_GRAPH_TRACER) \
    $(wildcard include/config/TRACING) \
    $(wildcard include/config/MEMCG) \
    $(wildcard include/config/UPROBES) \
    $(wildcard include/config/BCACHE) \
    $(wildcard include/config/MMU) \
    $(wildcard include/config/VMAP_STACK) \
    $(wildcard include/config/LIVEPATCH) \
    $(wildcard include/config/SECURITY) \
    $(wildcard include/config/BPF_SYSCALL) \
    $(wildcard include/config/KSTACK_ERASE) \
    $(wildcard include/config/KSTACK_ERASE_METRICS) \
    $(wildcard include/config/X86_MCE) \
    $(wildcard include/config/KRETPROBES) \
    $(wildcard include/config/RETHOOK) \
    $(wildcard include/config/ARCH_HAS_PARANOID_L1D_FLUSH) \
    $(wildcard include/config/RV) \
    $(wildcard include/config/RV_PER_TASK_MONITORS) \
    $(wildcard include/config/USER_EVENTS) \
    $(wildcard include/config/UNWIND_USER) \
    $(wildcard include/config/SCHED_PROXY_EXEC) \
    $(wildcard include/config/PREEMPTION) \
    $(wildcard include/config/PREEMPT_DYNAMIC) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_CALL) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_KEY) \
    $(wildcard include/config/MEM_ALLOC_PROFILING_DEBUG) \
    $(wildcard include/config/SCHED_MM_CID) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/sched.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/current.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/processor.h \
    $(wildcard include/config/COMPAT) \
    $(wildcard include/config/ARM64_64K_PAGES) \
    $(wildcard include/config/KUSER_HELPERS) \
    $(wildcard include/config/ARM64_FORCE_52BIT) \
    $(wildcard include/config/HAVE_HW_BREAKPOINT) \
    $(wildcard include/config/ARM64_MTE) \
    $(wildcard include/config/ARM64_GCS) \
    $(wildcard include/config/ARM64_TAGGED_ADDR_ABI) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/cache.h \
    $(wildcard include/config/ARCH_HAS_CACHE_LINE_SIZE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/kernel.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/sysinfo.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/cache.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/cache.h \
    $(wildcard include/config/KASAN_HW_TAGS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/bitops.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/typecheck.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/generic-non-atomic.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/barrier.h \
    $(wildcard include/config/ARM64_PSEUDO_NMI) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/alternative-macros.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/cpucaps.h \
    $(wildcard include/config/ARM64_EPAN) \
    $(wildcard include/config/ARM64_SVE) \
    $(wildcard include/config/ARM64_SME) \
    $(wildcard include/config/ARM64_CNP) \
    $(wildcard include/config/ARM64_BTI) \
    $(wildcard include/config/ARM64_TLB_RANGE) \
    $(wildcard include/config/ARM64_POE) \
    $(wildcard include/config/ARM64_HAFT) \
    $(wildcard include/config/UNMAP_KERNEL_AT_EL0) \
    $(wildcard include/config/ARM64_ERRATUM_843419) \
    $(wildcard include/config/ARM64_ERRATUM_1742098) \
    $(wildcard include/config/ARM64_ERRATUM_2645198) \
    $(wildcard include/config/ARM64_ERRATUM_2658417) \
    $(wildcard include/config/CAVIUM_ERRATUM_23154) \
    $(wildcard include/config/ARM64_WORKAROUND_DISABLE_CNP) \
    $(wildcard include/config/ARM64_WORKAROUND_REPEAT_TLBI) \
    $(wildcard include/config/ARM64_ERRATUM_3194386) \
    $(wildcard include/config/ARM64_ERRATUM_4193714) \
    $(wildcard include/config/HW_PERF_EVENTS) \
    $(wildcard include/config/ARM64_LSUI) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/cpucap-defs.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/insn-def.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/brk-imm.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/stringify.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/barrier.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/bitops.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/builtin-__ffs.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/builtin-ffs.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/builtin-__fls.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/builtin-fls.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/ffz.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/fls64.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/sched.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/hweight.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/arch_hweight.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/const_hweight.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/atomic.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/atomic.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/atomic.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/cmpxchg.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/lse.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/atomic_ll_sc.h \
    $(wildcard include/config/CC_HAS_K_CONSTRAINT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
    $(wildcard include/config/GENDWARFKSYMS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/linkage.h \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/linkage.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/alternative.h \
    $(wildcard include/config/MODULES) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/init.h \
    $(wildcard include/config/MEMORY_HOTPLUG) \
    $(wildcard include/config/HAVE_ARCH_PREL32_RELOCATIONS) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/atomic_lse.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/atomic/atomic-arch-fallback.h \
    $(wildcard include/config/GENERIC_ATOMIC64) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/atomic/atomic-long.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/atomic/atomic-instrumented.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/instrumented.h \
    $(wildcard include/config/DEBUG_ATOMIC) \
    $(wildcard include/config/DEBUG_ATOMIC_LARGEST_ALIGN) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/bug.h \
    $(wildcard include/config/GENERIC_BUG) \
    $(wildcard include/config/BUG_ON_DATA_CORRUPTION) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/bug.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/asm-bug.h \
    $(wildcard include/config/DEBUG_BUGVERBOSE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bug.h \
    $(wildcard include/config/DEBUG_BUGVERBOSE_DETAILED) \
    $(wildcard include/config/BUG) \
    $(wildcard include/config/GENERIC_BUG_RELATIVE_POINTERS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/instrumentation.h \
    $(wildcard include/config/NOINSTR_VALIDATION) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/once_lite.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/panic.h \
    $(wildcard include/config/PANIC_TIMEOUT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/stdarg.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/printk.h \
    $(wildcard include/config/MESSAGE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_QUIET) \
    $(wildcard include/config/EARLY_PRINTK) \
    $(wildcard include/config/PRINTK_INDEX) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kern_levels.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kmsan-checks.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/instrumented-atomic.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/lock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/instrumented-lock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/non-atomic.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/non-instrumented-non-atomic.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/le.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/bitops/ext2-atomic-setbit.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kasan-enabled.h \
    $(wildcard include/config/ARCH_DEFER_KASAN) \
    $(wildcard include/config/KASAN) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/static_key.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/jump_label.h \
    $(wildcard include/config/JUMP_LABEL) \
    $(wildcard include/config/HAVE_ARCH_JUMP_LABEL_RELATIVE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/cleanup.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/err.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/uapi/asm/errno.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/errno.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/errno-base.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/args.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/jump_label.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/insn.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/cputype.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/sysreg.h \
    $(wildcard include/config/BROKEN_GAS_INST) \
    $(wildcard include/config/ARM64_PA_BITS_52) \
    $(wildcard include/config/ARM64_4K_PAGES) \
    $(wildcard include/config/ARM64_16K_PAGES) \
    $(wildcard include/config/AMPERE_ERRATUM_AC04_CPU_23) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kasan-tags.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/gpr-num.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/sysreg-defs.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/bitfield.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/mte-def.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/string.h \
    $(wildcard include/config/BINARY_PRINTF) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/array_size.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/errno.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/errno.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/string.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/string.h \
    $(wildcard include/config/ARCH_HAS_UACCESS_FLUSHCACHE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/thread_info.h \
    $(wildcard include/config/GENERIC_ENTRY) \
    $(wildcard include/config/ARCH_HAS_PREEMPT_LAZY) \
    $(wildcard include/config/HAVE_ARCH_WITHIN_STACK_FRAMES) \
    $(wildcard include/config/SH) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/restart_block.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/time64.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/math64.h \
    $(wildcard include/config/ARCH_SUPPORTS_INT128) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/math.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/div64.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/div64.h \
    $(wildcard include/config/CC_OPTIMIZE_FOR_PERFORMANCE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/math64.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/time64.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/time.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/time_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/thread_info.h \
    $(wildcard include/config/ARM64_SW_TTBR0_PAN) \
    $(wildcard include/config/ARM64_MPAM) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/memory.h \
    $(wildcard include/config/ARM64_VA_BITS) \
    $(wildcard include/config/KASAN_SHADOW_OFFSET) \
    $(wildcard include/config/RANDOMIZE_BASE) \
    $(wildcard include/config/DEBUG_VIRTUAL) \
    $(wildcard include/config/EFI) \
    $(wildcard include/config/ARM_GIC_V3_ITS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sizes.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/page-def.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/page.h \
    $(wildcard include/config/PAGE_SHIFT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/mmdebug.h \
    $(wildcard include/config/DEBUG_VM) \
    $(wildcard include/config/DEBUG_VM_IRQSOFF) \
    $(wildcard include/config/DEBUG_VM_PGFLAGS) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/boot.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/sections.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/sections.h \
    $(wildcard include/config/HAVE_FUNCTION_DESCRIPTORS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/memory_model.h \
    $(wildcard include/config/FLATMEM) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP) \
    $(wildcard include/config/SPARSEMEM) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/pfn.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/stack_pointer.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/processor.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/vdso/processor.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/cpufeature.h \
    $(wildcard include/config/ARM64_DEBUG_PRIORITY_MASKING) \
    $(wildcard include/config/ARM64_BTI_KERNEL) \
    $(wildcard include/config/ARM64_PA_BITS) \
    $(wildcard include/config/ARM64_HW_AFDBM) \
    $(wildcard include/config/ARM64_AMU_EXTN) \
    $(wildcard include/config/ARM64_LPA2) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/hwcap.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/hwcap.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/log2.h \
    $(wildcard include/config/ARCH_HAS_ILOG2_U32) \
    $(wildcard include/config/ARCH_HAS_ILOG2_U64) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/kernel-hwcap.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kernel.h \
    $(wildcard include/config/PREEMPT_VOLUNTARY_BUILD) \
    $(wildcard include/config/PREEMPT_) \
    $(wildcard include/config/PROVE_LOCKING) \
    $(wildcard include/config/DYNAMIC_FTRACE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/align.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/align.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/container_of.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kstrtox.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/minmax.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sprintf.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/static_call_types.h \
    $(wildcard include/config/HAVE_STATIC_CALL) \
    $(wildcard include/config/HAVE_STATIC_CALL_INLINE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/trace_printk.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/instruction_pointer.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/util_macros.h \
    $(wildcard include/config/FOO_SUSPEND) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/wordpart.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/cpumask.h \
    $(wildcard include/config/FORCE_NR_CPUS) \
    $(wildcard include/config/HOTPLUG_CPU) \
    $(wildcard include/config/DEBUG_PER_CPU_MAPS) \
    $(wildcard include/config/CPUMASK_OFFSTACK) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/bitmap.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/find.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/bitmap-str.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/cpumask_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/threads.h \
    $(wildcard include/config/BASE_SMALL) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/gfp_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/numa.h \
    $(wildcard include/config/NUMA_KEEP_MEMINFO) \
    $(wildcard include/config/HAVE_ARCH_NODE_DEV_GROUP) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/nodemask.h \
    $(wildcard include/config/HIGHMEM) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/nodemask_types.h \
    $(wildcard include/config/NODES_SHIFT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/random.h \
    $(wildcard include/config/VMGENID) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/list.h \
    $(wildcard include/config/LIST_HARDENED) \
    $(wildcard include/config/DEBUG_LIST) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/poison.h \
    $(wildcard include/config/ILLEGAL_POINTER_VALUE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/random.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/ioctl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/uapi/asm/ioctl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/ioctl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/ioctl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/irqnr.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/irqnr.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/sparsemem.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/pgtable-prot.h \
    $(wildcard include/config/HAVE_ARCH_USERFAULTFD_WP) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/pgtable-hwdef.h \
    $(wildcard include/config/PGTABLE_LEVELS) \
    $(wildcard include/config/ARM64_CONT_PTE_SHIFT) \
    $(wildcard include/config/ARM64_CONT_PMD_SHIFT) \
    $(wildcard include/config/ARM64_VA_BITS_52) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/pgtable-types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/rsi.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/rsi_cmds.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/arm-smccc.h \
    $(wildcard include/config/HAVE_ARM_SMCCC) \
    $(wildcard include/config/ARM) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/uuid.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/rsi_smc.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/hw_breakpoint.h \
    $(wildcard include/config/CPU_PM) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/virt.h \
    $(wildcard include/config/KVM) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/ptrace.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/ptrace.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/sve_context.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/irqchip/arm-gic-v3-prio.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/stacktrace/frame.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/kasan.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/mte-kasan.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/pointer_auth.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/prctl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/spectre.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/smp.h \
    $(wildcard include/config/UP_LATE_INIT) \
    $(wildcard include/config/CSD_LOCK_WAIT_DEBUG) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/smp_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/llist.h \
    $(wildcard include/config/ARCH_HAVE_NMI_SAFE_CMPXCHG) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/preempt.h \
    $(wildcard include/config/PREEMPT_COUNT) \
    $(wildcard include/config/TRACE_PREEMPT_TOGGLE) \
    $(wildcard include/config/PREEMPT_NONE) \
    $(wildcard include/config/PREEMPT_VOLUNTARY) \
    $(wildcard include/config/PREEMPT) \
    $(wildcard include/config/PREEMPT_LAZY) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/preempt.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/smp.h \
    $(wildcard include/config/ARM64_ACPI_PARKING_PROTOCOL) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/percpu.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/percpu.h \
    $(wildcard include/config/HAVE_SETUP_PER_CPU_AREA) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/percpu-defs.h \
    $(wildcard include/config/ARCH_MODULE_NEEDS_WEAK_PER_CPU) \
    $(wildcard include/config/DEBUG_FORCE_WEAK_PER_CPU) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/fpsimd.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/sigcontext.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/futex_types.h \
    $(wildcard include/config/FUTEX) \
    $(wildcard include/config/FUTEX_PRIVATE_HASH) \
    $(wildcard include/config/FUTEX_ROBUST_UNLOCK) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/mutex_types.h \
    $(wildcard include/config/MUTEX_SPIN_ON_OWNER) \
    $(wildcard include/config/DEBUG_MUTEXES) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/osq_lock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/spinlock_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rwlock_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/irqflags_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/pid_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sem_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/shm.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/page.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/personality.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/personality.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/getorder.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/shmparam.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/shmparam.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kmsan_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/plist_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/hrtimer_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/timerqueue_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rbtree_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/timer_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/seccomp_types.h \
    $(wildcard include/config/SECCOMP) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/refcount_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/resource.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/resource.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/uapi/asm/resource.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/resource.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/resource.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/latencytop.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/prio.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/signal_types.h \
    $(wildcard include/config/OLD_SIGACTION) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/signal.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/signal.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/signal.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/signal.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/signal.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/signal-defs.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/uapi/asm/siginfo.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/siginfo.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/spinlock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/irqflags.h \
    $(wildcard include/config/IRQSOFF_TRACER) \
    $(wildcard include/config/PREEMPT_TRACER) \
    $(wildcard include/config/DEBUG_IRQFLAGS) \
    $(wildcard include/config/TRACE_IRQFLAGS_SUPPORT) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/irqflags.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/bottom_half.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/lockdep.h \
    $(wildcard include/config/DEBUG_LOCKING_API_SELFTESTS) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/mmiowb.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/mmiowb.h \
    $(wildcard include/config/MMIOWB) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/spinlock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/qspinlock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/qspinlock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/qrwlock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/qrwlock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rwlock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/spinlock_api_smp.h \
    $(wildcard include/config/INLINE_SPIN_LOCK) \
    $(wildcard include/config/INLINE_SPIN_LOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK_BH) \
    $(wildcard include/config/UNINLINE_SPIN_UNLOCK) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/GENERIC_LOCKBREAK) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rwlock_api_smp.h \
    $(wildcard include/config/INLINE_READ_LOCK) \
    $(wildcard include/config/INLINE_WRITE_LOCK) \
    $(wildcard include/config/INLINE_READ_LOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_LOCK_BH) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_READ_TRYLOCK) \
    $(wildcard include/config/INLINE_WRITE_TRYLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_BH) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQRESTORE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/syscall_user_dispatch_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/mm_types_task.h \
    $(wildcard include/config/ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/tlbbatch.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/netdevice_xmit.h \
    $(wildcard include/config/NET_ACT_MIRRED) \
    $(wildcard include/config/NET_EGRESS) \
    $(wildcard include/config/NF_DUP_NETDEV) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/task_io_accounting.h \
    $(wildcard include/config/TASK_IO_ACCOUNTING) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/posix-timers_types.h \
    $(wildcard include/config/POSIX_TIMERS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rseq_types.h \
    $(wildcard include/config/RSEQ) \
    $(wildcard include/config/RSEQ_SLICE_EXTENSION) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/irq_work_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/workqueue_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/seqlock_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kcsan.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rv.h \
    $(wildcard include/config/RV_LTL_MONITOR) \
    $(wildcard include/config/RV_HA_MONITOR) \
    $(wildcard include/config/RV_REACTORS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/uidgid_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/tracepoint-defs.h \
    $(wildcard include/config/TRACEPOINTS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/unwind_deferred_types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/kmap_size.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/kmap_size.h \
    $(wildcard include/config/DEBUG_KMAP_LOCAL) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/generated/rq-offsets.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/ext.h \
    $(wildcard include/config/EXT_GROUP_SCHED) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/energy_model.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kobject.h \
    $(wildcard include/config/UEVENT_HELPER) \
    $(wildcard include/config/DEBUG_KOBJECT_RELEASE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sysfs.h \
    $(wildcard include/config/SYSFS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kernfs.h \
    $(wildcard include/config/KERNFS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/mutex.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/debug_locks.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/idr.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/radix-tree.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/percpu.h \
    $(wildcard include/config/KMALLOC_PARTITION_CACHES) \
    $(wildcard include/config/PAGE_SIZE_4KB) \
    $(wildcard include/config/NEED_PER_CPU_PAGE_FIRST_CHUNK) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/alloc_tag.h \
    $(wildcard include/config/MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/codetag.h \
    $(wildcard include/config/CODE_TAGGING) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rcupdate.h \
    $(wildcard include/config/TINY_RCU) \
    $(wildcard include/config/RCU_STRICT_GRACE_PERIOD) \
    $(wildcard include/config/RCU_LAZY) \
    $(wildcard include/config/RCU_STALL_COMMON) \
    $(wildcard include/config/VIRT_XFER_TO_GUEST_WORK) \
    $(wildcard include/config/RCU_NOCB_CPU) \
    $(wildcard include/config/TASKS_RCU_GENERIC) \
    $(wildcard include/config/TASKS_RUDE_RCU) \
    $(wildcard include/config/TREE_RCU) \
    $(wildcard include/config/DEBUG_OBJECTS_RCU_HEAD) \
    $(wildcard include/config/PROVE_RCU) \
    $(wildcard include/config/ARCH_WEAK_RELEASE_ACQUIRE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/context_tracking_irq.h \
    $(wildcard include/config/CONTEXT_TRACKING_IDLE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rcutree.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/xarray.h \
    $(wildcard include/config/XARRAY_MULTI) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/gfp.h \
    $(wildcard include/config/ZONE_DMA) \
    $(wildcard include/config/ZONE_DMA32) \
    $(wildcard include/config/ZONE_DEVICE) \
    $(wildcard include/config/CONTIG_ALLOC) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/mmzone.h \
    $(wildcard include/config/ARCH_FORCE_MAX_ORDER) \
    $(wildcard include/config/PAGE_BLOCK_MAX_ORDER) \
    $(wildcard include/config/HAVE_GIGANTIC_FOLIOS) \
    $(wildcard include/config/HUGETLB_PAGE) \
    $(wildcard include/config/HUGETLB_PAGE_OPTIMIZE_VMEMMAP) \
    $(wildcard include/config/CMA) \
    $(wildcard include/config/MEMORY_ISOLATION) \
    $(wildcard include/config/ZSMALLOC) \
    $(wildcard include/config/UNACCEPTED_MEMORY) \
    $(wildcard include/config/IOMMU_SUPPORT) \
    $(wildcard include/config/SWAP) \
    $(wildcard include/config/TRANSPARENT_HUGEPAGE) \
    $(wildcard include/config/LRU_GEN_STATS) \
    $(wildcard include/config/LRU_GEN_WALKS_MMU) \
    $(wildcard include/config/MEMORY_FAILURE) \
    $(wildcard include/config/PAGE_EXTENSION) \
    $(wildcard include/config/DEFERRED_STRUCT_PAGE_INIT) \
    $(wildcard include/config/HAVE_MEMORYLESS_NODES) \
    $(wildcard include/config/SPARSEMEM_EXTREME) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP_PREINIT) \
    $(wildcard include/config/HAVE_ARCH_PFN_VALID) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/list_nulls.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/wait.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/seqlock.h \
    $(wildcard include/config/CC_IS_GCC) \
    $(wildcard include/config/GCC_VERSION) \
    $(wildcard include/config/UBSAN_ALIGNMENT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/pageblock-flags.h \
    $(wildcard include/config/HUGETLB_PAGE_SIZE_VARIABLE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/page-flags-layout.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/generated/bounds.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/mm_types.h \
    $(wildcard include/config/HAVE_ALIGNED_STRUCT_PAGE) \
    $(wildcard include/config/SLAB_OBJ_EXT) \
    $(wildcard include/config/HUGETLB_PMD_PAGE_TABLE_SHARING) \
    $(wildcard include/config/SLAB_FREELIST_HARDENED) \
    $(wildcard include/config/USERFAULTFD) \
    $(wildcard include/config/ANON_VMA_NAME) \
    $(wildcard include/config/PER_VMA_LOCK) \
    $(wildcard include/config/HAVE_ARCH_COMPAT_MMAP_BASES) \
    $(wildcard include/config/MEMBARRIER) \
    $(wildcard include/config/ARCH_HAS_ELF_CORE_EFLAGS) \
    $(wildcard include/config/AIO) \
    $(wildcard include/config/MMU_NOTIFIER) \
    $(wildcard include/config/SPLIT_PMD_PTLOCKS) \
    $(wildcard include/config/IOMMU_MM_DATA) \
    $(wildcard include/config/KSM) \
    $(wildcard include/config/MM_ID) \
    $(wildcard include/config/CORE_DUMP_DEFAULT_ELF_HEADERS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/auxvec.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/auxvec.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/auxvec.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kref.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/refcount.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rbtree.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/maple_tree.h \
    $(wildcard include/config/MAPLE_RCU_DISABLED) \
    $(wildcard include/config/DEBUG_MAPLE_TREE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rwsem.h \
    $(wildcard include/config/RWSEM_SPIN_ON_OWNER) \
    $(wildcard include/config/DEBUG_RWSEMS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/completion.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/swait.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/uprobes.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/timer.h \
    $(wildcard include/config/DEBUG_OBJECTS_TIMERS) \
    $(wildcard include/config/NO_HZ_COMMON) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/ktime.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/jiffies.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/time.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/time32.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/timex.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/timex.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/timex.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/arch_timer.h \
    $(wildcard include/config/ARM_ARCH_TIMER_OOL_WORKAROUND) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/clocksource/arm_arch_timer.h \
    $(wildcard include/config/ARM_ARCH_TIMER) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/timecounter.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/timex.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/time32.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/time.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/jiffies.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/generated/timeconst.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/vdso/ktime.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/timekeeping.h \
    $(wildcard include/config/POSIX_AUX_CLOCKS) \
    $(wildcard include/config/GENERIC_CMOS_UPDATE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/clocksource_ids.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/debugobjects.h \
    $(wildcard include/config/DEBUG_OBJECTS) \
    $(wildcard include/config/DEBUG_OBJECTS_FREE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/workqueue.h \
    $(wildcard include/config/DEBUG_OBJECTS_WORK) \
    $(wildcard include/config/FREEZER) \
    $(wildcard include/config/WQ_WATCHDOG) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/percpu_counter.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/mmu.h \
    $(wildcard include/config/ARM64_E0PD) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/page-flags.h \
    $(wildcard include/config/PAGE_IDLE_FLAG) \
    $(wildcard include/config/ARCH_USES_PG_ARCH_2) \
    $(wildcard include/config/ARCH_USES_PG_ARCH_3) \
    $(wildcard include/config/MIGRATION) \
    $(wildcard include/config/DEBUG_KMAP_LOCAL_FORCE_MAP) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/local_lock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/local_lock_internal.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/zswap.h \
    $(wildcard include/config/ZSWAP) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/memory_hotplug.h \
    $(wildcard include/config/ARCH_HAS_ADD_PAGES) \
    $(wildcard include/config/MEMORY_HOTREMOVE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/notifier.h \
    $(wildcard include/config/TREE_SRCU) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/srcu.h \
    $(wildcard include/config/TINY_SRCU) \
    $(wildcard include/config/NEED_SRCU_NMI_SAFE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rcu_segcblist.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/srcutree.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rcu_node_tree.h \
    $(wildcard include/config/RCU_FANOUT) \
    $(wildcard include/config/RCU_FANOUT_LEAF) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/mmzone.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/mmzone.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/topology.h \
    $(wildcard include/config/USE_PERCPU_NUMA_NODE_ID) \
    $(wildcard include/config/SCHED_SMT) \
    $(wildcard include/config/GENERIC_ARCH_TOPOLOGY) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/arch_topology.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/topology.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/numa.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/numa.h \
    $(wildcard include/config/NUMA_EMU) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/topology.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/mm.h \
    $(wildcard include/config/MMU_LAZY_TLB_REFCOUNT) \
    $(wildcard include/config/ARCH_HAS_MEMBARRIER_CALLBACKS) \
    $(wildcard include/config/ARCH_HAS_SYNC_CORE_BEFORE_USERMODE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sync_core.h \
    $(wildcard include/config/ARCH_HAS_PREPARE_SYNC_CORE_CMD) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/coredump.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/uidgid.h \
    $(wildcard include/config/MULTIUSER) \
    $(wildcard include/config/USER_NS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/highuid.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kobject_ns.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/stat.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/stat.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/uapi/asm/stat.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/stat.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/compat.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/compat.h \
    $(wildcard include/config/COMPAT_FOR_U64_ALIGNMENT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/task_stack.h \
    $(wildcard include/config/STACK_GROWSUP) \
    $(wildcard include/config/DEBUG_STACK_USAGE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/magic.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kasan.h \
    $(wildcard include/config/KASAN_STACK) \
    $(wildcard include/config/KASAN_VMALLOC) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/stat.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/cpufreq.h \
    $(wildcard include/config/CPU_FREQ) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/topology.h \
    $(wildcard include/config/SCHED_CLUSTER) \
    $(wildcard include/config/SCHED_MC) \
    $(wildcard include/config/CPU_FREQ_GOV_SCHEDUTIL) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/idle.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/sd_flags.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/ioport.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/klist.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/pm.h \
    $(wildcard include/config/VT_CONSOLE_SLEEP) \
    $(wildcard include/config/CXL_SUSPEND) \
    $(wildcard include/config/PM_CLK) \
    $(wildcard include/config/PM_GENERIC_DOMAINS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/device/bus.h \
    $(wildcard include/config/ACPI) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/device/class.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/device/devres.h \
    $(wildcard include/config/HAS_IOMEM) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/device/driver.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/module.h \
    $(wildcard include/config/MODULES_TREE_LOOKUP) \
    $(wildcard include/config/STACKTRACE_BUILD_ID) \
    $(wildcard include/config/ARCH_USES_CFI_TRAPS) \
    $(wildcard include/config/MODULE_SIG) \
    $(wildcard include/config/KALLSYMS) \
    $(wildcard include/config/BPF_EVENTS) \
    $(wildcard include/config/DEBUG_INFO_BTF_MODULES) \
    $(wildcard include/config/EVENT_TRACING) \
    $(wildcard include/config/KPROBES) \
    $(wildcard include/config/MODULE_UNLOAD) \
    $(wildcard include/config/CONSTRUCTORS) \
    $(wildcard include/config/FUNCTION_ERROR_INJECTION) \
    $(wildcard include/config/MITIGATION_RETPOLINE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/buildid.h \
    $(wildcard include/config/VMCORE_INFO) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kmod.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/umh.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sysctl.h \
    $(wildcard include/config/SYSCTL) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/sysctl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/elf.h \
    $(wildcard include/config/ARCH_HAVE_EXTRA_ELF_NOTES) \
    $(wildcard include/config/ARCH_USE_GNU_PROPERTY) \
    $(wildcard include/config/ARCH_HAVE_ELF_PROT) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/elf.h \
    $(wildcard include/config/COMPAT_VDSO) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/user.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/user.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/elf.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/elf-em.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/fs.h \
    $(wildcard include/config/FANOTIFY_ACCESS_PERMISSIONS) \
    $(wildcard include/config/FS_POSIX_ACL) \
    $(wildcard include/config/CGROUP_WRITEBACK) \
    $(wildcard include/config/IMA) \
    $(wildcard include/config/FILE_LOCKING) \
    $(wildcard include/config/FSNOTIFY) \
    $(wildcard include/config/EPOLL) \
    $(wildcard include/config/FS_DAX) \
    $(wildcard include/config/BLOCK) \
    $(wildcard include/config/UNICODE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/fs/super.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/fs/super_types.h \
    $(wildcard include/config/QUOTA) \
    $(wildcard include/config/FS_ENCRYPTION) \
    $(wildcard include/config/FS_VERITY) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/fs_dirent.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/errseq.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/list_lru.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/shrinker.h \
    $(wildcard include/config/SHRINKER_DEBUG) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/list_bl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/bit_spinlock.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/percpu-rwsem.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rcuwait.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/signal.h \
    $(wildcard include/config/SCHED_AUTOGROUP) \
    $(wildcard include/config/BSD_PROCESS_ACCT) \
    $(wildcard include/config/TASKSTATS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rculist.h \
    $(wildcard include/config/PROVE_RCU_LIST) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/signal.h \
    $(wildcard include/config/DYNAMIC_SIGFRAME) \
    $(wildcard include/config/PROC_FS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/jobctl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/task.h \
    $(wildcard include/config/HAVE_EXIT_THREAD) \
    $(wildcard include/config/ARCH_WANTS_DYNAMIC_TASK_STRUCT) \
    $(wildcard include/config/HAVE_ARCH_THREAD_STRUCT_WHITELIST) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/uaccess.h \
    $(wildcard include/config/ARCH_HAS_SUBPAGE_FAULTS) \
    $(wildcard include/config/ARCH_MEMORY_ORDER_TSO) \
    $(wildcard include/config/HARDENED_USERCOPY) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/fault-inject-usercopy.h \
    $(wildcard include/config/FAULT_INJECTION_USERCOPY) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/nospec.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/ucopysize.h \
    $(wildcard include/config/HARDENED_USERCOPY_DEFAULT_ON) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/uaccess.h \
    $(wildcard include/config/CC_HAS_ASM_GOTO_OUTPUT) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/kernel-pgtable.h \
    $(wildcard include/config/RELOCATABLE) \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/asm-extable.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/mte.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/extable.h \
    $(wildcard include/config/BPF_JIT) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/access_ok.h \
    $(wildcard include/config/ALTERNATE_USER_ADDRESS_SPACE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/cred.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/capability.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/capability.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/key.h \
    $(wildcard include/config/KEY_NOTIFICATIONS) \
    $(wildcard include/config/NET) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/assoc_array.h \
    $(wildcard include/config/ASSOCIATIVE_ARRAY) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/user.h \
    $(wildcard include/config/VFIO_PCI_ZDEV_KVM) \
    $(wildcard include/config/IOMMUFD) \
    $(wildcard include/config/WATCH_QUEUE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/pid.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rhashtable-types.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/posix-timers.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/alarmtimer.h \
    $(wildcard include/config/RTC_CLASS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/hrtimer.h \
    $(wildcard include/config/HIGH_RES_TIMERS) \
    $(wildcard include/config/TIME_LOW_RES) \
    $(wildcard include/config/TIMERFD) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/hrtimer_defs.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/timerqueue.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/hrtimer_rearm.h \
    $(wildcard include/config/HRTIMER_REARM_DEFERRED) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rcuref.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rcu_sync.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/quota.h \
    $(wildcard include/config/QUOTA_NETLINK_INTERFACE) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/dqblk_xfs.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/dqblk_v1.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/dqblk_v2.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/dqblk_qtree.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/projid.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/quota.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/unicode.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/dcache.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rculist_bl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/lockref.h \
    $(wildcard include/config/ARCH_USE_CMPXCHG_LOCKREF) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/stringhash.h \
    $(wildcard include/config/DCACHE_WORD_ACCESS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/hash.h \
    $(wildcard include/config/HAVE_ARCH_HASH) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/vfsdebug.h \
    $(wildcard include/config/DEBUG_VFS) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/wait_bit.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kdev_t.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/kdev_t.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/path.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/semaphore.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/fcntl.h \
    $(wildcard include/config/ARCH_32BIT_OFF_T) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/fcntl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/uapi/asm/fcntl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/asm-generic/fcntl.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/openat2.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/migrate_mode.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/delayed_call.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/ioprio.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/sched/rt.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/iocontext.h \
    $(wildcard include/config/BLK_ICQ) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/ioprio.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/mount.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/mnt_idmapping.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/slab.h \
    $(wildcard include/config/FAILSLAB) \
    $(wildcard include/config/KFENCE) \
    $(wildcard include/config/SLUB_TINY) \
    $(wildcard include/config/SLUB_DEBUG) \
    $(wildcard include/config/KMALLOC_PARTITION_RANDOM) \
    $(wildcard include/config/KMALLOC_PARTITION_TYPED) \
    $(wildcard include/config/SLAB_BUCKETS) \
    $(wildcard include/config/KVFREE_RCU_BATCHED) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/percpu-refcount.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rw_hint.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/file_ref.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/uapi/linux/fs.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/moduleparam.h \
    $(wildcard include/config/ALPHA) \
    $(wildcard include/config/PPC64) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/rbtree_latch.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/error-injection.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/error-injection.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/dynamic_debug.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/asm/module.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/module.h \
    $(wildcard include/config/HAVE_MOD_ARCH_SPECIFIC) \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/device-id/acpi.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/device-id/of.h \
  /home/khan/workspace/linux_kernel_module_development/linux/arch/arm64/include/generated/asm/device.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/asm-generic/device.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/pm_wakeup.h \
  nfdev_internal.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/cdev.h \
  nfdev_uart.h \
  /home/khan/workspace/linux_kernel_module_development/linux/include/linux/kfifo.h \
  nfdev_ioctl.h \

nfdev_chrdev.o: $(deps_nfdev_chrdev.o)

$(deps_nfdev_chrdev.o):
