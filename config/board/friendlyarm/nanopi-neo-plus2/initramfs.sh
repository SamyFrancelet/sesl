#!/bin/bash
RAMFS=/buildroot/ramfs
RAMFS2=$RAMFS/t
mkdir $RAMFS
mkdir $RAMFS2
cd $RAMFS

mkdir -p $RAMFS2/{bin,dev,etc,home,lib,newroot,proc,root,usr/bin,usr/sbin,usr/lib,sbin,sys,run}

cd $RAMFS2
cd bin
cp /buildroot/output/target/bin/busybox .

# Create symlinks to busybox
ln -s busybox mount
ln -s busybox umount
ln -s busybox sh
ln -s busybox dmesg
ln -s busybox echo
ln -s busybox ls
ln -s busybox ln
ln -s busybox mkdir
ln -s busybox mknod
ln -s busybox sleep
cd $RAMFS2

cd usr/bin
cp /buildroot/output/target/usr/bin/strace .
cd $RAMFS2

cd sbin
ln -s ../bin/busybox switch_root
cd $RAMFS2

cd usr/sbin
cp /buildroot/output/target/usr/sbin/cryptsetup .
cd $RAMFS2

# Copy shared libraries
cd lib
cp /buildroot/output/target/lib/ld-uClibc-1.0.42.so .
cp /buildroot/output/target/lib/libuClibc-1.0.42.so .
cp /buildroot/output/target/lib/libuuid.so.1.3.0 .
cp /buildroot/output/target/lib/libblkid.so.1.1.0 .
cp /buildroot/output/target/lib/libatomic.so.1.2.0 .
ln -s ld-uClibc.so.1 ld-uClibc.so.0
ln -s ld-uClibc-1.0.42.so ld-uClibc.so.1
ln -s libuClibc-1.0.42.so libc.so.0
ln -s libuClibc-1.0.42.so libc.so.1
ln -s libuuid.so.1.3.0 libuuid.so.1
ln -s libblkid.so.1.1.0 libblkid.so.1
ln -s libatomic.so.1.2.0 libatomic.so.1
cd $RAMFS2

cd usr/lib
cp /buildroot/output/target/usr/lib/libcryptsetup.so.12.8.0 .
cp /buildroot/output/target/usr/lib/libpopt.so.0.0.1 .
cp /buildroot/output/target/usr/lib/libdevmapper.so.1.02 .
cp /buildroot/output/target/usr/lib/libssl.so.1.1 .
cp /buildroot/output/target/usr/lib/libcrypto.so.1.1 .
cp /buildroot/output/target/usr/lib/libargon2.so.1 .
cp /buildroot/output/target/usr/lib/libjson-c.so.5.2.0 .
cp /buildroot/output/target/usr/lib/libiconv.so.2.6.0 .
ln -s libcryptsetup.so.12.8.0 libcryptsetup.so.12
ln -s libpopt.so.0.0.1 libpopt.so.0
ln -s libjson-c.so.5.2.0 libjson-c.so.5
ln -s libiconv.so.2.6.0 libiconv.so.2
cd $RAMFS2

# Copy luks_pw into initramfs at /luks_pw
cp /buildroot/output/images/luks_pw $RAMFS2/luks_pw

# Generate /init file
cat > init << endofinput
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys

mount -n -t devtmpfs devtmpfs /dev
cryptsetup open --type luks --key-file=/luks_pw /dev/mmcblk0p3 luks_rootfs
mount /dev/mapper/luks_rootfs /newroot
mount -n -t devtmpfs devtmpfs /newroot/dev

exec switch_root /newroot /sbin/init
endofinput

# Make /init executable
chmod 755 init

# initramfs -cpio-> Initrd -gzip-> Initrd.gz -mkimage-> uInitrd
cd $RAMFS2
find . | cpio --quiet -o -H newc > ../Initrd

cd $RAMFS
gzip -9 -c Initrd > Initrd.gz

mkimage -A arm -T ramdisk -C none -d Initrd.gz uInitrd

# Copy uInitrd to output/images
cp /buildroot/ramfs/uInitrd /buildroot/output/images/
cd /buildroot

# Clean up
rm -rf $RAMFS