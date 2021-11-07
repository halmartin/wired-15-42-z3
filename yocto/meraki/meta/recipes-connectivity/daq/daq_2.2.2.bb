SUMMARY = "The dump DAQ test the various inline mode features "
HOMEPAGE = "http://www.snort.org"
SECTION = "libs"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=f9ce51a65dd738dc1ae631d8b21c40e0"

PARALLEL_MAKE = ""

DEPENDS = "libpcap libpcre libdnet"

SRC_URI = "https://dl.meraki.net/${PN}-${PV}.tar.gz \
           file://0001-correct-the-location-of-unistd.h.patch \
           file://disable-run-test-program-while-cross-compiling.patch \
           file://daq_afpacket.c.patch \
"

EXTRA_OECONF = "--with-libpcap-includes=${STAGING_INCDIR} --with-dnet-includes=${STAGING_LIBDIR}"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'ipv6', d)}"
PACKAGECONFIG[ipv6] = "--enable-ipv6,--disable-ipv6,"
PACKAGECONFIG[nfq-module] = "--enable-nfq-module,--disable-nfq-module,"
PACKAGECONFIG[ipq-module] = "--enable-ipq-module,--disable-ipq-module,"

SRC_URI[md5sum] = "c61f60674a5f951f0c50faf33a611fee"
SRC_URI[sha256sum] = "7cd818cabb1ad35360e83076e54775f07165ee71407dc672d147e27d3cd37f7b"

inherit autotools
