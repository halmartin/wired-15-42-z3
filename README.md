# Summary

Meraki provide the source code for the Z3 firmware upon request.

The default make target will build a Ubuntu 18.04 build environment and then build the yocto based firmware used on the Z3.

# Building

Run `make` and let Docker take care of the rest.

Yocto takes ages to build, and some archives are hosted on really slow mirrors.
