#!/bin/bash

QVER=loongson-v1.0
# Based on v3.10
KVER=loongnix-release-1903
RVER=2016.05
# Minimal memory for boot is 256M, but with graphic, 1024M is required
MEM=1024M

# maxcpus=1 must be passed to not hang at booting
# Booting CPU#1...
# [    0.150000] CPU#1, func_pc=ffffffff80da1c7c, sp=980000000c0f3eb0, gp=980000000c0f0000
# [    0.256000] random: fast init done

# Graphic boot or not, 1 for graphic, 0 for serial
G=1
if [ $G -eq 1 ]; then
  CONSOLE=tty0
  GOPT=
else
  GOPT=-nographic
  CONSOLE=ttyS0
fi

./qemu/$QVER/bin/qemu-system-mips64el -M ls2k -m $MEM -smp 1 -no-reboot $GOPT \
	-kernel kernel/$KVER/vmlinuz \
	-initrd root/$RVER/rootfs.cpio.gz \
	-dtb kernel/$KVER/2k1000_board.dtb \
	-device usb-mouse -device usb-kbd -show-cursor \
	-append "route=172.17.0.5 root=/dev/ram0 console=$CONSOLE maxcpus=1"
	#-net nic,model=synopgmac -net tap
