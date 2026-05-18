set -x

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo vanilla ksun1 ksun3
    exit 1
fi



if echo $@ | grep vanilla ; then

rm -rf *
git reset --hard
git switch android16
git switch -c build-vanilla || exit 1
cp ../../hani-ci.sh .
bash ../../do_toolchain.sh
echo "-perf" > localversion

bash hani-ci.sh --build

if [ $? -eq 0 ] ; then
   cp 4.19*.zip ../../4.19-A16-valeryn-`date +"%d.%m.%y"`.zip
   rm -rf *
   git reset --hard
   git switch android16
   git branch -D build-vanilla
else
   echo FAILED
   exit 1
fi

fi



if echo $@ | grep ksun1 ; then

rm -rf *
git reset --hard
git switch android16
git fetch
git switch susfs-1.5.12
git pull --rebase
git switch android16
git switch -c build-ksun1 || exit 1

git cherry-pick 9ddea125151ce61abbd05a84e8de72f8fc45da57 || exit 1
git cherry-pick f0b967626c361d95969dd962cd22dffe1ebe510d || exit 1
git cherry-pick dbc26ce49d11c5d1293dedb5f647dcdacf4432dd
grep -v '<<<' arch/arm64/configs/vendor/bengal-perf_defconfig > arch/arm64/configs/vendor/bengal-perf_defconfig.1
mv arch/arm64/configs/vendor/bengal-perf_defconfig.1 arch/arm64/configs/vendor/bengal-perf_defconfig
grep -v '====' arch/arm64/configs/vendor/bengal-perf_defconfig > arch/arm64/configs/vendor/bengal-perf_defconfig.1
mv arch/arm64/configs/vendor/bengal-perf_defconfig.1 arch/arm64/configs/vendor/bengal-perf_defconfig
grep -v '>>>' arch/arm64/configs/vendor/bengal-perf_defconfig > arch/arm64/configs/vendor/bengal-perf_defconfig.1
mv arch/arm64/configs/vendor/bengal-perf_defconfig.1 arch/arm64/configs/vendor/bengal-perf_defconfig
git add arch/arm64/configs/vendor/bengal-perf_defconfig
git cherry-pick --continue --no-edit

tar xf ../KernelSU-Next-pershoot-october.tgz
cd KernelSU-Next/
#git reset --hard HEAD~1
#git pull --rebase
git reset --hard
git switch next-susfs
git tag next-susfs-1.5.12
cd ..
bash KernelSU-Next/kernel/setup.sh next-susfs-1.5.12
cd KernelSU-Next/
patch -p1  < ../../../susfs-1.1.1/pkg_observer.patch || exit 1
cd ..

cd arch/arm64/configs/vendor/
ln -s bengal-perf_defconfig chime_defconfig
cd -
cp arch/arm64/configs/vendor/bengal-perf_defconfig arch/arm64/configs/vendor/chime-stock_defconfig
grep -v _KSU arch/arm64/configs/vendor/chime-stock_defconfig > arch/arm64/configs/vendor/chime-stock_defconfig.1
mv arch/arm64/configs/vendor/chime-stock_defconfig.1 arch/arm64/configs/vendor/chime-stock_defconfig
echo 'CONFIG_KSU=y' >> arch/arm64/configs/vendor/chime_defconfig
echo 'CONFIG_KSU_SUSFS=y' >> arch/arm64/configs/vendor/chime_defconfig
echo 'CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT=y' >> arch/arm64/configs/vendor/chime_defconfig

bash ../../do_toolchain.sh
cp ../../hani-ci.sh .
echo "-perf" > localversion

bash hani-ci.sh --build

if [ $? -eq 0 ] ; then
   cp 4.19*.zip ../../4.19-A16-valeryn-ksun-1.1.1-`date +"%d.%m.%y"`.zip
   rm -rf *
   git reset --hard
   git switch android16
   git branch -D build-ksun1
else
   echo FAILED
   exit 1
fi

fi



if echo $@ | grep ksun3 ; then

rm -rf *
git reset --hard
git switch android16
git fetch
git switch susfs-2.1.0
git pull --rebase
git switch android16
git switch -c build-ksun3 || exit 1

#patch -p 1 < ../susfs-2.1.0/susfs_patch_to_4.19.patch
#patch -p 1 < ../susfs-2.1.0/susfs_fixed.patch

#bash ../susfs-2.1.0/backport_patches.sh
#bash ../susfs-2.1.0/susfs_inline_hook_patches.sh

git cherry-pick 84b385eb683c32beed15194b8c69611b3f35447f || exit 1
git cherry-pick 70865a757dfceb92fd0dc7d9074b432086c7b73f || exit 1
git cherry-pick 3f72527874b7007742e2dd24d5dc22891c031c3b || exit 1
git cherry-pick 5c6b9ed54ab6f3ffb820dfa27c037137e3eeae52 || exit 1
git cherry-pick 9beaa41861278b138f028253cdb0b4c5f80ee646
grep -v '<<<' arch/arm64/configs/vendor/bengal-perf_defconfig > arch/arm64/configs/vendor/bengal-perf_defconfig.1
mv arch/arm64/configs/vendor/bengal-perf_defconfig.1 arch/arm64/configs/vendor/bengal-perf_defconfig
grep -v '====' arch/arm64/configs/vendor/bengal-perf_defconfig > arch/arm64/configs/vendor/bengal-perf_defconfig.1
mv arch/arm64/configs/vendor/bengal-perf_defconfig.1 arch/arm64/configs/vendor/bengal-perf_defconfig
grep -v '>>>' arch/arm64/configs/vendor/bengal-perf_defconfig > arch/arm64/configs/vendor/bengal-perf_defconfig.1
mv arch/arm64/configs/vendor/bengal-perf_defconfig.1 arch/arm64/configs/vendor/bengal-perf_defconfig
git add arch/arm64/configs/vendor/bengal-perf_defconfig
git cherry-pick --continue --no-edit

tar xf ../KernelSU-Next.tgz
cd KernelSU-Next
git reset --hard
git switch legacy-susfs
git tag 3.2.0-legacy-susfs
cd ..
bash KernelSU-Next/kernel/setup.sh 3.2.0-legacy-susfs

cp arch/arm64/configs/vendor/bengal-perf_defconfig arch/arm64/configs/vendor/chime-stock_defconfig
grep -v _KSU arch/arm64/configs/vendor/chime-stock_defconfig > arch/arm64/configs/vendor/chime-stock_defconfig.1
mv arch/arm64/configs/vendor/chime-stock_defconfig.1 arch/arm64/configs/vendor/chime-stock_defconfig

echo "CONFIG_KSU=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "# CONFIG_KPROBES is not set" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_HAVE_SYSCALL_TRACEPOINTS=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_MANUAL_HOOK=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS_SUS_PATH=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS_SUS_MOUNT=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS_SUS_KSTAT=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS_SPOOF_UNAME=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS_ENABLE_LOG=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS_OPEN_REDIRECT=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
echo "CONFIG_KSU_SUSFS_SUS_MAP=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
if grep -q "THREAD_INFO_IN_TASK" "drivers/kernelsu/Kconfig"; then
  echo "CONFIG_THREAD_INFO_IN_TASK=y" >> arch/arm64/configs/vendor/bengal-perf_defconfig
fi
echo "CONFIG_KSU_SUSFS_TRY_UMOUNT=n" >> arch/arm64/configs/vendor/bengal-perf_defconfig

bash ../../do_toolchain.sh
cp ../../hani-ci.sh .
echo "-perf" > localversion

bash hani-ci.sh --build

if [ $? -eq 0 ] ; then
   cp 4.19*.zip ../../4.19-A16-valeryn-ksun-3.2.0-`date +"%d.%m.%y"`.zip
   rm -rf *
   git reset --hard
   git switch android16
   git branch -D build-ksun3
else
   echo FAILED
   exit 1
fi

fi
