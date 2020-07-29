#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright (C) 2020 Saalim Quadri <saalimquadri1@gmail.com>
# Copyright (C) 2019 Shivam Kumar Jha <jha.shivam3@gmail.com>
#

# Store some VARS
PROJECT_DIR="$HOME/weeb/script"
ORG="https://github.com/stormbreaker-project"
KERNEL_DIR="$PROJECT_DIR/kernelsource"
TOOLCHAIN="$PROJECT_DIR/toolchain"
CHAT_ID=
BOT_API_TOKEN=

# Create some folders
mkdir -p "$PROJECT_DIR/kernelsource"

# Arguements check
if [ -z ${1} ] || [ -z ${2} ] ; then
    echo -e "Usage: bash build_kernel.sh <device-name> <branch>"
    exit 1
fi

# Clone up the source (well)
echo "Cloning"
git clone $ORG/$1 -b $2 $KERNEL_DIR/$1 --depth 1 || { echo "Your device is not officially supported or wrong branch"; exit 1; rm -rf $PROJECT_DIR/kernelsource;}

# Find defconfig
echo "Checking if defconfig exist ($1)"

if [ -f $KERNEL_DIR/$1/arch/arm64/configs/$1-perf_defconfig ]
then
    echo "Starting build"
elif [ -f $KERNEL_DIR/$1/arch/arm64/configs/vendor/$1-perf_defconfig ]
then
    echo "Starting build"
else
    echo "Defconfig not found"
    rm -rf "$KERNEL_DIR"
    exit 1
fi

# Clone toolchain
echo "Checking if toolchains exist"
git clone --depth=1 https://github.com/stormbreaker-project/aarch64-linux-android-4.9 $TOOLCHAIN/gcc
git clone --depth=1 https://github.com/stormbreaker-project/arm-linux-androideabi-4.9 $TOOLCHAIN/gcc_32
git clone --depth 1 https://github.com/stormbreaker-project/stormbreaker-clang $TOOLCHAIN/clang

# Set Env
PATH="${TOOLCHAIN}/clang/bin:${TOOLCHAIN}/gcc/bin:${TOOLCHAIN}/gcc_32/bin:${PATH}"
export ARCH=arm64
export KBUILD_BUILD_HOST=danascape
export KBUILD_BUILD_USER="stormCI"
export KBUILD_COMPILER_STRING="${TOOLCHAIN}/clang/bin/clang --version | head -n 1 | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')";

# Build
cd "$KERNEL_DIR/$1"
echo "Started Build"

if [ -f $KERNEL_DIR/$1/arch/arm64/configs/$1-perf_defconfig ]
then
     make O=out ARCH=arm64 $1-perf_defconfig > /dev/null 2>&1
elif [ -f $KERNEL_DIR/$1/arch/arm64/configs/vendor/$1-perf_defconfig ]
then
    make O=out ARCH=arm64 vendor/$1-perf_defconfig > /dev/null 2>&1
fi

KERNEL_PATCHLEVEL="$( cat Makefile | grep PATCHLEVEL | head -n 1 | sed "s|.*=||1" | sed "s| ||g" )"
if [[ "$1" == "phoenix" ]];
then
     PATH="${TOOLCHAIN}/clang/bin:${PATH}"
     make -j$(nproc --all) O=out ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- CC=clang AR=llvm-ar OBJDUMP=llvm-objdump STRIP=llvm-strip NM=llvm-nm OBJCOPY=llvm-objcopy LD=ld.lld > logs.txt
else
     make -j$(nproc --all) O=out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi- > logs.txt
fi

if [ -f $KERNEL_DIR/$1/out/arch/arm64/boot/Image.gz-dtb ]
then
    echo "Build Complete"
else
    echo "Build Failed. Uploading logs"
    curl -F chat_id="${CHAT_ID}"  \
                    -F document=@"logs.txt" \
                    https://api.telegram.org/bot${BOT_API_TOKEN}/sendDocument > /dev/null 2>&1
    rm -rf "$KERNEL_DIR"
    exit 1
fi

# Clone Anykernel
git clone -b $1 https://github.com/stormbreaker-project/AnyKernel3
cp $KERNEL_DIR/$1/out/arch/arm64/boot/Image.gz-dtb AnyKernel3/
cd AnyKernel3 && make normal > /dev/null 2>&1

ZIP=$(echo *.zip)
curl -F chat_id="${CHAT_ID}" -F document=@"$ZIP" "https://api.telegram.org/bot${BOT_API_TOKEN}/sendDocument" > /dev/null 2>&1
echo "Join @Stormbreakerci to get your builld"

# Cleanup
rm -rf "$KERNEL_DIR"
