DESCRIPTION = "A program to send magic Wake-on-LAN packets"
HOMEPAGE = "http://ahh.sourceforge.net/wol/"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"
DEPENDS = ""

SRC_URI = "https://dl.meraki.net/${PN}-${PV}.tar.gz \
    file://configure-ac-ether-addr.patch \
    file://fix-getline-getdelim.patch"
SRC_URI[md5sum] = "c2fa9d7e771134ac8c89d56b8197d4ca"

CACHED_CONFIGUREVARS = "am_cv_func_getline=yes \
  am_cv_func_working_getline=yes \
  ac_cv_func_malloc_0_nonnull=yes \
  ac_cv_func_realloc_0_nonnull=yes \
  ac_cv_func_mmap_fixed_mapped=yes \
  jm_cv_func_working_malloc=yes \
  ac_cv_func_alloca_works=yes"

inherit autotools gettext
