#!/usr/bin/env bash

# Copyright (C) 2019 Salim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

qemu-system-x86_64 \
	-M pc \
	-kernel arch/x86_64/boot/bzImage \
	-drive file=/home/saalim/Desktop/buildroot/buildroot/output/images/rootfs.ext2,if=virtio,format=raw \
	-append "rootwait root=/dev/vda console=tty1 console=ttyS0" \
	-net nic,model=virtio -net user \
	-serial stdio \
	-display none \
	-m 2048M,slots=2,maxmem=2176M

