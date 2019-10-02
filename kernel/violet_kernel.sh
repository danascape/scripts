#!/bin/bash
rm /home/travis/out/arch/arm64/boot/Image.gz
rm /home/travis/out/arch/arm64/boot/Image.gz-dtb
#make clean&&make mrproper
#make O=../kernel clean&&make O=../kernel mrproper
export ARCH=arm64
export LD_LIBRARY_PATH=/home/travis/android/clang/clang-r365631/lib64:$LD_LIBRARY_PATH
export PATH=/home/ZARASSA/android/clang/clang-r365631/bin:$PATH
export CC=clang
export O=../out
export CROSS_COMPILE=/home/travis/android/linaro/bin/aarch64-elf-
export CROSS_COMPILE_ARM32=/home/travis/android/linaro32/bin/arm-eabi-
export CLANG_TRIPLE=aarch64-linux-gnu-
export KERNEL_DIR=/home/travis/kernel
export OUT_DIR=/home/travis/kernel/out
#export ZIPNAME="mykernel-$(date -d "+1 hour" +%d.%m.%Y-%H:%M:%S).zip"

make O=../out vendor/violet-perf_defconfig
make -j8 O=../out

if [ -f "${OUT_DIR}/arch/arm64/boot/Image.gz" ]; then
 echo -e "\033[1;32m Kernel compiled successfully! \033[0m"
 sleep 3s
 cd ${KERNEL_DIR}/build
 rm *.zip > /dev/null 2>&1
 rm -rf kernel
 mkdir kernel
 rm -rf dtbs
 mkdir dtbs
 cp ${OUT_DIR}/arch/arm64/boot/dts/qcom/*.dtb ${KERNEL_DIR}/build/dtbs/
 cp ${OUT_DIR}/arch/arm64/boot/Image.gz ${KERNEL_DIR}/build/kernel/
 cd ${KERNEL_DIR}/build/
 zip -r9 shadow.zip * -x .git README.md *placeholder
# gdrive upload ${ZIPNAME}
else
 echo -e "\033[1;31m Kernel compilation failed! \033[0m"
 exit 1
fi
