DESCRIPTION = "Dynamic routing daeomon"
HOMEPAGE = "http://bird.network.cz/"
LICENSE = "GPLv2"
SECTION = "connectivity"
LIC_FILES_CHKSUM = "file://LICENSE-meraki;md5=1f0a42ec48e7a3fdf869e49b1e939adc"

PKG_SRC = "${ROUTER_ROOT}/extern/bird"
SRC_URI = "file://${PKG_SRC}"

S = "${WORKDIR}${PKG_SRC}"
B = "${WORKDIR}${PKG_SRC}"

inherit autotools-brokensep externalsrc pkgconfig

DEPENDS += "bison flex libsockproxy ncurses readline"

# Excluding aclocal prevents removing aclocal.m4 (which is custom for bird and
# can't be removed.  Excluding autoheader prevents the "autoheader failed with
# exit code 1" error.
EXTRA_AUTORECONF += "--exclude=aclocal --exclude=autoheader"
EXTRA_OECONF += "--with-protocols=bgp,ospf,static,pipe,meraki \
                 --with-libsockproxydir=${STAGING_DIR_TARGET} \
                 "

EXTRA_OECONF_append-meraki-ms = "--enable-click"

# For meraki_bird_defines.hh
CPPFLAGS += "-I${ROUTER_ROOT}/meraki/include"

do_install() {
  mkdir -p ${D}/usr/sbin/
  install -m0755 -D ${B}/bird ${D}/usr/sbin/bird
  install -m0755 -D ${B}/birdc ${D}/usr/sbin/birdc
}

PACKAGES += " ${PN}-client "

FILES_${PN} = "/usr/sbin/bird"
FILES_${PN}-client = "/usr/sbin/birdc"
