DESCRIPTION = "strongSwan is an OpenSource IPsec implementation for the \
Linux operating system."
SUMMARY = "strongSwan is an OpenSource IPsec implementation"
HOMEPAGE = "http://www.strongswan.org"
SECTION = "net"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"
DEPENDS = "gmp openssl flex-native flex bison-native"

SRC_URI = "https://download.strongswan.org/strongswan-${PV}.tar.bz2"

EXTRA_OECONF = " \
        --with-gnu-ld \
        --with-ipsecdir=/usr/sbin \
        --without-lib-prefix \
        --disable-defaults \
        --enable-libtool-lock \
"

EXTRA_OECONF += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '--with-systemdsystemunitdir=${systemd_unitdir}/system/', '--without-systemdsystemunitdir', d)}"


DEFAULT_CONFIG ??= "charon ikev1 ikev2 scripts swanctl monolithic"
STRONGSWAN_CONFIG ??= "aes des ctr hmac md5 openssl nonce random sha1 sha2"
CHARON_CONFIG ??= "attr coupling netlink socketdefault systimefix vici"
PACKAGECONFIG ??= "${DEFAULT_CONFIG} \
                   ${STRONGSWAN_CONFIG} \
                   ${CHARON_CONFIG} \
                   "

PACKAGECONFIG[aes] = "--enable-aes,--disable-aes,,${PN}-plugin-aes"
PACKAGECONFIG[aesni] = "--enable-aesni,--disable-aesni,,${PN}-plugin-aesni"
PACKAGECONFIG[attr] = "--enable-attr,--disable-attr,,${PN}-plugin-attr"
PACKAGECONFIG[charon] = "--enable-charon,--disable-charon,"
PACKAGECONFIG[coupling] = "--enable-coupling,--disable-coupling,,${PN}-plugin-coupling"
PACKAGECONFIG[ctr] = "--enable-ctr,--disable-ctr,,${PN}-plugin-ctr"
PACKAGECONFIG[curl] = "--enable-curl,--disable-curl,curl,${PN}-plugin-curl"
PACKAGECONFIG[des] = "--enable-des,--disable-des,,${PN}-plugin-des"
PACKAGECONFIG[gmp] = "--enable-gmp,--disable-gmp,gmp,${PN}-plugin-gmp"
PACKAGECONFIG[hmac] = "--enable-hmac,--disable-hmac,,${PN}-plugin-hmac"
PACKAGECONFIG[ikev1] = "--enable-ikev1,--disable-ikev1,"
PACKAGECONFIG[ikev2] = "--enable-ikev2,--disable-ikev2,"
PACKAGECONFIG[netlink] = "--enable-kernel-netlink,--disable-kernel-netlink,,${PN}-plugin-kernel-netlink"
PACKAGECONFIG[ldap] = "--enable-ldap,--disable-ldap,openldap,${PN}-plugin-ldap"
PACKAGECONFIG[md5] = "--enable-md5,--disable-md5,,${PN}-plugin-md5"
PACKAGECONFIG[monolithic] = "--enable-monolithic,--disable-monolithic,"
PACKAGECONFIG[mysql] = "--enable-mysql,--disable-mysql,mysql5,${PN}-plugin-mysql"
PACKAGECONFIG[nonce] = "--enable-nonce,--disable-nonce,,${PN}-plugin-nonce"
PACKAGECONFIG[openssl] = "--enable-openssl,--disable-openssl,openssl,${PN}-plugin-openssl"
PACKAGECONFIG[random] = "--enable-random,--disable-random,,${PN}-plugin-random"
PACKAGECONFIG[scep] = "--enable-scepclient,--disable-scepclient,"
PACKAGECONFIG[scripts] = "--enable-scripts,--disable-scripts,"
PACKAGECONFIG[sha1] = "--enable-sha1,--disable-sha1,,${PN}-plugin-sha1"
PACKAGECONFIG[sha2] = "--enable-sha2,--disable-sha2,,${PN}-plugin-sha2"
PACKAGECONFIG[socketdefault] = "--enable-socket-default,--disable-socket-default,,${PN}-plugin-socket-default"
PACKAGECONFIG[soup] = "--enable-soup,--disable-soup,libsoup-2.4,${PN}-plugin-soup"
PACKAGECONFIG[sqlite3] = "--enable-sqlite,--disable-sqlite,sqlite3,${PN}-plugin-sqlite"
PACKAGECONFIG[stroke] = "--enable-stroke,--disable-stroke,,${PN}-plugin-stroke"
PACKAGECONFIG[systimefix] = "--enable-systime-fix,--disable-systime-fix,,${PN}-plugin-systime-fix"
PACKAGECONFIG[swanctl] = "--enable-swanctl,--disable-swanctl,,libgcc"
PACKAGECONFIG[vici] = "--enable-vici,--disable-vici,,${PN}-plugin-vici"

# requires swanctl
PACKAGECONFIG[systemd-charon] = "--enable-systemd,--disable-systemd,systemd,"

inherit autotools systemd pkgconfig

RRECOMMENDS_${PN} = "kernel-module-ipsec"

FILES_${PN} += "${libdir}/ipsec/lib*${SOLIBS} ${sbindir}/swanctl"
FILES_${PN}-dbg += "${bindir}/.debug ${sbindir}/.debug ${libdir}/ipsec/.debug ${libexecdir}/ipsec/.debug ${datadir}/"
FILES_${PN}-dev += "${libdir}/ipsec/lib*${SOLIBSDEV} ${libdir}/ipsec/*.la"
FILES_${PN}-staticdev += "${libdir}/ipsec/*.a"

CONFFILES_${PN} = "${sysconfdir}/*.conf ${sysconfdir}/ipsec.d/*.conf ${sysconfdir}/strongswan.d/*.conf ${sysconfdir}/strongswan.d/charon/*.conf"

PACKAGES += "${PN}-plugins"
ALLOW_EMPTY_${PN}-plugins = "1"

PACKAGES_DYNAMIC += "^${PN}-plugin-.*$"
NOAUTOPACKAGEDEBUG = "1"

python split_strongswan_plugins () {
    sysconfdir = d.expand('${sysconfdir}/strongswan.d/charon')
    libdir = d.expand('${libdir}/ipsec/plugins')
    dbglibdir = os.path.join(libdir, '.debug')

    def add_plugin_conf(f, pkg, file_regex, output_pattern, modulename):
        dvar = d.getVar('PKGD', True)
        oldfiles = d.getVar('CONFFILES_' + pkg, True)
        newfile = '/' + os.path.relpath(f, dvar)

        if not oldfiles:
            d.setVar('CONFFILES_' + pkg, newfile)
        else:
            d.setVar('CONFFILES_' + pkg, oldfiles + " " + newfile)

    split_packages = do_split_packages(d, libdir, 'libstrongswan-(.*)\.so', '${PN}-plugin-%s', 'strongSwan %s plugin', prepend=True)
    do_split_packages(d, sysconfdir, '(.*)\.conf', '${PN}-plugin-%s', 'strongSwan %s plugin', prepend=True, hook=add_plugin_conf)

    split_dbg_packages = do_split_packages(d, dbglibdir, 'libstrongswan-(.*)\.so', '${PN}-plugin-%s-dbg', 'strongSwan %s plugin - Debugging files', prepend=True, extra_depends='${PN}-dbg')
    split_dev_packages = do_split_packages(d, libdir, 'libstrongswan-(.*)\.la', '${PN}-plugin-%s-dev', 'strongSwan %s plugin - Development files', prepend=True, extra_depends='${PN}-dev')
    split_staticdev_packages = do_split_packages(d, libdir, 'libstrongswan-(.*)\.a', '${PN}-plugin-%s-staticdev', 'strongSwan %s plugin - Development files (Static Libraries)', prepend=True, extra_depends='${PN}-staticdev')

    if split_packages:
        pn = d.getVar('PN', True)
        d.setVar('RRECOMMENDS_' + pn + '-plugins', ' '.join(split_packages))
        d.appendVar('RRECOMMENDS_' + pn + '-dbg', ' ' + ' '.join(split_dbg_packages))
        d.appendVar('RRECOMMENDS_' + pn + '-dev', ' ' + ' '.join(split_dev_packages))
        d.appendVar('RRECOMMENDS_' + pn + '-staticdev', ' ' + ' '.join(split_staticdev_packages))
}

PACKAGESPLITFUNCS_prepend = "split_strongswan_plugins "

RPROVIDES_${PN} += "${PN}-systemd"
RREPLACES_${PN} += "${PN}-systemd"
RCONFLICTS_${PN} += "${PN}-systemd"
SYSTEMD_SERVICE_${PN} = "${@bb.utils.contains('PACKAGECONFIG', 'swanctl', '${BPN}-swanctl.service', '${BPN}.service', d)}"
