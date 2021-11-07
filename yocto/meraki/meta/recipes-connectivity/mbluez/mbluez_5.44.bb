DESCRIPTION = "bluez for embedded systems"
LICENSE = "GPLv2"
SECTION = "libs"
LIC_FILES_CHKSUM = "file://COPYING.LIB;md5=fb504b67c50331fc78734fed90fb0e09"

SRC_URI = "https://dl.meraki.net/${BPN}-${PV}.tar.bz2"
SRC_URI[md5sum] = "00121be75a7b448f9c662e9f029b1dfd"
SRC_URI[sha256sum] = "72ead6a0493d9e9f6e70a8682fccf237c5b61c3acdfbf2de5d06bcb52a0b28eb"

EXTRA_OECONF = " \
    --enable-shared \
    --enable-static \
    --disable-manpages \
    --enable-deprecated \
    --enable-library \
    --enable-tools \
    --disable-nfc \
    --disable-sap \
    --disable-health \
    --disable-android \
    --disable-sixaxis \
    --disable-midi \
    --disable-a2dp \
    --disable-avrcp \
    --disable-network \
    --disable-hid \
    --disable-hog \
    --disable-udev \
    --disable-obex \
    --disable-cups \
    --disable-datafiles \
    --disable-client \
    "

PACKAGES =+ "${BPN}-rfcomm ${BPN}-hcidump ${BPN}-ciptool"
FILES_${BPN}-rfcomm  = "/usr/bin/rfcomm"
FILES_${BPN}-hcidump = "/usr/bin/hcidump"
FILES_${BPN}-ciptool = "/usr/bin/ciptool"

inherit autotools pkgconfig
