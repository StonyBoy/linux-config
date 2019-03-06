export PATH=$PATH:/opt/coverity/cov-analysis-linux64-2017.07-SP1/bin/

export PATH=$PATH:/opt/fsl-qoriq-glibc-x86_64-aarch64-toolchain-2.0/sysroots/x86_64-fslsdk-linux/usr/bin/aarch64-fsl-linux/

alias arm64make='make -j12 ARCH=arm64 CROSS_COMPILE=aarch64-fsl-linux- '
alias make-mipsel-uboot='make -j12 KBUILD_OUTPUT=./build ARCH=mipsel CROSS_COMPILE=/opt/mscc/mscc-brsdk-mips-2018.02-002/stage2/smb/x86_64-linux/bin/mipsel-linux-'


export ARMLMD_LICENSE_FILE=27003@bby1snlic05.pmc-sierra.bc.ca
