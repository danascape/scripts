#!/usr/bin/env bash

# Copyright (C) 2020 Saalim Quadri (iamsaalim)
# SPDX-License-Identifier: GPL-3.0-or-later

# Store some VARS
PROJECT_DIR="$HOME/weeb/script2"
WORK_DIR="$PROJECT_DIR/working"

# Create some folders
mkdir -p "$PROJECT_DIR/working"

# Arguements check
if [ -z ${1} ] ; then
    echo -e "Usage: bash mirror.sh <direct-link>"
    exit 1
fi

# Download compressed kernel source
if [[ "$1" == *"http"* ]]; then
    echo "Downloading file"
    cd $WORK_DIR
    aria2c -q -s 16 -x 16 "$1" -d $WORK_DIR || { echo "Download failed!"; }
    URL=$WORK_DIR/${FILE}
    [[ -e ${URL} ]] && du -sh ${URL}
else
    URL=$( realpath "$1" )
    echo "Copying file"
    cp -a ${1} $WORK_DIR/
fi

# Push
cd $WORK_DIR
FILE=$(echo *)
rclone copy $FILE gdrive:
LINK=$(rclone link gdrive:$FILE)
echo $LINK

# Cleanup
rm -rf $WORK_DIR
