#!/bin/sh
BOARD_DIR="$(dirname $0)"
BUILDROOT_DIR="/buildroot"
IMAGES_DIR="/buildroot/output/images"

cp $BOARD_DIR/kernel_fdt.its $IMAGES_DIR
mkimage -f $IMAGES_DIR/kernel_fdt.its -E $IMAGES_DIR/Image.itb

mkimage -C none -A arm64 -T script -d $BOARD_DIR/boot.cmd $IMAGES_DIR/boot.scr

# Generate boot.ext4 image
rm -rf $IMAGES_DIR/boot.ext4
dd if=/dev/zero of=$IMAGES_DIR/boot.ext4 bs=1024 count=65536
mkfs.ext4 -L boot $IMAGES_DIR/boot.ext4

# Insert Image.itb and boot.scr into boot.ext4 
mount -o loop $IMAGES_DIR/boot.ext4 /mnt
cp $IMAGES_DIR/Image.itb /mnt
cp $IMAGES_DIR/boot.scr /mnt
umount /mnt


