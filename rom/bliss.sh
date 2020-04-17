#!/usr/bin/env bash
echo "Installing Build packages"

sudo apt update && sudo apt upgrade -y && sudo apt install ccache && sudo apt-get install git-core && git clone https://GitHub.com/akhilnarang/scripts && cd scripts && bash setup/android_build_env.sh -y 

# initailize repo
mkdir -p ~/bin && mkdir -p ~/bliss && curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && chmod a+x ~/bin/repo && cd ~/bliss 
repo init -u https://github.com/BlissRoms/platform_manifest.git -b q 
repo sync --no-tags --no-clone-bundle --force-sync 

# Cloning trees
git clone https://github.com/Aftab-111/device_xiaomi_violet.git -b ten device/xiaomi/violet 
git clone https://github.com/Panchajanya1999/msm-4.14.git -b Q kernel/xiaomi/sm6150 
git clone https://github.com/Aftab-111/vendor_xiaomi.git -b ten vendor/xiaomi 
git clone https://gitlab.com/PixelExperience/vendor_xiaomi_firmware vendor/xiaomi/firmware 
git clone https://gitlab.com/BlissRoms/vendor_gapps.git -b q vendor/gapps 
git clone https://github.com/Aftab-111/vendor_MiuiCamera.git -b master vendor/MiuiCamera 
sudo rm -rf vendor/xiaomi/firmware/beryllium vendor/xiaomi/firmware/dipper vendor/xiaomi/firmware/platina vendor/xiaomi/firmware/polaris 
sudo rm -rf hardware/qcom-caf/sm8150/audio hardware/qcom-caf/sm8150/media hardware/qcom-caf/sm8150/display 
git clone https://github.com/Aftab-111/hardware_qcom_display.git -b ten-sm8150 hardware/qcom-caf/sm8150/display 
git clone https://github.com/Aftab-111/hardware_qcom_audio.git -b ten-sm8150 hardware/qcom-caf/sm8150/audio 
git clone https://github.com/Aftab-111/hardware_qcom_media.git -b ten-sm8150 hardware/qcom-caf/sm8150/media 
git clone https://github.com/Panchajanya1999/azure-clang.git -b 8.0 prebuilts/clang/host/linux-x86/clang-11 

# Necessary Patches
cd ~/bliss/vendor/bliss 
git remote add azure https://github.com/Aftab-111/platform_vendor_bliss 
git fetch azure 
git cherry-pick 340024b675cac6d58d0fd2fcf3d7561ae3c922c8 
git cherry-pick e4aefcdb797f0b5989250eeb4aaf5e6dbea3d44f 
git cherry-pick a438e5175bf0d8e929294b6ae638452de398ceb9 
cd ~/bliss/frameworks/av 
git remote add anx https://github.com/DerpLab/platform_frameworks_av 
git fetch anx 
git cherry-pick 3499e5998df584654cbcc3788d5bf1cadb0b8d44 
git cherry-pick 2243cd649484932824cc6d7522a108530985e1d2 
cd ~/bliss 

# Confgure Ccache
ccache -M 100G 

# Start build
. build/envsetup.sh 
lunch bliss_violet-user 
make blissify 

# Upload
cd ~/bliss/out/target/product/violet 
rsync -e ssh Bliss*.zip aftab111@frs.sourceforge.net:/home/frs/project/officialrom/bliss/ 

