#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri <danascape@gmail.com>
# Copyright (C) 2018 Harsh 'MSF Jarvis' Shandilya
# Copyright (C) 2018 Akhil Narang
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Script to setup an AOSP Build environment on Ubuntu 22.04

# Update the ubuntu repositories
echo "Artemis: Updating repositories"
sudo apt update -qq

SILENCE=1 # Set to 1 to silence output
APT_INSTALL="sudo DEBIAN_FRONTEND=noninteractive apt install -y"
if [ "$SILENCE" -eq 1 ]; then
    APT_INSTALL="$APT_INSTALL >/dev/null 2>&1"
fi

echo "Artemis: Installing base packages"
eval "$APT_INSTALL" \
    adb autoconf automake axel bc bison build-essential \
    ccache clang cmake curl expat fastboot flex g++ \
    g++-multilib gawk gcc gcc-multilib git git-lfs gnupg gperf \
    htop imagemagick lib32ncurses5-dev lib32z1-dev libtinfo5 libc6-dev libcap-dev \
    libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses5-dev \
    libsdl1.2-dev libssl-dev libtool libxml2 libxml2-utils '^lzma.*' lzop \
    maven ncftp ncurses-dev patch patchelf pkg-config pngcrush \
    pngquant python2.7 python3 python3-pyelftools python-all-dev re2c schedtool squashfs-tools subversion \
    texinfo unzip w3m xsltproc zip zlib1g-dev lzip \
    libxml-simple-perl libswitch-perl apt-utils rsync

echo "Artemis: Installing Extra Packages"
eval "$APT_INSTALL" \
	ftp \
	lftp zstd wget \
	python3-pip \
	libnl-3-dev libnl-genl-3-dev libevent-dev libreadline-dev libsqlite3-dev libdevmapper-dev \
	git-email

echo "Artemis: Installing go-lang"
eval "$APT_INSTALL" \
	golang-go

echo "Artemis: Install QEMU"
eval "$APT_INSTALL" \
	qemu-system-x86

echo "Artemis: Installing RPI cross compiler"
eval "$APT_INSTALL" \
	gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi 

echo "Artemis: Installing linux mainline packages"
eval "$APT_INSTALL" \
	libelf-dev libfl-dev libyaml-dev cpio kpartx

echo "Artemis: Installing Shell stuff"
eval "$APT_INSTALL" \
	swig shellcheck jq shfmt

echo -e "Artemis: Setting up udev rules for adb!"
sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/M0Rf30/android-udev-rules/master/51-android.rules
sudo chmod 644 /etc/udev/rules.d/51-android.rules
sudo chown root /etc/udev/rules.d/51-android.rules
sudo systemctl restart udev

echo "Artemis: Installing repo"
sudo curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
sudo chmod a+rx /usr/local/bin/repo

pip3 install dtschema yamllint python-magic flake8

echo "Artemis: All done!"