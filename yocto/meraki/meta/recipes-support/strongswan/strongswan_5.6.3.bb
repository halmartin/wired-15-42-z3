require strongswan.inc

SRC_URI += "file://0002-parse-inactivity-timeout-as-uint32.patch \
            file://0003-Enable-optional-fwd_interface-for-fwd-policies.patch \
            file://0004-Enable-line-buffering-for-stdout.patch \
"

SRC_URI[md5sum] = "a6a28eeb22aa58080a7581771a5b63f9"
SRC_URI[sha256sum] = "c3c7dc8201f40625bba92ffd32eb602a8909210d8b3fac4d214c737ce079bf24"
