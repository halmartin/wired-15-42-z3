PV="1.4.39"
LIC_FILES_CHKSUM = "file://COPYING;md5=e4dac5c6ab169aa212feb5028853a579"

FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"
SRC_URI = "https://dl.meraki.net/${BPN}-${PV}.tar.gz \
           file://001-add-include-globbing.patch \
           file://002-Use-pkg-config-for-pcre-dependency-instead-of-config.patch \
           file://900-meraki-remove-date-header.patch \
           file://950-meraki-increase-listen-backlog.patch \
           file://lighttpd.conf \
           file://management.conf \
           \
           file://index.html.lighttpd \
           file://lighttpd \
           file://lighttpd.service \
"
SRC_URI[md5sum] = "b49e133a4b321921331eba5a343872ab"
SRC_URI[sha256sum] = "bc5f910f78b8cbae3e8fe1a1d8558259f09dbe50dd3907db771404bfab27bb2e"

# Enable these modules by default.
RDEPENDS_${PN} += "lighttpd-module-auth \
                   lighttpd-module-cgi \
                   lighttpd-module-fastcgi \
                   lighttpd-module-redirect \
                   lighttpd-module-rewrite \
                   lighttpd-module-setenv \
                   lighttpd-module-simple-vhost \
"

# These configure options don't exist for our version of lighttpd so silence
# the warning by unsetting their values.
PACKAGECONFIG[krb5] = ""
PACKAGECONFIG[memcache] = ""

do_install_append() {
    install -m 0644 ${WORKDIR}/lighttpd.conf ${D}${sysconfdir}/lighttpd

    # Remove the files that were installed by the main package that we don't need
    rm -f ${D}${sysconfdir}/init.d/lighttpd
    rm -f ${D}/www/pages/index.html
    rm -f ${D}${systemd_unitdir}/system/lighttpd.service

    # Remove directories we install from base-files.
    rm -rf ${D}${sysconfdir}/lighttpd

    # Remove symlinks in /www/ pointing to sensitive files.
    # These symlinks are created in the upstream recipe.
    rm ${D}/www/var
    rm ${D}/www/logs
}

PACKAGECONFIG = "pcre ipv6"
