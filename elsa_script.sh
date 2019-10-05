export KBUILD_BUILD_USER=iamsaalim
export KBUILD_BUILD_HOST=ArchLinux
export ARCH=arm64
export CROSS_COMPILE=/home/travis/aarch64-linaro-linux-android/bin/aarch64-linaro-linux-android-

DIR=$(pwd)
BUILD="$DIR/build"
OUT="$DIR/zip"
ZIPNAME="DOTS_H990_kernel-leicxan_jahlex-v1.0.zip"
NPR=`expr $(nproc) + 1`

cd $HOME

git clone https://github.com/toolchains-compile/aarch64-linaro-linux-android.git

echo "cleaning build..."
if [ -d "$BUILD" ]; then
rm -rf "$BUILD"
fi
if [ -d "$OUT" ]; then
rm -rf "$OUT/modules"
rm -rf "$OUT/Image.gz-dtb"
fi

echo "setting up build..."
mkdir "$BUILD"
make O="$BUILD" elsa_global_h990_defconfig

echo "building kernel..."
time make O="$BUILD" -j$NPR 2>&1 |tee ../compile.log

echo "building modules..."
make O="$BUILD" INSTALL_MOD_PATH="." INSTALL_MOD_STRIP=1 modules_install
rm $BUILD/lib/modules/*/build
rm $BUILD/lib/modules/*/source

mkdir -p $OUT/modules
mv "$BUILD/arch/arm64/boot/Image.gz-dtb" "$OUT/Image.gz-dtb"
find "$BUILD/lib/modules/" -name *.ko | xargs -n 1 -I '{}' mv {} "$OUT/modules"
cd zip
mv modules/exfat.ko modules/texfat.ko
zip -q -r "$ZIPNAME" anykernel.sh META-INF tools modules Image.gz-dtb setfiles.conf ramdisk patch

mv "$ZIPNAME" "/home/travis/$ZIPNAME"

rm -rf "$OUT/modules"
rm -rf "$OUT/Image.gz-dtb"

echo "Done !"

