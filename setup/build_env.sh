#!/usr/bin/env bash

# Copyright (C) 2019 Salim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

sudo apt update

sudo DEBIAN_FRONTEND=noninteractive \
	apt install -y \
	build-essential bc python curl \
	git zip ftp gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi \
	libssl-dev lftp zstd wget libelf-dev libfl-dev clang flex bison cpio \
	libyaml-dev golang-go python3-pip

PYTHON_PACKAGES="dtschema yamllint"
pip3 install "$PYTHON_PACKAGES"
