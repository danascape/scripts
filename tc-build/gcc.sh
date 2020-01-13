sudo apt-get install -y git gcc g++ gperf bison flex texinfo help2man make libncurses5-dev autoconf automake libtool libtool-bin gawk wget bzip2 xz-utils unzip patch python3 libstdc++6 subversion
cd
mkdir gcc-ct-ng
cd gcc-ct-ng
git clone https://github.com/CristianRo10/travis -b test
git clone https://github.com/crosstool-ng/crosstool-ng
cd crosstool-ng
./bootstrap
./configure
sudo make -j"$(($(nproc --all) + 1))"
sudo make install
cd ..
cd travis
cp defconfig64 defconfig
ct-ng defconfig
ct-ng build."$(($(nproc --all) + 1))"
rm defconfig
cp defconfig32 defconfig
ct-ng defconfig
ct-ng build."$(($(nproc --all) + 1))"
echo "Toolchains built in $HOME/x-tools"