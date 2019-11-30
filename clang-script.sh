#Cleanup output dir
rm -rf out
mkdir out

#export Sys-vars
export ARCH=arm64
export SUBARCH=arm64
export AR=llvm-ar
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
                      NM="llvm-nm"
                      OBJCOPY="llvm-objcopy"
                      OBJDUMP="llvm-objdump"
                      STRIP="llvm-strip"

