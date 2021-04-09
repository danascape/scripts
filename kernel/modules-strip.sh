#!/usr/bin/env bash

# Copyright (C) 2020-21 Saalim Quadri (danascape)
# SPDX-License-Identifier: GPL-3.0-or-later

STRIP="$TC_DIR/bin/$(echo "$(find "$TC_DIR/bin" -type f -name "aarch64-*-gcc")" | awk -F '/' '{print $NF}' | sed -e 's/gcc/strip/')"
SRCDIR="$PWD"
TC_DIR=""
OUTDIR="out/"

# Check if TC_DIR is set
if [ -z ${TC_DIR} ]; then
	echo -e "Set toolchain dir"
	exit 1
fi

# Create modules DIR
mkdir modules
MODULEDIR="$PWD/modules"

# Strip modules and copy
echo -e "\n Stripping modules"
for MOD in $(find "${OUTDIR}" -name '*.ko'); do
	"${STRIP}" --strip-unneeded --strip-debug "${MOD}" &>/dev/null
	"${SRCDIR}"/scripts/sign-file sha512 \
		"${OUTDIR}/signing_key.priv" \
		"${OUTDIR}/signing_key.x509" \
		"${MOD}"
	find "${OUTDIR}" -name '*.ko' -exec cp {} "${MODULEDIR}" \;
done

echo -e "\n Done moving modules"
