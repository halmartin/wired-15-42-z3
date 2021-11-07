DESCRIPTION = "Socket proxy between applications and click"
LICENSE = "CLOSED"
SECTION = "connectivity"

SRC_PATH = "${ROUTER_ROOT}/extern/libsockproxy"
SRC_URI = "file://${SRC_PATH}"

S = "${WORKDIR}${SRC_PATH}"
B = "${WORKDIR}${SRC_PATH}"

# Explicitly pass this in, otherwise it ends up using
# the host/native toolchain.
EXTRA_OEMAKE = "CC='${CC}' CXX='${CXX}' AR='${AR}'"

do_install() {
    mkdir -p ${D}/usr/lib
    mkdir -p ${D}/usr/include
    cp ${B}/lib/libsockproxy.a ${D}/usr/lib
    cp ${B}/include/*.h ${D}/usr/include
}
