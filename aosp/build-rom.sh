#!/usr/bin/env bash

# Copyright (C) 2019 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

# Arguements check
if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ]; then
	echo -e "Usage: bash build-rom.sh <device-name> <variant> <package-name>"
	return
fi

# Store variables
DEVICE="$1"
PACKAGE_NAME="$3"
ROM_DIR="$PWD" # By default
VARIANT="$2"

# Check envsetup
if [ -f "$ROM_DIR"/build/envsetup.sh ]; then
	echo "Starting build"
	source build/envsetup.sh
else
	echo "build-ROM: Either rom path is wrong or rom isnt synced"
	return
fi

# Lunch
breakfast "$DEVICE" "$VARIANT"

# Start the build
make "$PACKAGE_NAME" -j"$(nproc --all)" |& tee buildlogs.txt
