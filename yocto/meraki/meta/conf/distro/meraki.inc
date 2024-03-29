# Distribution definition for: meraki
#
# Copyright (c) 2011, Intel Corporation.
# All rights reserved.
#
# This file is released under the MIT license as described in
# poky/meta/COPYING.MIT.
#

# Fetch all files from dl.meraki.net if possible
SOURCE_MIRROR_URL = "https://dl.meraki.net/"
INHERIT += "own-mirrors"

UNINATIVE_URL = "${SOURCE_MIRROR_URL}uninative/1.9/"

# Do not include kernel image inside rootfs (see kernel.bbclass).
RDEPENDS_kernel-base = ""

# Avoid installing "recommended" packages
NO_RECOMMENDATIONS = "1"

# Where we're going... we don't need no dev_manager!
VIRTUAL-RUNTIME_dev_manager = ""

# Where we're going... we don't need no init_manager!
VIRTUAL-RUNTIME_init_manager = ""

# Disable poky-provided U-Boot signing.
UBOOT_SIGN_ENABLE = ""

# Disable graphics
XSERVER = ""

# Don't create symlinks for externalsrc. They pollute the source directories.
EXTERNALSRC_SYMLINKS = ""

# Enable the ${MERAKI_PRODTYPE} override.
# Adding MERAKI_PRODTYPE to vardepsexclude tells Yocto that packages need not
# be rebuilt if MERAKI_PRODTYPE changes.
MERAKI_PRODTYPE ??= "unknown"
MACHINEOVERRIDES =. "${MERAKI_PRODTYPE}:"
MACHINEOVERRIDES[vardepsexclude] += "MERAKI_PRODTYPE"

# remove the ROOTFS_RO_UNNEEDED packages like base-passwd and update-alternatives
FORCE_RO_REMOVE = "1"
