DEPENDS += "cyrus-sasl"

SRC_URI = "https://dl.meraki.net/${BPN}-${PV}.tar.bz2"
SRC_URI[md5sum] = "ba0ebcc3d5b25cb3690672f845ce3003"
SRC_URI[sha256sum] = "1001e0786485ba70ec5ae94b205b182f9cda50cb305d31d12c0ca2edd4c39aff"

FILESEXTRAPATHS_prepend = "${THISDIR}/${BPN}:"

SRC_URI += " \
    file://01-openvas-wmi-1.3.14.patch \
    file://02-install-headers.patch \
    file://03-iconv.patch \
    file://04-visibility_cflags.patch \
    file://05-export-dynamic.patch \
    file://06-missing-ldflags.patch \
    file://07-kerberos.patch \
    file://08-bad-link-options.patch \
    file://09-wmilogons.patch \
    file://10-charcnv.patch \
    file://11-disable-gnutls.patch \
    file://12-mebwatad-evil-cast.patch \
    file://13-fix-wbem-abuse-of-talloc.patch \
    file://14-fix-librpc-config-mk.patch \
    file://15-fix-non-english.patch \
    file://16-fix-pidl.patch \
    file://17-musl.patch \
    file://18-aarch64.patch \
    "

inherit autotools-brokensep

EXTRA_OECONF += "--with-lockdir=/var/run/samba \
                 --without-readline \
                 --with-included-popt \
                 --program-prefix='' \
                 --program-suffix='' \
"
AUTOTOOLS_SCRIPT_PATH = "${S}/Samba/source"

do_configure() {
    cd ${AUTOTOOLS_SCRIPT_PATH}

    # No idea why this is needed. Just copying it as is from OpenWRT.
    [ -e ${S}/Samba/source/librpc/config.mk ] || ln -sf config.mk.nobreakpad ${B}/Samba/source/librpc/config.mk || true

    # Generate autoconf
    ./autogen.sh

    # Run configure
    oe_runconf
}

