FILESEXTRAPATHS_append := "${THISDIR}/squid:"

# override defaults to match openwrt
export libexecdir := "${libdir}/${BPN}"

DEPENDS_remove = "krb5 db cyrus-sasl expat libxml2 gnutls"

SRC_URI += " \
    file://0001-Check-cache-for-squid_filedescriptors_num-before-set.patch \
    file://010-add-rewrite-params-redirect.patch \
    file://011-add-unmapper-interception.patch \
    file://012-no-translations.patch \
    file://040-conn-opener-click-insert.patch \
    file://041-forward-click-remove.patch \
    file://042-squid-mapper-conf.patch \
    file://100-fix-header-include.patch \
    file://101-fix-assert.patch \
    file://102-atomic-squid.patch \
    file://103-ssl-click-insert.patch \
    file://104-ecap-adapter-port-info.patch \
"

# Override EXTRA_OECONF
EXTRA_OECONF = " \
    --with-krb5-config=no \
    --with-filedescriptors=16384 \
    --sysconfdir=${sysconfdir}/${BPN} \
    --with-logdir=${localstatedir}/log/${BPN} \
    --enable-auth-basic='none' \
    --enable-auth-ntlm='none' \
    --enable-auth-digest='none' \
    --enable-external-acl-helpers='none' \
"

PACKAGECONFIG = "pthreads xaccel-vary icmp kill-parent-hack arp-acl htcp \
    underscores cache-digests referer-log delay-pools useragent-log auth \
    openssl ssl ssl-crtd ecap"

PACKAGECONFIG[pthreads] = "--enable-pthreads,--disable-pthreads,,"
PACKAGECONFIG[xaccel-vary] = "--enable-x-accelerator-vary,--disable-x-accelerator-vary,,"
PACKAGECONFIG[icmp] = "--enable-icmp,--disable-icmp,,"
PACKAGECONFIG[kill-parent-hack] = "--enable-kill-parent-hack,--disable-kill-parent-hack,,"
PACKAGECONFIG[arp-acl] = "--enable-arp-acl,--disable-arp-acl,,"
PACKAGECONFIG[ssl] = "--enable-ssl,--disable-ssl,,"
PACKAGECONFIG[htcp] = "--enable-htcp,--disable-htcp,,"
PACKAGECONFIG[netfilter] = "--enable-linux-netfilter,--disable-linux-netfilter,,"
PACKAGECONFIG[underscores] = "--enable-underscores,--disable-underscores,,"
PACKAGECONFIG[cache-digests] = "--enable-cache-digests,--disable-cache-digests,,"
PACKAGECONFIG[referer-log] = "--enable-referer-log,--disable-referer-log,,"
PACKAGECONFIG[delay-pools] = "--enable-delay-pools,--disable-delay-pools,,"
PACKAGECONFIG[useragent-log] = "--enable-useragent-log,--disable-useragent-log,,"
PACKAGECONFIG[auth] = "--enable-auth,--disable-auth,,"
PACKAGECONFIG[auth-neg] = "--enable-auth-negotiate,--disable-auth-negotiate,,"
PACKAGECONFIG[krb5] = "--with-mit-krb5,--without-mit-krb5,krb5"
PACKAGECONFIG[openssl] = "--with-openssl,--without-openssl,openssl,"
PACKAGECONFIG[ssl] = "--enable-ssl,--disable-ssl,,"
PACKAGECONFIG[ssl-crtd] = "--enable-ssl-crtd,--disable-ssl-ctrd,,"
PACKAGECONFIG[ecap] = "--enable-ecap,--disable-ecap,libecap,libecap"

do_configure_prepend() {
    export AUTH_MODULES="basic digest ntlm"
}

do_install_append() {
    rm -fR ${D}${sysconfdir}/default
    # empty directory
    rm -fR ${D}${localstatedir}
    # we don't need squidclient or purge
    rm -fR ${D}${bindir}
    # don't need /usr/share either
    rm -fR ${D}${datadir}
    # we need to save a few binaries from /usr/libexec to /usr/lib/squid
    find ${D}${libexecdir} -type f \
                             ! -name unlinkd \
                             ! -name pinger \
                             ! -name log_file_daemon \
                             ! -name diskd \
                             ! -name ssl_crtd \
                           -exec rm -r '{}' \;
}

# don't install perl to rootfs, we don't need it
RDEPENDS_${PN}_remove = "perl"
