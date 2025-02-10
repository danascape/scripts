#!/usr/bin/env bash

# Copyright (C) 2019 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

sudo apt update

sudo DEBIAN_FRONTEND=noninteractive \
	apt install -y \
	build-essential bc python3 curl \
	git zip ftp gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi \
	libssl-dev lftp zstd wget libelf-dev libfl-dev clang flex bison cpio \
	libyaml-dev golang-go python3-pip swig shellcheck jq shfmt kpartx \
 	libnl-3-dev libnl-genl-3-dev libevent-dev libreadline-dev \
	qemu-system-x86

pip3 install dtschema yamllint python-magic flake8
