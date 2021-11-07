
CACHED_CONFIGUREVARS = " \
    libpcap_version_1x=yes \
"

# Override EXTRA_OECONF from main recipe
EXTRA_OECONF = " \
    --disable-dump-module \
    --disable-ipfw-module \
    --disable-ipq-module \
    --disable-nfq-module \
    --with-dnet-includes=${STAGING_INCDIR} \
    --with-dnet-libraries=${STAGING_LIBDIR} \
    --with-libpcap-libraries=${STAGING_LIBDIR} \
"
