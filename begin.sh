
curl -o toolchain.tar.xz -L https://github.com/Joe7500/Builds/releases/download/Stuff/toolchain.tar.xz
#cp ../toolchain.tar.xz .

cd build
rm -rf kernel
git clone https://github.com/Joe7500/valeryn_xiaomi_sm6115 kernel
#cp -rf ~/hdd1/device-tree/kernels/valeryn/valeryn-new.1/ kernel
cd kernel || exit 1
git config user.email "user@localhost"
git config user.name "user"
rm -rf *
git reset --hard
git switch android16

bash ../../do_build_kernel.sh vanilla ksun1 ksun3

