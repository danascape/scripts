#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright (C) 2020 Saalim Quadri <saalimquadri1@gmail.com>
# Copyright (C) 2019 Shivam Kumar Jha <jha.shivam3@gmail.com>
#
# Build functions

# Store project path
PROJECT_DIR="$HOME/weeb/script"

# Create some folders
mkdir -p "$PROJECT_DIR/kernel/"

# Arguements check
if [ -z ${1} ] || [ -z ${2} ]; then
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
	URL=$(realpath "$1")
	echo "Copying file"
	cp -a ${1} ${PROJECT_DIR}/input/
fi
FILE=${URL##*/}
EXTENSION=${URL##*.}
UNZIP_DIR=${FILE/.$EXTENSION/}
[[ -d ${PROJECT_DIR}/kernels/${UNZIP_DIR} ]] && rm -rf ${PROJECT_DIR}/kernels/${UNZIP_DIR}

# Extract file
echo "Extracting file"
7z x ${PROJECT_DIR}/input/${FILE} -y -o${PROJECT_DIR}/kernels/${UNZIP_DIR} >/dev/null 2>&1
KERNEL_DIR="$(dirname "$(find ${PROJECT_DIR}/kernels/${UNZIP_DIR} -type f -name "AndroidKernel.mk" | head -1)")"
echo "done"

# Find defconfig
echo "Checking if defconfig exist ($2)"

if [ -f $KERNEL_DIR/arch/arm64/configs/$2-perf_defconfig ]; then
	echo "Starting build"
elif [ -f $KERNEL_DIR/arch/arm64/configs/vendor/$2-perf_defconfig ]; then
	echo "Starting build"
else
	echo "Defconfig not found"
	exit 1
fi

# Clone Toolchains
git clone --depth=1 https://github.com/stormbreaker-project/aarch64-linux-android-4.9 gcc
git clone --depth=1 https://github.com/stormbreaker-project/arm-linux-androideabi-4.9 gcc_32
git clone --depth 1 https://github.com/stormbreaker-project/stormbreaker-clang clang
echo "Toolchains cloned"

# Set Env
PATH="${PWD}/clang/bin:${PWD}/gcc/bin:${PWD}/gcc_32/bin:${PATH}"
export ARCH=arm64
export KBUILD_BUILD_HOST=stormbreaker
export KBUILD_BUILD_USER="stormCI"
export KBUILD_COMPILER_STRING="${PWD}/clang/bin/clang --version | head -n 1 | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"

# Build
cd "$KERNEL_DIR"

make O=out ARCH=arm64 $2-perf_defconfig >/dev/null 2>&1

make -j$(nproc --all) O=out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi- >logs.txt

if [ -f $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb ]; then
	echo "Build Complete"
else
	echo "Build Failed. Uploading logs"
	curl -F chat_id="${CHAT_ID}" \
		-F document=@"logs.txt" \
		https://api.telegram.org/bot${BOT_API_TOKEN}/sendDocument
fi

# Clone Anykernel
git clone -b $2 https://github.com/stormbreaker-project/AnyKernel3
cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/
cd AnyKernel3 && make normal >/dev/null 2>&1

ZIP=$(echo *.zip)
curl -F chat_id="${CHAT_ID}" -F document=@"$ZIP" "https://api.telegram.org/bot${BOT_API_TOKEN}/sendDocument" >/dev/null 2>&1
echo "Join @Stormbreakerci to get your builld"

#Cleanup
rm -rf "$KERNEL_DIR" "$UNZIP_DIR"
rm -rf "$PROJECT_DIR/input"
rm -rf "$PROJECT_DIR/kernels"
