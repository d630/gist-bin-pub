#!/bin/sh

# [modified] [GNU/Linux Debian Testing (Jessie)]
# create a disk image for a usb stick which combines all *.iso files
# found in the current directory into a multiboot image

set -e
set -x

mkdir -p isomount
mkdir -p extmount
mkdir -p mainmount

cleanup() {
	sudo umount isomount
	sudo umount extmount
	sudo umount mainmount
}

trap cleanup 1 2 15

PATH=$PATH:/sbin:/usr/sbin
TMP=.

bs=512

# the size of the first partition
mainsize=1024

echo " ++ creating main partition"

main="$TMP"/main
fallocate -l $((mainsize*bs)) "$main"
mke2fs -F "$main" > /dev/null 2>&1
sudo mount "$main" mainmount > /dev/null 2>&1
sudo mkdir mainmount/extlinux
sudo extlinux --install mainmount/extlinux > /dev/null 2>&1
sudo cp /usr/lib/syslinux/modules/bios/chain.c32 /usr/lib/syslinux/modules/bios/menu.c32 mainmount/extlinux
echo "UI menu.c32" | sudo tee mainmount/extlinux/extlinux.conf > /dev/null 2>&1

# the first partition to boot from is the first logical one
count=5

sum=0
i=0
# first we check how much space each iso content needs in an ext2 filesystem
for iso in *.iso; do
    i=$(($i+1))
	echo " ++ processing $iso"
	b="$TMP"/`basename "$iso" .iso`.ext2
	# get the size of the iso
	size=`stat -c %s "$iso"`
	# create an image of that size +20% for safety margin
	size10=$(((size*120)/100))
	fallocate -l $size10 "$b"
	mke2fs -F "$b" > /dev/null 2>&1
	#fuse-ext2 -o rw+ "$b" extmount
	#fuse-ext2 -v -o rw,force "$b" extmount -o debug > log 2>&1 &
	sudo mount "$b" extmount
	#fuseiso "$iso" isomount
	sudo mount "$iso" isomount > /dev/null 2>&1
	sudo cp -r isomount/. extmount
    if [ $i -eq 1 ]
    then
        sudo mv extmount/boot/isolinux extmount/extlinux
    else
        sudo mv extmount/isolinux extmount/extlinux
    fi
	sudo mv extmount/extlinux/isolinux.cfg extmount/extlinux/extlinux.conf
	sudo extlinux --install extmount/extlinux > /dev/null 2>&1
    sudo cp /usr/lib/syslinux/modules/bios/chain.c32 /usr/lib/syslinux/modules/bios/menu.c32 extmount/extlinux
	#fusermount -u extmount
	sudo umount extmount
	#fusermount -u isomount
	sudo umount isomount
	e2fsck -yf "$b" > /dev/null 2>&1
	resize2fs -M "$b" > /dev/null 2>&1
	newsize=`stat -c %s "$b"`
	sectorcount=$((newsize/bs+3))
	sum=$((sum+sectorcount*bs))
	sudo tee -a mainmount/extlinux/extlinux.conf > /dev/null << EOF
LABEL $count
	MENU LABEL $iso
	COM32 chain.c32
	APPEND hd0 $count
EOF
	count=$((count+1))
done

sudo umount mainmount

echo " ++ creating disk image"

# create the final image
root="$TMP"/root.img
fallocate -l $((sum+bs*(mainsize+2))) "$root"

# create the initial disk layout
parted -s -- "$root" mklabel msdos > /dev/null 2>&1
parted -s -- "$root" mkpart primary ext2 1s ${mainsize}s > /dev/null 2>&1
parted -s -- "$root" set 1 boot on > /dev/null 2>&1
parted -s -- "$root" mkpart extended $((mainsize+1))s -1s > /dev/null 2>&1

dd if="$main" of="$root" obs=$bs seek=1 conv=notrunc > /dev/null 2>&1
rm "$main"

# create partitions for all isos
start=$((mainsize+2))
for ext2 in "$TMP"/*.ext2; do
	echo " ++ filling with $ext2"
	size=`stat -c %s "$ext2"`
	ssize=$((size/bs+1))
	parted -s -- "$root" mkpart logical ext2 ${start}s $((start+ssize))s > /dev/null 2>&1
	# copy ext2 fs to newly created partition
	offset=`/sbin/parted -m "$root" unit s print | tail -1 | sed 's/^[0-9]\+:\([^:s]\+\)s:.*/\1/'`
	dd if="$ext2" of="$root" obs=$bs seek=$offset conv=notrunc > /dev/null 2>&1
	rm "$ext2"
	start=$((start+ssize+2))
done

# make the whole thing bootable
echo " ++ make bootable"
dd conv=notrunc bs=440 count=1 if=/usr/lib/syslinux/mbr/mbr.bin of="$root" > /dev/null 2>&1

rm -df extmount
rm -df isomount
rm -df mainmount

echo " ++ success! The result is stored in $root"
