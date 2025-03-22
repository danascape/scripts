#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Setup Toolchain paths
# Set current path
WORK_DIR="/mnt/kernel"
TOOLCHAINS_PATH="$WORK_DIR/toolchains"

export PATH="${TOOLCHAINS_PATH}/toolchains/clang-11/bin:${TOOLCHAINS_PATH}/toolchains/gcc64/bin:${TOOLCHAINS_PATH}/toolchains/gcc32/bin:${TOOLCHAINS_PATH}/toolchains/prebuilts-misc/linux-x86/libufdt:${PATH}"

export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
ulimit -n 4096
