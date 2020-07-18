#!/usr/bin/env bash

# Copyright (C) 2018 Abubakar Yagob (blacksuan19)
# Copyright (C) 2018 Rama Bondan Prakoso (rama982)
# Copyright (C) 2020 Saalim Quadri (iamsaalim)
# SPDX-License-Identifier: GPL-3.0-or-later

# Color
green='\033[0;32m'
echo -e "$green"

# Main Environment
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
ZIP_DIR=$KERNEL_DIR/AnyKernel3
CONFIG=X00P_defconfig
CORES=$(grep -c ^processor /proc/cpuinfo)
THREAD="-j$CORES"
CROSS_COMPILE+="ccache "
CROSS_COMPILE+="$PWD/gcc/bin/aarch64-linux-android-"
CROSS_COMPILE_ARM32+="$PWD/gcc32/bin/arm-linux-androideabi-"

# Modules environtment
OUTDIR="$PWD/out/"
SRCDIR="$PWD/"
MODULEDIR="$PWD/AnyKernel3/modules/vendor/lib/modules/"
PRIMA="$PWD/AnyKernel3/modules/vendor/lib/modules/wlan.ko"
PRONTO="$PWD/AnyKernel3/modules/vendor/lib/modules/pronto/pronto_wlan.ko"
STRIP="$PWD/gcc/bin/$(echo "$(find "$PWD/gcc/bin" -type f -name "aarch64-*-gcc")" | awk -F '/' '{print $NF}' |\
			sed -e 's/gcc/strip/')"

# Export
export ARCH=arm64
export SUBARCH=arm64
export PATH=/usr/lib/ccache:$PATH
export CROSS_COMPILE
export CROSS_COMPILE_ARM32
export KBUILD_BUILD_USER="danascape"
export KBUILD_BUILD_HOST="StormCI"

# initialise stormbreaker logo
echo -e "             ,:\                       ";
echo -e "            //  \_()  ___              ";
echo -e "           ||   |    |   ||            ";
echo -e "           ||   |    |   ||            ";
echo -e "           ||   |____|___||            ";
echo -e "            \\  / ||                   ";
echo -e "             `:/  ||                   ";
echo -e "                  ||                   ";
echo -e "                  ||                   ";
echo -e "                  XX                   ";
echo -e "                  XX                   ";
echo -e "                  XX                   ";
echo -e "                  XX                   ";
echo -e "                  OO                   ";
echo -e "                  `'                   ";

# Main script
while true; do
	echo -e "\n[1] Build Kernel"
	echo -e "[2] Regenerate defconfig"
	echo -e "[3] Source cleanup"
	echo -e "[4] Create flashable zip with modules"
	echo -e "[5] Quit"
	echo -ne "\n(i) Please enter a choice[1-5]: "

	read choice

	if [ "$choice" == "1" ]; then
		echo -e "\n(i) Cloning toolcahins if folder not exist..."
		git clone https://github.com/stormbreaker-project/aarch64-linux-android-4.9 --depth 1 gcc
                git clone https://github.com/stormbreaker-project/arm-linux-androideabi-4.9 --depth 1 gcc32
		echo -e ""
		make  O=out $CONFIG $THREAD &>/dev/null
		make  O=out $THREAD & pid=$!

		BUILD_START=$(date +"%s")
		DATE=`date`

		echo -e "\n#######################################################################"

		echo -e "(i) Build started at $DATE using $CORES thread"

		spin[0]="-"
		spin[1]="\\"
		spin[2]="|"
		spin[3]="/"
		echo -ne "\n[Please wait...] ${spin[0]}"
		while kill -0 $pid &>/dev/null
		do
			for i in "${spin[@]}"
			do
				echo -ne "\b$i"
				sleep 0.1
			done
		done

		if ! [ -a $KERN_IMG ]; then
			echo -e "\n(!) Kernel compilation failed, See buildlog to fix errors"
			echo -e "#######################################################################"
			exit 1
		fi

		BUILD_END=$(date +"%s")
		DIFF=$(($BUILD_END - $BUILD_START))

		echo -e "\nImage-dtb compiled successfully."

		echo -e "#######################################################################"

		echo -e "(i) Total time elapsed: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

		echo -e "#######################################################################"
	fi

	if [ "$choice" == "2" ]; then
		echo -e "\n#######################################################################"

		make O=out $CONFIG savedefconfig &>/dev/null
		cp out/defconfig arch/arm64/configs/$CONFIG &>/dev/null

		echo -e "(i) Defconfig generated."

		echo -e "#######################################################################"
	fi

	if [ "$choice" == "3" ]; then
		echo -e "\n#######################################################################"

		make O=out clean &>/dev/null
		make mrproper &>/dev/null
		rm -rf out/*

		echo -e "(i) Kernel source cleaned up."

		echo -e "#######################################################################"
	fi

	if [ "$choice" == "4" ]; then
		echo -e "\n#######################################################################"
        echo -e "\n(i) Cloning AnyKernel3 if folder not exist..."
		git clone -b X00P https://github.com/stormbreaker-project/AnyKernel3
		echo -e "\n(i) Strip and move modules to AnyKernel3..."

		# thanks to @adekmaulana

		cd $ZIP_DIR
		make clean &>/dev/null
		cd ..

		for MOD in $(find "${OUTDIR}" -name '*.ko') ; do
			"${STRIP}" --strip-unneeded --strip-debug "${MOD}" &> /dev/null
			"${SRCDIR}"/scripts/sign-file sha512 \
					"${OUTDIR}/signing_key.priv" \
					"${OUTDIR}/signing_key.x509" \
					"${MOD}"
			find "${OUTDIR}" -name '*.ko' -exec cp {} "${MODULEDIR}" \;
			case ${MOD} in
				*/wlan.ko)
					cp -ar "${MOD}" "${PRIMA}"
					cp -ar "${MOD}" "${PRONTO}"
					cp -ar "${MOD}" "{MODULEDIR}"
			esac
		done
		echo -e "\n(i) Done moving modules"

		cd $ZIP_DIR
		cp $KERN_IMG $ZIP_DIR/Image.gz-dtb
		make normal &>/dev/null
		cd ..

		echo -e "Flashable zip generated under $ZIP_DIR."

		echo -e "#######################################################################"
	fi

	if [ "$choice" == "5" ]; then
		exit
	fi

done
echo -e "$nc"
