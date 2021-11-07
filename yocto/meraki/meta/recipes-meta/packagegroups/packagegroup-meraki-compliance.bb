LICENSE = "GPLv2"
require recipes-core/packagegroups/packagegroup-core-boot.bb
RDEPENDS_${PN} = " \
  openl2tp \
  pam-ldap \
  pam-script \
  wireless-tools \
  bird \
  base-files \
  dnsmasq \
  ethtool \
  haveged \
  hping3 \
  memtester \
  mtd-openwrt \
  mtd-utils \
  nuttcp \
  pciutils \
  bird \
  i2c-tools \
  iproute2 \
  mtr \
  ppp \
  rsyslog \
  strongswan \
  ubus \
  usbutils \
  usb-modeswitch \
  wmi \
  i2c-tools \
  iproute2 \
  mtr \
  usbutils \
  iproute2 \
  "
