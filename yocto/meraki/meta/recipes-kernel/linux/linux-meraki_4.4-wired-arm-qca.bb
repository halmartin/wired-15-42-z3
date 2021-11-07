BBPATH_prepend = "${THISDIR}/${PN}/${MACHINE}:"

inherit kernel
require recipes-kernel/linux/linux-yocto.inc

SRC_URI = "git://${ROUTER_ROOT}/kernel-sources/;protocol=file;bareclone=1;branch=${KBRANCH}"

KBRANCH = "w15-wired-arm-qca-meraki-linux-4.4"

KERNEL_VERSION_SANITY_SKIP="1"
LINUX_VERSION = "4.4.177"
LINUX_VERSION_EXTENSION = "-meraki"

SRCREV = "4220375b89153be1fa728b6cb62118d6c0fb166c"

require platform.inc
require module-signing.inc
