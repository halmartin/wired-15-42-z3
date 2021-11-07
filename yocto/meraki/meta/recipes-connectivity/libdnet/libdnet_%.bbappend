FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = " \
    https://dl.meraki.net/${BPN}-${PV}.tgz \
    file://01-shrext-vs-shrext_cmds.patch \
    file://10-aarch64.patch \
    file://libdnet-1.10-dnet_config.patch \
"

SRC_URI[md5sum] = "9253ef6de1b5e28e9c9a62b882e44cc9"
SRC_URI[sha256sum] = "83b33039787cf99990e977cef7f18a5d5e7aaffc4505548a83d31bd3515eb026"

# The original recipe sets S to "${WORKDIR}/git"
S = "${WORKDIR}/${BP}"

