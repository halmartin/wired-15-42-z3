# We need the static versions of the libbind libraries for dhcp to build
# correctly. Without the static libraries, dhcp fails to build with an
# error like:
# make[1]: *** No rule to make target '/home/mtahmed/co/router/yocto/build-rocko-2/tmp/work/aarch64-poky-linux-musl/dhcp/4.3.3-P1-r0/recipe-sysroot/usr/lib/libirs.a', needed by 'svtest'.  Stop.
EXTRA_OECONF += "--enable-static"
DISABLE_STATIC = ""

PACKAGE_BEFORE_PN += "${PN}-libdns \
                      ${PN}-libisc \
                      ${PN}-libisccfg \
                      ${PN}-libirs \
                      "

# Split these libraries out into their own packages so that they can be
# installed independently of the rest of stuff that bind provides when dhcpd
# RDEPENDS on it through automatic library dependency resolution.
FILES_${PN}-libdns = "${libdir}/libdns.so*"
FILES_${PN}-libisc = "${libdir}/libisc.so*"
FILES_${PN}-libisccfg = "${libdir}/libisccfg.so*"
FILES_${PN}-libirs = "${libdir}/libirs.so*"
