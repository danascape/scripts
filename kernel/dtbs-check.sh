#!/usr/bin/env bash

# Copyright (C) 2019 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

# Arguements check
if [ -z "${1}" ]; then
	# The DT_SCHEMA_PATH should be from kernel home
	echo -e "Usage: bash dtbs-check.sh <DT_SCHEMA_PATH>"
	exit 1
fi

# Store Variables
# The path of the DT_SCHEMA from kernel source home
DT_FILE="$1"

# Scripts Path
export SCRIPTS_PATH="$HOME/scripts"

# Inherit extra kernel functions
. "$SCRIPTS_PATH"/kernel/kernel_functions.sh --source-only

if ! is_kernel_root "$PWD"; then
	echo "error: Execute this command in a kernel tree."
	exit 125
fi

# Architecture to run the test on
ARCH="arm arm64"

# Run tests
for arch in $ARCH; do
	make -j"$(nproc --all)" O=out/"$arch" ARCH="$arch" defconfig
	make -j"$(nproc --all)" O=out/"$arch" ARCH="$arch" dt_binding_check DT_SCHEMA_FILES="$DT_FILE"
	make -j"$(nproc --all)" O=out/"$arch" ARCH="$arch" dtbs_check DT_SCHEMA_FILES="$DT_FILE"
done
