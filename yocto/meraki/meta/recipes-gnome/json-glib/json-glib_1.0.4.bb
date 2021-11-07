SUMMARY = "JSON-GLib implements a full JSON parser using GLib and GObject"
DESCRIPTION = "Use JSON-GLib it is possible to parse and generate valid JSON\
 data structures, using a DOM-like API. JSON-GLib also offers GObject \
integration, providing the ability to serialize and deserialize GObject \
instances to and from JSON data types."
HOMEPAGE = "http://live.gnome.org/JsonGlib"

LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=7fbc338309ac38fefcd64b04bb903e34"

SRC_URI = "https://dl.meraki.net/${BP}.tar.xz"
SRC_URI[md5sum] = "3131b0417ecde3da1ae72acceaa375cf"
SRC_URI[sha256sum] = "80f3593cb6bd13f1465828e46a9f740e2e9bd3cd2257889442b3e62bd6de05cd"

DEPENDS = "glib-2.0"

inherit autotools-brokensep gettext gobject-introspection

EXTRA_OECONF_remove = "--enable-introspection"

EXTRA_OECONF = "--disable-introspection \
                --disable-nls \
                "

do_configure() {
    oe_runconf
}
