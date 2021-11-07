DESCRIPTION = "Amazon Elastic Network Adapter (ENA) driver"
LICENSE = "GPL-2.0"

SRC_PATH = "kernel/linux/ena"

LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

inherit module

SRC_URI = "git://github.com/amzn/amzn-drivers"
SRCREV = "6bd7761c85a8622bf5db4c5a19a18703e7b6d914"

S = "${WORKDIR}/git/${SRC_PATH}"

EXTRA_OEMAKE = "-C ${STAGING_KERNEL_BUILDDIR} \
                M=${B} modules \
                "

do_install() {
    install -d ${D}${base_libdir}/modules
    install -D -m0600 ${B}/ena.ko ${D}${base_libdir}/modules
}

COMPATIBLE_MACHINE = "x86-vm"