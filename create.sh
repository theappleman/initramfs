#!/bin/sh

set -e
ROOT="$(dirname $0)"

newdirs() {
	il=$1; shift
	test -d "$il" || exit 2
	for i in "$@"; do
		test -d $il/$i || mkdir -p $il/$i
	done
}

copy() {
	hl=$1
	il=$2

	test "$(ldd $hl)" = "	not a dynamic executable" && cp -L $hl $(dirname $0)/$il
}

newdirs $ROOT bin sbin dev proc sys newroot etc root lib

test -f /bin/busybox.static && bb=/bin/busybox.static
test x"$bb" = "x" && test -f /bin/bb && bb=/bin/bb
test x"$bb" != "x"

copy $bb $ROOT/bin/busybox
copy /sbin/cryptsetup $ROOT/sbin
copy /sbin/lvm.static $ROOT/sbin/lvm && chmod +w $ROOT/sbin/lvm

ln -sf ../bin/busybox $ROOT/sbin/mdev

find $ROOT -name .git -prune -o \( -print0 \) | cpio --null -ov --format=newc | gzip -9 > ${1:-/tmp/rd.cpio.gz}

