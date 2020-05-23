#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright (C) 2020 Saalim Quadri <saalimquadri1@gmail.com>
# Copyright (C) 2019 Shivam Kumar Jha <jha.shivam3@gmail.com>
#
# Build functions

# Store project path
PROJECT_DIR="$HOME/weeb/scripts"

# Create some folders
mkdir -p "$PROJECT_DIR/kernel/"

# Arguements check
if [ -z ${1} ] || [ -z ${2} ] ; then
    echo -e "Usage: bash build_kernel.sh <kernel zip link/file> <defconfig name>"
    exit 1
fi

# Download compressed kernel source
if [[ "$1" == *"http"* ]]; then
    echo "Downloading zip"
    mkdir "$PROJECT_DIR/input"
    cd ${PROJECT_DIR}/input
    aria2c -q -s 16 -x 16 "$1" -d ${PROJECT_DIR}/input -o kernel.zip || { echo "Download failed!"; }
    URL=$PROJECT_DIR/input/${FILE}
    [[ -e ${URL} ]] && du -sh ${URL}
else
    URL=$( realpath "$1" )
    echo "Copying file"
    cp -a ${1} ${PROJECT_DIR}/input/
fi
FILE=${URL##*/}
EXTENSION=${URL##*.}
UNZIP_DIR=${FILE/.$EXTENSION/}
[[ -d ${PROJECT_DIR}/kernels/${UNZIP_DIR} ]] && rm -rf ${PROJECT_DIR}/kernels/${UNZIP_DIR}

# Extract file
echo "Extracting file"
7z x ${PROJECT_DIR}/input/${FILE} -y -o${PROJECT_DIR}/kernels/${UNZIP_DIR} > /dev/null 2>&1
KERNEL_DIR="$(dirname "$(find ${PROJECT_DIR}/kernels/${UNZIP_DIR} -type f -name "AndroidKernel.mk" | head -1)")"
echo "done"

# Find defconfig
echo "Checking if defconfig exist ($2)"
DEFCONFIG=$ (grep -rf $2-perf_defconfig $KERNEL_DIR/arch/arm64/configs/ )
it [ $DEFCONFIG -eq 1]
then
    echo "Starting build"
else
    echo "Defconfig not found"
fi
