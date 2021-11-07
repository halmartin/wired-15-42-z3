FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-Handle-NULL-returns-from-glibc-2.17-crypt.patch \
    file://010-fix-ltconfig-for-shared-libs-on-powerpc.patch \
    "

EXTRA_OECONF = " \
    --enable-shared \
    --enable-static \
    --disable-sample \
    --enable-staticdlopen \
    --disable-java \
    --disable-alwaystrue \
    --disable-checkapop \
    --enable-cram \
    --enable-digest \
    --disable-otp \
    --disable-srp \
    --disable-srp-setpass \
    --disable-krb4 \
    --disable-gssapi \
    --disable-gss_mutexes \
    --enable-plain \
    --enable-anon \
    --disable-login \
    --disable-ntlm \
    --disable-sql \
    --with-dblib=none \
    --without-gdbm \
    --with-devrandom=/dev/urandom \
    --without-pam \
    --without-saslauthd \
    --without-authdaemond \
    --without-pwcheck \
    --with-ipctype=unix \
    --with-openssl \
    --without-des \
    --without-opie \
    --without-ldap \
    --without-mysql \
    --without-pgsql \
    --without-sqlite \
    --without-rc4 \
    --without-dmalloc \
    --without-sfio \
    "

DEPENDS_remove = "virtual/db"
PACKAGECONFIG_remove = "ntlm"
