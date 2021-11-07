DESCRIPTION = "A client for WMI"
LICENSE = "GPLv2"
SECTION = "network"

LIC_FILES_CHKSUM = "file://Samba/COPYING;md5=8ca43cbc842c2336e835926c2166c28b"

DEPENDS += "wmi-native"

require wmi.inc

CACHED_CONFIGUREVARS += "SMB_BUILD_CC_NEGATIVE_ENUM_VALUES=yes \
                         ac_cv_path_PKG_CONFIG=no \
                         ac_cv_sizeof_int=4 \
                         ac_cv_sizeof_long=${@bb.utils.contains("SITEINFO_BITS", "32", "4", "8", d)} \
                         ac_cv_sizeof_short=2 \
                         libreplace_cv_READDIR_NEEDED=no \
                         libreplace_cv_USABLE_NET_IF_H=yes \
                         libreplace_cv_dlfcn=no \
                         libreplace_cv_immediate_structures=yes \
                         samba_cv_HAVE_C99_VSNPRINTF=yes \
                         XXsamba_cv_HAVE_FUNCTION_MACRO=yes \
                         samba_cv_HAVE_GETTIMEOFDAY_TZ=yes \
                         XXsamba_cv_HAVE_IFACE_AIX=no \
                         XXsamba_cv_HAVE_IFACE_IFCONF=yes \
                         XXsamba_cv_HAVE_IRIX_SPECIFIC_CAPABILITIES=no \
                         samba_cv_HAVE_MMAP=yes \
                         samba_cv_HAVE_OPEN_O_DIRECT=no \
                         samba_cv_HAVE_SECURE_MKSTEMP=yes \
                         samba_cv_HAVE_SOCK_SIN_LEN=no \
                         samba_cv_HAVE_VA_COPY=yes \
                         XXsamba_cv_HAVE_WORKING_AF_LOCAL=yes \
                         samba_cv_HAVE_WRFILE_KEYTAB=no \
                         samba_cv_REPLACE_GETPASS=no \
                         XXsamba_cv_REPLACE_INET_NTOA=no \
                         XXsamba_cv_c99_struct_initialization=yes \
                         XXsamba_cv_sig_atomic_t=yes \
                         XXsamba_cv_unixsocket=yes \
                         XXsamba_cv_volatile=yes \
                         XXsmb_attr_cv_xattr_add_opt=no \
                         SMB_BUILD_CC_NEGATIVE_ENUM_VALUES=yes \
"
EXTRA_OECONF += "--with-privatedir=/etc/samba"

CPP += "-ffreestanding"
CPPFLAGS += "-ffreestanding"
CFLAGS += "-D_GNU_SOURCE -DNDEBUG -DSHMEM_SIZE=524288"
LDFLAGS += "-lgcc_s"

do_compile() {
    # We can't just set S = to Samba/source because the patches don't apply
    # then.
    cd Samba/source

    # Pretend to cross-compile these ...
    oe_runmake clean bin/asn1_compile bin/compile_et

    # But then replace it with the pre-built native versions from the
    # wmi-native recipe lolol ...
    cp ${STAGING_DIR_NATIVE}${base_bindir}/asn1_compile ./bin
    cp ${STAGING_DIR_NATIVE}${base_bindir}/compile_et ./bin

    # Now build the real stuff ...
    oe_runmake proto bin/wmic bin/wmilogons
}

do_install() {
    cd Samba/source

    install -d -m0755 ${D}${bindir}
    install -m0755 bin/wmic ${D}${bindir}
    install -m0755 bin/wmilogons ${D}${bindir}
}
