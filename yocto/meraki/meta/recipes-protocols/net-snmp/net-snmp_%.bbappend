SNMP_MIB_MODULES_INCLUDED = " \
    mibII/snmp_mib \
    mibII/sysORTable \
    mibII/system_mib \
    mibII/vacm_context \
    mibII/vacm_vars \
    snmpv3/usmUser \
    snmpv3/usmConf \
    ucd-snmp/dlmod \
    util_funcs \
    utilities/execute \
    "

SNMP_MIB_MODULES_EXCLUDED = " \
    agent_mibs \
    agentx \
    host \
    host/hr_device \
    host/hr_disk \
    host/hr_filesys \
    host/hr_network \
    host/hr_partition \
    host/hr_proc \
    host/hr_storage \
    host/hr_system \
    ieee802dot11 \
    mibII \
    mibII/at \
    mibII/icmp \
    mibII/interfaces \
    mibII/ip \
    mibII/tcp \
    mibII/udp \
    notification \
    notification-log-mib \
    snmpv3/snmpEngine \
    snmpv3/snmpMPDStats \
    snmpv3/usmStats \
    snmpv3mibs \
    target \
    tunnel \
    ucd-snmp/disk \
    ucd-snmp/extensible \
    ucd-snmp/loadave \
    ucd-snmp/memory \
    ucd-snmp/pass \
    ucd-snmp/pass_persist \
    ucd-snmp/proc \
    ucd-snmp/vmstat \
    ucd_snmp \
    utilities \
    "

SNMP_TRANSPORTS_INCLUDED = "Callback UDP"

SNMP_TRANSPORTS_EXCLUDED = "TCP TCPv6 UDPv6 Unix"

EXTRA_OECONF = " \
    --enable-mfd-rewrites \
    --enable-shared \
    --enable-static \
    --with-endianness=little \
    --with-logfile=/var/log/snmpd.log \
    --with-persistent-directory=/usr/lib/snmp/ \
    --with-default-snmp-version=1 \
    --with-sys-contact=root@localhost \
    --with-sys-location=Unknown \
    --enable-applications \
    --disable-debugging \
    --disable-manuals \
    --disable-mib-loading \
    --disable-mibs \
    --disable-scripts \
    --with-out-mib-modules='${SNMP_MIB_MODULES_EXCLUDED}' \
    --with-mib-modules='${SNMP_MIB_MODULES_INCLUDED}' \
    --with-out-transports='${SNMP_TRANSPORTS_EXCLUDED}' \
    --with-transports='${SNMP_TRANSPORTS_INCLUDED}' \
    --with-openssl \
    --without-libwrap \
    --without-rpm \
    --without-zlib \
    --disable-embedded-perl \
    --without-perl-modules \
    "

DEPENDS_remove = "libnl"

# Since we have removed mibs, we have to remove those deps too
RDEPENDS_${PN}-server-snmpd_remove= "net-snmp-mibs"
RDEPENDS_${PN}-client_remove = "net-snmp-mibs"
