# move binaries from /usr/sbin to /usr/bin
do_install_append() {
    mv -T ${D}/${sbindir} ${D}/${bindir}
}
