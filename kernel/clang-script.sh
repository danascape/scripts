#!/bin/bash
echo "$RANDOM"  # Supported in bash. No warnings.
#Cleanup output dir
rm -rf out
mkdir out

#export Sys-vars
export ARCH=arm64
export SUBARCH=arm64
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip
#export DTC_EXT=dtc

#Make config
make O=out ARCH=arm64 vendor/violet-perf_defconfig

#Build kernel
make -j20 O=out \
                      ARCH=arm64 \
                      CC="ccache $HOME/tc/clang-r365631c/bin/clang" \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE="$HOME/tc/aarch64-linux-android-4.9/bin/aarch64-linux-android-" \
                      CROSS_COMPILE_ARM32="$HOME/tc/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-"

