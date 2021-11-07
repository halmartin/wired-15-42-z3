SUMMARY = "Kernel headers for the C library's use"
SECTION = "devel"
LICENSE = "GPLv2"

# Set PV = kernel version (with wildcards removed).
# NOTE: We only set PV to the linux version if linux version is set. In case of
#       switch-polaris, there's no kernel so we wouldn't set it.
python __anonymous() {
    linux_version = d.getVar("PREFERRED_VERSION_linux-meraki")
    if linux_version:
        pv = linux_version.replace('%', '')
    else:
        # Dummy value in case no kernel is being built.
        pv = "1.0"

    d.setVar("PV", pv)
}

# Use the same sources as the kernel.
S = "${TMPDIR}/work-shared/${MACHINE}/kernel-source"
B = "${WORKDIR}/build"

inherit kernel-arch pkgconfig multilib_header

EXTRA_OEMAKE = " HOSTCC="${BUILD_CC}" HOSTCPP="${BUILD_CPP}""

# Since we are using the same sources as the kernel, we don't need to do any of
# the fetch tasks.
deltask do_fetch
deltask do_unpack
deltask do_patch

# Make sure kernel is checked out and patched since this recipe builds off of
# the main kernel.
do_configure[depends] += "virtual/kernel:do_patch"
do_configure[cleandirs] = "${B}"
do_configure() {
    oe_runmake_call -C ${S} O=${B} allnoconfig
}

do_compile() {
}

do_install() {
    oe_runmake headers_install INSTALL_HDR_PATH=${D}${exec_prefix}
    # Kernel should not be exporting this header
    rm -f ${D}${exec_prefix}/include/scsi/scsi.h

    # The ..install.cmd conflicts between various configure runs
    find ${D}${includedir} -name ..install.cmd | xargs rm -f
}

do_install_append_aarch64 () {
    do_install_armmultilib
}

do_install_append_arm () {
    do_install_armmultilib
}

do_install_armmultilib () {
    oe_multilib_header asm/auxvec.h asm/bitsperlong.h asm/byteorder.h asm/fcntl.h asm/hwcap.h asm/ioctls.h asm/kvm.h asm/mman.h asm/param.h asm/perf_regs.h
    oe_multilib_header asm/posix_types.h asm/ptrace.h  asm/setup.h  asm/sigcontext.h asm/siginfo.h asm/signal.h asm/stat.h  asm/statfs.h asm/swab.h  asm/types.h asm/unistd.h
}

BBCLASSEXTEND = "nativesdk"

RDEPENDS_${PN}-dev = ""
RRECOMMENDS_${PN}-dbg = "${PN}-dev (= ${EXTENDPKGV})"

INHIBIT_DEFAULT_DEPS = "1"
DEPENDS += "unifdef-native"
