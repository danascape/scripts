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
    START=$(date +"%s")
    aria2c -q -s 16 -x 16 "$1" -d $WORK_DIR || { echo "Download failed!"; rm -rf "$WORK_DIR/"; exit 1;}
    END=$(date +"%s")
    TIME="$(($END - $START))"
    echo "Download took "$TIME" seconds"
else
    echo "Input link is not valid."
    exit 1
fi

# Push
cd $WORK_DIR
FILE=$(echo *)
du -sh $FILE
rclone copy $FILE gdrive:
LINK=$(rclone link gdrive:$FILE)
echo mirrors.tesla59.workers.dev/$FILE

# Cleanup
rm -rf $WORK_DIR
