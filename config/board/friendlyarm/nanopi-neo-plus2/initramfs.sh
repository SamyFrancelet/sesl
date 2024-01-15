#!/bin/bash
RAMFS=/buildroot/ramfs
RAMFS2=$RAMFS/t
mkdir $RAMFS
mkdir $RAMFS2
cd $RAMFS

mkdir -p $RAMFS2/{bin,dev,etc,home,lib,newroot,proc,root,usr/bin,usr/lib,sbin,sys}

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

# Copy shared libraries
cd lib
cp /buildroot/output/target/lib/ld-uClibc-1.0.42.so .
cp /buildroot/output/target/lib/libuClibc-1.0.42.so .
ln -s ld-uClibc.so.1 ld-uClibc.so.0
ln -s ld-uClibc-1.0.42.so ld-uClibc.so.1
ln -s libuClibc-1.0.42.so libc.so.0
ln -s libuClibc-1.0.42.so libc.so.1
cd $RAMFS2

# Generate /init file
cat > init << endofinput
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys

mount -n -t devtmpfs devtmpfs /dev
mount -t ext4 /dev/mmcblk0p2 /newroot
mount -n -t devtmpfs devtmpfs /newroot/dev

exec sh
# exec switch_root /newroot /sbin/init
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