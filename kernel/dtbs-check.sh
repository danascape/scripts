#!/usr/bin/env bash

# Copyright (C) 2019 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

# Arguements check
if [ -z ${1} ]; then
	# The DT_SCHEMA_PATH should be from kernel home
	echo -e "Usage: bash dtbs-check.sh <DT_SCHEMA_PATH>"
	exit 1
fi

# Store Variables
# The path of the DT_SCHEMA from kernel source home
DT_FILE=$1

# The path to the kernel source
KERNEL_DIR="/home/saalim/testing/linux"

# Architecture to run the test on
ARCH="arm arm64"

# Change to kernel source directory
cd $KERNEL_DIR

# Run tests
for arch in $ARCH; do
	make -j$(nproc --all) O=out/$arch ARCH=$arch defconfig
	make -j$(nproc --all) O=out/$arch ARCH=$arch dt_binding_check DT_SCHEMA_FILES=$DT_FILE
	make -j$(nproc --all) O=out/$arch ARCH=$arch dtbs_check DT_SCHEMA_FILES=$DT_FILE
done
