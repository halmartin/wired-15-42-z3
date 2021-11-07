DESCRIPTION = "Host tools to build wmi-client"
LICENSE = "GPLv2"
SECTION = "network"

LIC_FILES_CHKSUM = "file://Samba/COPYING;md5=8ca43cbc842c2336e835926c2166c28b"

inherit native

require wmi.inc

export LDFLAGS = ""
export CFLAGS = ""
export CXXFLAGS = ""

do_compile() {
    # We can't just set S = to Samba/source because the patches don't apply
    # then.
    cd Samba/source

    oe_runmake clean bin/asn1_compile bin/compile_et
}

do_install() {
    cd Samba/source

    install -d -m0755 ${D}${base_bindir}
    install -m0755 bin/asn1_compile bin/compile_et ${D}${base_bindir}
}
