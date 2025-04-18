#!/bin/csh
cd /tmp
cat /poudriere/packages | sort -u > poudrierepackages
pkg prime-origins | sort -u > prime-origins
diff -Naur poudrierepackages prime-origins | grep -vE 'net/mtr|devel/git|editors/vim|graphics/gpu-firmware-amd-kmod|sysutils/vimpager|emulators/libc6-shim' | vimpager
