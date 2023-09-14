#!/usr/bin/env bash

# Copyright (C) 2019 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

argument="$1"
drive_args="file=/home/saalim/Desktop/buildroot/buildroot/output/images/rootfs.ext2,if=virtio,format=raw"
kernel="arch/x86_64/boot/bzImage"

case "$argument" in
	--gdb)
		{
			EXTRA_ARGS='-s -S'
		}
	;;
esac

qemu-system-x86_64 -M pc -kernel $kernel -drive $drive_args -append "rootwait root=/dev/vda console=tty1 console=ttyS0" -net nic,model=virtio -net user -serial stdio -display none -m 2048M,slots=2,maxmem=2176M "${EXTRA_ARGS}"
