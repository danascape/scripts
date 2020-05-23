#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright (C) 2020 Saalim Quadri <saalimquadri1@gmail.com>
# Copyright (C) 2019 Shivam Kumar Jha <jha.shivam3@gmail.com>
#
# Build functions

# Store project path
PROJECT_DIR="$PWD"

# Create some folders
mkdir -p "$PROJECT_DIR/kernel/"

function dlzip() {
    echo "Downloading zip"
    mkdir "$PROJECT_DIR/input"
    cd ${PROJECT_DIR}/input
    aria2c -q -s 16 -x 16 ${URL} -d ${PROJECT_DIR}/input -o ${FILE} || { echo "Download failed!"; }
    URL=$PROJECT_DIR/input/${FILE}
    [[ -e ${URL} ]] && du -sh ${URL}
}
