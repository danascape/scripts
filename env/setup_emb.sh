#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
#

export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
ulimit -n 4096

#  Env Variables
CURRENT_DIR="$PWD"

# Check if caching dirs exist
if [ -d "$CURRENT_DIR"/../downloads ] || [ -d "$CURRENT_DIR"/../sstate-cache ]; then
	echo "env: Setting cached dirs path"
	eval export DL_DIR="$(pwd)"/../downloads/
    eval export SSTATE_DIR="$(pwd)"/../sstate-cache/
else
	echo "env: Cached paths does not exist. Skipping!"
    echo "env: Good luck! with clean build"
	return
fi