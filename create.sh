#!/bin/sh

newdirs() {
	il=$1; shift
	echo $il
	test -d "$il" || exit 2
	for i in "$@"; do
		test -d $il/$i || mkdir -p $il/$i
	done
}

copy() {
	hl=$1
	il=$2

	test "$(ldd $hl)" = "not a dynamic executable" && cp -L $hl $(dirname $0)/$il
}

newdirs "$(dirname $0)" bin sbin dev proc sys newroot etc root lib

copy /bin/busybox.static bin/busybox
copy /sbin/cryptsetup sbin
copy /sbin/lvm.static sbin/lvm

ln -sf ../bin/busybox $(dirname $0)/sbin/mdev

find $(dirname $0) -print0 | cpio --null -ov --format=newc | gzip -9 > ${1:-rd.cpio.gz}
