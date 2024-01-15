#!/bin/sh
BOARD_DIR="$(dirname $0)"
BUILDROOT_DIR="/buildroot"
IMAGES_DIR="/buildroot/output/images"

# cp $BOARD_DIR/kernel_fdt.its $IMAGES_DIR
# mkimage -f $IMAGES_DIR/kernel_fdt.its -E $IMAGES_DIR/Image.itb

mkimage -C none -A arm64 -T script -d $BOARD_DIR/boot.cmd $IMAGES_DIR/boot.scr

# Generate boot.ext4 image
rm -rf $IMAGES_DIR/boot.ext4
dd if=/dev/zero of=$IMAGES_DIR/boot.ext4 bs=1024 count=65536
mkfs.ext4 -L boot $IMAGES_DIR/boot.ext4

cp $BOARD_DIR/rootfs_overlay/luks_pw $IMAGES_DIR/

# Execute initramfs.sh
$BOARD_DIR/initramfs.sh

cd /buildroot

# Insert Image, dtb, uInitrd and boot.scr into boot.ext4 
mount -o loop $IMAGES_DIR/boot.ext4 /mnt
#cp $IMAGES_DIR/Image.itb /mnt
cp $IMAGES_DIR/Image /mnt
cp $IMAGES_DIR/sun50i-h5-nanopi-neo-plus2.dtb /mnt
cp $IMAGES_DIR/uInitrd /mnt
cp $IMAGES_DIR/boot.scr /mnt
umount /mnt

# Generate LUKS image
cp $BOARD_DIR/rootfs_overlay/luks_pw $IMAGES_DIR/
hexdump $IMAGES_DIR/luks_pw
dd if=/dev/zero of=$IMAGES_DIR/rootfs.luks.ext4 bs=1024 count=65536
echo "YES" | cryptsetup --pbkdf pbkdf2 luksFormat $IMAGES_DIR/rootfs.luks.ext4 $IMAGES_DIR/luks_pw

# Create mapping, format LUKS partition and insert rootfs.ext4 into LUKS image
cryptsetup open --type luks --key-file=/$IMAGES_DIR/luks_pw $IMAGES_DIR/rootfs.luks.ext4 rootfs
mkfs.ext4 -L luks /dev/mapper/rootfs
mkdir -p /luks/
mkdir -p /mnt/
mount /dev/mapper/rootfs /luks/
mount -o loop $IMAGES_DIR/rootfs.ext4 /mnt/
rsync -a /mnt/ /luks/
umount /mnt/
umount /luks/
cryptsetup close rootfs