setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootwait

ext4load mmc 0:1 0x40000000 Image.itb

bootm 0x40000000
