#!/usr/bin/env bash

# Copyright (C) 2020 Saalim Quadri (iamsaalim)
# SPDX-License-Identifier: GPL-3.0-or-later

# Script to build kernel using latest proton-clang

# Main environtment
KERNEL_DIR=$(pwd)

# download proton
wget -O proton.tar.zst https://kdrag0n.dev/files/redirector/proton_clang-latest.tar.zst
mkdir -p ../toolchain/clang
tar -I zstd -xvf *.tar.zst -C ../toolchain/clang --strip-components=1

# paths setup
export PATH="$HOME/clang/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/clang/lib:$HOME/clang/lib64:$LD_LIBRARY_PATH"
export KBUILD_COMPILER_STRING="$($HOME/clang/bin/clang --version | head -n 1 | perl -pe 's/\((?:http|git).*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//' -e 's/^.*clang/clang/')"
export KBUILD_BUILD_USER="danascape"
export KBUILD_BUILD_HOST="StormCI"

make O=out ARCH=arm64 X00P_defconfig

make -j$(nproc --all) O=out \
	ARCH=arm64 \
	CC=clang \
	CLANG_TRIPLE=aarch64-linux-gnu- \
	CROSS_COMPILE=aarch64-linux-gnu- \
	CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
	LLVM="llvm-" \
	AR=llvm-ar \
	NM=llvm-nm \
	OBJCOPY=llvm-objcopy \
	OBJDUMP=llvm-objdump \
	STRIP=llvm-strip
