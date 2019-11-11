#!/bin/bash
export ARCH=arm64
export LD_LIBRARY_PATH=$HOME/assets/clang/clang-r353983b/lib64:$LD_LIBRARY_PATH
export PATH=$HOME/assets/clang/clang-4691093/bin:$PATH
export CC=clang
export O=out
export CROSS_COMPILE=$HOME/assets/arm64/bin/aarch64-elf-
export CROSS_COMPILE_ARM32=$HOME/assets/arm32/bin/arm-eabi-
export CLANG_TRIPLE=aarch64-linux-gnu-
export KERNEL_DIR=$HOME/kernel/
export OUT_DIR=$HOME/kernel/out

make O=out $DEVICE_defconfig
make -j$(nproc --all) O=out

if [ -f "${OUT_DIR}/arch/arm64/boot/Image.gz" ]; then
 echo -e "\033[1;32m Kernel compiled successfully! \033[0m"
 sleep 3s
