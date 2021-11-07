PV = "8.39"

LIC_FILES_CHKSUM = "file://LICENCE;md5=b8221cbf43c5587f90ccf228f1185cc2"

SRC_URI[md5sum] = "e3fca7650a0556a2647821679d81f585"
SRC_URI[sha256sum] = "b858099f82483031ee02092711689e7245586ada49e534a06e678b8ea9549e8b"

EXTRA_OECONF = ""

PACKAGECONFIG[jit] = "--enable-jit,--disable-jit"
PACKAGECONFIG[rebuild-chartables] = "--enable-rebuild-chartables,--disable-rebuild-chartables"
PACKAGECONFIG[utf] = "--enable-utf,--disable-utf"

PACKAGECONFIG ?= "jit pcre8 pcre16 pcre32 unicode-properties utf"
