PV := "1.29.0"
SRC_URI[tarball.md5sum] = "3c4a8f5d544907277e9df7130bac9f14"
SRC_URI[tarball.sha256sum] = "c8115612f0be640644e7c35098766ddaac4a88b773c4c4f0e43564982f660c82"


# busybox has different config depending on platform
PACKAGE_ARCH = "${MACHINE_ARCH}"

# Split our source files for clarity
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:${THISDIR}/openwrt:${THISDIR}/configs/${MACHINE}:"

# Remove patches already applied in 1.29.0
SRC_URI_remove := " \
    file://busybox-1.24.1-unzip.patch \
    file://busybox-1.24.1-unzip-regression.patch \
    file://busybox-1.24.1-truncate-open-mode.patch \
    file://0001-flock-update-the-behaviour-of-c-parameter-to-match-u.patch \
    file://CVE-2016-2148.patch \
    file://CVE-2016-2147.patch \
    file://CVE-2016-2147_2.patch \
    file://ip_fix_problem_on_mips64_n64_big_endian_musl_systems.patch \
    file://0001-iproute-support-scope-.-Closes-8561.patch \
    file://0001-ip-fix-an-improper-optimization-req.r.rtm_scope-may-.patch \
    file://ifupdown-pass-interface-device-name-for-ipv6-route-c.patch \
    file://001-resource_h_include.patch \
    file://120-remove_uclibc_rpc_check.patch \
    file://130-mconf_missing_sigwinch.patch \
    file://400-setfiles.patch \
    file://makefile-fix-backport.patch \
    file://0001-sed-fix-sed-n-flushes-pattern-space-terminates-early.patch \
    file://busybox-kbuild-race-fix-commit-d8e61bb.patch \
    file://commit-applet_tables-fix-commit-0dddbc1.patch \
    file://0001-libiproute-handle-table-ids-larger-than-255.patch \
    file://BUG9071_buffer_overflow_arp.patch \
    file://busybox-tar-add-IF_FEATURE_-checks.patch \
    file://0001-iproute-support-scope-.-Closes-8561.patch \
    file://0001-ip-fix-an-improper-optimization-req.r.rtm_scope-may-.patch \
"

# Avoid some defaults set by Yocto
SRC_URI_remove := " \
    file://login-utilities.cfg \
    file://mount-via-label.cfg \
    "

# Apply our OpenWRT patches
SRC_URI += " \
    file://0175-udhcp-request-mtu.patch \
    file://0910-grep-unbuffered.patch \
    file://0921-reboot_log_reason.patch \
    file://0923-arping_rate.patch \
    file://0993-ping-flush-stdout.patch \
    file://0994-ping-print-timeouts.patch \
    file://0995-syslogd.patch \
    file://0996-dmalloc.patch \
    file://1000-add-busybox_suffix.patch \
    file://100-trylink_bash.patch \
    file://101-gen_build_files_bash.patch \
    file://102-trylink_mktemp_fix.patch \
    file://1100-add-tftp-B-option.patch \
    file://110-no_static_libgcc.patch \
    file://1200-add-patch-outfile-option.patch \
    file://200-udhcpc_reduce_msgs.patch \
    file://201-udhcpc_changed_ifindex.patch \
    file://203-udhcpc_renew_no_deconfig.patch \
    file://210-add_netmsg_util.patch \
    file://220-add_lock_util.patch \
    file://230-ntpd_delayed_resolve.patch \
    file://240-telnetd_intr.patch \
    file://250-date-k-flag.patch \
    file://260-arping_missing_includes.patch \
    file://270-libbb_make_unicode_printable.patch \
    file://301-ip-link-fix-netlink-msg-size.patch \
    file://400-compress-rotated-logfile.patch \
    "

do_package[vardeps] += "convert_upd_alt_to_symlinks"
python do_package_prepend () {
    split_funcs = d.getVar('PACKAGESPLITFUNCS').split()
    split_funcs.insert(split_funcs.index('populate_packages_updatealternatives') + 1,
                       'convert_upd_alt_to_symlinks')
    d.setVar('PACKAGESPLITFUNCS', ' '.join(split_funcs))
}

python convert_upd_alt_to_symlinks () {
    # update-alternatives is freaking slow so just use symlinks
    import re

    postinst_regex = re.compile(r'update-alternatives --install ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)\n')
    lines = d.getVar('pkg_postinst_busybox').splitlines(True)
    for i, line in enumerate(lines):
        match = postinst_regex.match(line)
        if not match:
            continue
        lines[i] = 'ln -sv {} $D{}\n'.format(match.group(3), match.group(1))
    d.setVar('pkg_postinst_busybox', ''.join(lines))

    # Removal? LOL
    d.delVar('pkg_prerm_busybox')
}

python() {
    machine = d.getVar("MACHINE")
    paths = d.getVar("FILESEXTRAPATHS")

    import os
    for path in paths.split(":"):
        # Make sure there's a MACHINE-specific defconfig present.
        if os.path.exists(os.path.join(path, "defconfig")) and machine in path:
            return

    raise Exception("Missing defconfig for " + machine)
}
