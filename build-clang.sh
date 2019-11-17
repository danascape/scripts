#!/usr/bin/env bash
echo "Cloning dependencies"
git clone --depth=1 -b master https://github.com/stormbreaker-project/kernel_xiaomi_lavender.git kernel
cd kernel
git clone --depth=1 https://github.com/Haseo97/Clang-10.0.0 clang
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b android-9.0.0_r39 stock
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-9.0.0_r39 stock_32
git clone --depth=1 https://github.com/iamsaalim/AnyKernel3 -b x00p AnyKernel
echo "Done"
GCC="$(pwd)/aarch64-linux-android-"
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz-dtb
TANGGAL=$(date +"%F-%S")
START=$(date +"%s")
export CONFIG_PATH=$PWD/arch/arm64/configs/X00P_defconfig
PATH="${PWD}/clang/bin:${PWD}/stock/bin:${PWD}/stock_32/bin:${PATH}"
export ARCH=arm64
export KBUILD_BUILD_HOST=stormbreaker
export KBUILD_BUILD_USER="root"
# Compile plox
function compile() {
   make O=out ARCH=arm64 X00P_defconfig
       make -j$(nproc --all) O=out \
                             ARCH=arm64 \
			     CROSS_COMPILE=aarch64-linux-android- \
			     CROSS_COMPILE_ARM32=arm-linux-androideabi-
   cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
}
# Zipping
function zipping() {
    cd AnyKernel || exit 1
    zip -r9 Kernel-lavender-${TANGGAL}.zip *
    cd .. 
}
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
