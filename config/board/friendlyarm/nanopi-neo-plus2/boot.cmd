setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootwait

ext4load mmc 0 $kernel_addr_r Image
ext4load mmc 0 $fdt_addr_r sun50i-h5-nanopi-neo-plus2.dtb
ext4load mmc 0 0x50000000 uInitrd

booti $kernel_addr_r 0x50000000 $fdt_addr_r
