FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://917-preserve-select-behavior.patch \
            file://925-implement-setscheduler.patch \
            file://926-ignore_stubborn_intractable_maintainer.patch \
            file://950-meraki_stdio_procfs_fix.patch \
           "
