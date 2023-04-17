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
DT_FILE=$1

# Run tests on arm architecture
cd linux
make -j8 O=out/arm ARCH=arm defconfig
make -j8 O=out/arm ARCH=arm dt_binding_check DT_SCHEMA_FILES=$DT_FILE
make -j8 O=out/arm ARCH=arm dtbs_check DT_SCHEMA_FILES=$DT_FILE
cd ../

# RUn tests on arm64 architecture
cd linux
make -j8 O=out/arm64 ARCH=arm64 defconfig
make -j8 O=out/arm64 ARCH=arm64 dt_binding_check DT_SCHEMA_FILES=$DT_FILE
make -j8 O=out/arm64 ARCH=arm64 dtbs_check DT_SCHEMA_FILES=$DT_FILE
cd ../
