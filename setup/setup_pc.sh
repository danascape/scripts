#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri <danascape@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
#

# Set current path (preferred to clone the repo at HOME)
WORK_DIR="$HOME/scripts"

clear
# Display Message
echo "Artemis: Setting up common infra packages"
sleep 2

echo "Artemis: Cloning sworkflow"
git clone https://github.com/sworkflow-project/sworkflow $HOME/sworkflow >/dev/null 2>&1

# Install Required Packages (preferred Ubuntu 22)
echo "Artemis: Installing required packages"
bash $WORK_DIR/setup/build-env.sh

echo "Artemis: Installing akhilnarang common packages"
git clone --depth 1 -b master https://github.com/akhilnarang/scripts $WORK_DIR/akhil-scripts
bash $WORK_DIR/akhil-scripts/setup/android_build_env.sh
rm -rf $WORK_DIR/akhil-scripts