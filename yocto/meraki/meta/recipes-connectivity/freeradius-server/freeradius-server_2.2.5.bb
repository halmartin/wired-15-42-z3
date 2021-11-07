DESCRIPTION = "A Flexible RADIUS server implementation"
LICENSE = "GPLv2"
SECTION = "network"

LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=901657fc927ef01b3df68e4d4f8a10bc"

DEPENDS = "openssl openldap libtool libtool-cross"

SRC_URI = "https://dl.meraki.net/${BPN}-${PV}.tar.gz"
SRC_URI[md5sum] = "da77eb23b4c5e2f9fc55119025a91b61"
SRC_URI[sha256sum] = "8c4c2a0b600a8d85d2235589a5e80d4fefd1f52317e9daf8193731566fa9d012"

SRC_URI += " \
    file://002-configure.patch \
    file://003-configure.patch \
    file://004-nobacktrace.patch \
    file://006-excludedictionaries.patch \
    file://010-dstorecaching.patch \
    file://012-rlm_ldap_configure_fix.patch \
    file://014-rlm_ldap_fix_misquote.patch \
    file://100-libtool-install.patch \
    file://radiusd.init \
    "

# find . -type d -name 'rlm_*' | sed 's|.*/||' | sort | sed s/rlm_//
FREERADIUS_ALL_MODULES := " \
    acctlog acct_unique always attr_filter attr_rewrite cache caching chap \
    checkval copy_packet counter cram dbm detail digest dynamic_clients eap \
    eap2 eap_gtc eap_ikev2 eap_leap eap_md5 eap_mschapv2 eap_peap eap_sim \
    eap_tls eap_tnc eap_ttls example exec expiration expr fastusers files \
    ippool jradius krb5 ldap linelog logintime mschap opendirectory otp pam \
    pap passwd perl policy preprocess protocol_filter python radutmp realm \
    redis rediswho replicate ruby securid sim_files smb smsotp soh sql \
    sqlcounter sql_db2 sql_firebird sql_freetds sqlhpwippool sql_iodbc \
    sqlippool sql_log sql_mysql sql_oracle sql_postgresql sql_sqlite \
    sql_sybase sql_unixodbc unix wimax \
    "

FREERADIUS_DISABLED_MODULES ?= " \
    attr_rewrite checkval counter dbm eap_sim example ippool krb5 otp smsotp \
    pam perl python radutmp smb sqlhpwippool sqlippool sql_db2 sql_firebird \
    sql_freetds sql_iodbc sql_mysql sql_oracle sql_postgresql sql_sybase \
    sql_unixodbc sql_log sql_sqlite unix eap_tnc eap_ikev2 opendirectory \
    wimax ruby x99-token caching redis rediswho \
    "

FREERADIUS_INSTALLED_DICTIONARIES ?= " \
    dictionary \
    dictionary.freeradius \
    dictionary.freeradius.internal \
    dictionary.compat \
    dictionary.rfc2865 \
    dictionary.rfc2866 \
    dictionary.rfc2867 \
    dictionary.rfc2868 \
    dictionary.rfc2869 \
    dictionary.rfc3162 \
    dictionary.rfc3576 \
    dictionary.rfc3580 \
    dictionary.rfc4372 \
    dictionary.rfc4675 \
    dictionary.rfc4679 \
    dictionary.microsoft \
    dictionary.wispr \
    dictionary.cisco \
    "

inherit autotools-brokensep

EXTRA_OECONF = " \
    --enable-shared \
    --disable-static \
    --enable-strict-dependencies \
    --with-system-libtool \
    --with-system-libltdl \
    --without-threads \
    --with-raddbdir=/etc/freeradius \
    --without-edir \
    --without-snmp \
    --with-experimental-modules \
    ${@" ".join(("--without-rlm_" + mod) for mod in "${FREERADIUS_DISABLED_MODULES}".split())} \
    "

EXTRA_OEMAKE = "LIBTOOL=${HOST_SYS}-libtool"

EXTRACONFFUNCS += "add_module_paths_for_autoconf"
add_module_paths_for_autoconf[dirs] = "${S}"
python add_module_paths_for_autoconf() {
    # Only include enabled modules to save time
    from glob import glob
    all_modules = set(d['FREERADIUS_ALL_MODULES'].split())
    disabled_modules = set(d['FREERADIUS_DISABLED_MODULES'].split())
    configure_scripts = []
    for module in sorted(all_modules - disabled_modules):
        configure_scripts += glob("src/modules/rlm_{}/configure.in".format(module))
        configure_scripts += glob("src/modules/rlm_{}/*/rlm_*/configure.in".format(module))
    configure_scripts.sort()
    d.appendVar('ACLOCALEXTRAPATH',
                ' . ' + ' '.join(os.path.dirname(x) for x in configure_scripts))
}

do_install() {
    oe_runmake R=${D} install

    # Remove disabled packages
    for mod in ${FREERADIUS_DISABLED_MODULES}; do
        rm -f ${D}/${libdir}/rlm_${mod}.so ${D}/${libdir}/rlm_${mod}-*.so
    done

    # Remove everything except:
    #   etc/freeradius/(dictionary|ldap.attrmap|certs/)
    #   usr/bin/(radclient|radeapclient)
    #   usr/sbin/radiusd
    rm -rf ${D}/${localstatedir}
    rm -f ${D}/${sysconfdir}/freeradius/certs/*
    find ${D}/${sysconfdir}/freeradius -mindepth 1 -maxdepth 1 -type f -not -name dictionary -not -name ldap.attrmap -delete
    find ${D}/${sysconfdir}/freeradius -mindepth 1 -maxdepth 1 -type d -not -name certs -exec rm -rf {} +;
    find ${D}/${bindir} -mindepth 1 -maxdepth 1 -not -name radclient -not -name radeapclient -delete
    find ${D}/${sbindir} -mindepth 1 -maxdepth 1 -not -name radiusd -delete
    rm -rf ${D}/${datadir}/{man,doc}

    # Install init script
    install -D -m0755 ${WORKDIR}/radiusd.init ${D}/${sysconfdir}/init.d/radiusd

    # Leave only enabled dictionaries
    (
        cd ${D}/${datadir}/freeradius
        mkdir keep
        mv ${FREERADIUS_INSTALLED_DICTIONARIES} keep
        rm -f dictionary.*
        mv keep/* .
        rmdir keep
    )
}

python() {
    all_modules = set(d['FREERADIUS_ALL_MODULES'].split())
    disabled_modules = set(d['FREERADIUS_DISABLED_MODULES'].split())

    packages = []
    for module in sorted(all_modules - disabled_modules):
        pkg_name = 'freeradius-module-' + module.replace('_', '-')
        packages.append(pkg_name)
        d['FILES_' + pkg_name] = '${libdir}/rlm_MOD.so ${libdir}/rlm_MOD-*.so'.replace('MOD', module)
        d['RDEPENDS_' + pkg_name] = '${PN}'

    d.prependVar('PACKAGES', ' '.join(packages) + ' ')
}

# Install core libraries in main package
ERROR_QA_remove = "dev-so"
SOLIBS = ".so"
SOLIBSDEV = ".so.dummy"

# Install dictionary files in main package
FILES_${PN} += '${datadir}/freeradius/*'
