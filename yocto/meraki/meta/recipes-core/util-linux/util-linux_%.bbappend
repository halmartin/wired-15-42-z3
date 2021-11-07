PV_class-target = "2.26.1"

MAJOR_VERSION_class-target = "2.26"

SRC_URI_class-target = "https://dl.meraki.net/${BP}.tar.gz;name=target"

SRC_URI[target.md5sum] = "e47d177f4106fc05998ede680e2780c3"
SRC_URI[target.sha256sum] = "cf80b7e3d9011600d888cf19cfc0d124960e490ba87faa62705e62acbaac0b8c"

EXTRA_OECONF_append_class-target = " --without-ncurses \
                 --without-python \
                 --without-udev \
                 --disable-ul \
                 "

PACKAGECONFIG_class-target  ?= ""

PACKAGES_prepend_class-target = "util-linux-nsenter util-linux-unshare "

FILES_util-linux-nsenter = "${bindir}/nsenter"
FILES_util-linux-unshare = "${bindir}/unshare"

# Upstream adds --without-readline which configure doesn't recognize and I
# don't want to polute the logs so I am just emptying the associated
# PACKAGECONFIG.
PACKAGECONIG[readline] = ""
