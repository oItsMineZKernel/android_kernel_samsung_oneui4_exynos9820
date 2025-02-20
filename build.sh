#!/bin/bash

abort()
{
    cd -
    echo "-----------------------------------------------"
    echo "Kernel compilation failed! Exiting..."
    echo "-----------------------------------------------"
    exit -1
}

unset_flags()
{
    cat << EOF
Usage: $(basename "$0") [options]
Options:
    -m, --model [value]    Specify the model code of the phone
    -k, --ksu [y/N]        Include KernelSU Next with SuSFS
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --model|-m)
            MODEL="$2"
            shift 2
            ;;
        --ksu|-k)
            KSU_OPTION="$2"
            shift 2
            ;;
        *)\
            unset_flags
            exit 1
            ;;
    esac
done

export BUILD_CROSS_COMPILE=$(pwd)/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-androidkernel-
export BUILD_JOB_NUMBER=`grep -c ^processor /proc/cpuinfo`
RDIR=$(pwd)

# Define specific variables
KERNEL_DEFCONFIG=oitsminez-"$MODEL"_defconfig
case $MODEL in
beyond0lte)
    SOC=9820
    BOARD=SRPRI28A014KU
;;
beyond0lteks)
    SOC=9820
    BOARD=SRPRI28C007KU
;;
beyond1lte)
    SOC=9820
    BOARD=SRPRI28B014KU
;;
beyond1lteks)
    SOC=9820
    BOARD=SRPRI28D007KU
;;
beyond2lte)
    SOC=9820
    BOARD=SRPRI17C014KU
;;
beyond2lteks)
    SOC=9820
    BOARD=SRPRI28E007KU
;;
beyondx)
    SOC=9820
    BOARD=SRPSC04B011KU
;;
beyondxks)
    SOC=9820
    BOARD=SRPRK21D006KU
;;
d1)
    SOC=9825
    BOARD=SRPSD26B007KU
;;
d1xks)
    SOC=9825
    BOARD=SRPSD23A002KU
;;
d2s)
    SOC=9825
    BOARD=SRPSC14B007KU
;;
d2x)
    SOC=9825
    BOARD=SRPSC14C007KU
;;
d2xks)
    SOC=9825
    BOARD=SRPSD23C002KU
;;
*)
    unset_flags
    exit
esac

if [ -z $KSU_OPTION ]; then
    read -p "Include Include KernelSU Next with SuSFS (y/N): " KSU_OPTION
fi

if [[ "$KSU_OPTION" == "y" ]]; then
    KSU_NEXT=ksu_next.config
fi

FUNC_BUILD_KERNEL()
{
    # Build kernel image
    echo "-----------------------------------------------"
    echo "Defconfig: "$KERNEL_DEFCONFIG""
    if [ -z "$KSU_NEXT" ]; then
        echo "KSU_NEXT: N"
    else
        echo "KSU_NEXT: $KSU_NEXT"
    fi

    if [[ "$SOC" == "9825" ]]; then
        N10=exynos9825.config
    fi

    echo "-----------------------------------------------"
    echo "Building kernel using "$KERNEL_DEFCONFIG""
    echo "Generating configuration file..."
    echo "-----------------------------------------------"
    make -j$BUILD_JOB_NUMBER ARCH=arm64 \
        CROSS_COMPILE=$BUILD_CROSS_COMPILE O=out \
        $KERNEL_DEFCONFIG oitsminez.config $KSU_NEXT $N10 || abort

    echo "Building kernel..."
    echo "-----------------------------------------------"
    make -j$BUILD_JOB_NUMBER ARCH=arm64 \
        CROSS_COMPILE=$BUILD_CROSS_COMPILE O=out || abort

    # Define constant variables
    KERNEL_PATH=build/out/$MODEL/Image
    KERNEL_OFFSET=0x00008000
    RAMDISK_OFFSET=0x01000000
    SECOND_OFFSET=0xf0000000
    TAGS_OFFSET=0x00000100
    BASE=0x10000000
    CMDLINE='androidboot.selinux=permissive androidboot.selinux=permissive loop.max_part=7'
    HASHTYPE=sha1
    HEADER_VERSION=1
    OS_PATCH_LEVEL=2022-03
    OS_VERSION=12.0.0
    PAGESIZE=2048
    RAMDISK=build/out/$MODEL/ramdisk.cpio.gz
    OUTPUT_FILE=build/out/$MODEL/boot.img

    ## Build auxiliary boot.img files
    # Copy kernel to build
    mkdir -p $RDIR/build/out/$MODEL
    cp out/arch/arm64/boot/Image build/out/$MODEL

    echo " Finished kernel build"
}

FUNC_BUILD_DTBO()
{

    # Build dtb
    if [[ "$SOC" == "9820" ]]; then
        echo "Building common exynos9820 Device Tree Blob Image..."
        echo "-----------------------------------------------"
        ./toolchain/mkdtimg cfg_create build/out/$MODEL/dtb.img build/dtconfigs/exynos9820.cfg -d out/arch/arm64/boot/dts/exynos
    fi

    if [[ "$SOC" == "9825" ]]; then
        echo "Building common exynos9825 Device Tree Blob Image..."
        echo "-----------------------------------------------"
        ./toolchain/mkdtimg cfg_create build/out/$MODEL/dtb.img build/dtconfigs/exynos9825.cfg -d out/arch/arm64/boot/dts/exynos
    fi
    echo "-----------------------------------------------"

    # Build dtbo
    echo "Building Device Tree Blob Output Image for "$MODEL"..."
    echo "-----------------------------------------------"
    ./toolchain/mkdtimg cfg_create build/out/$MODEL/dtbo.img build/dtconfigs/$MODEL.cfg -d out/arch/arm64/boot/dts/samsung
    echo "-----------------------------------------------"
    }

FUNC_BUILD_RAMDISK()
{

    # Build ramdisk
    echo "Building Ramdisk..."
    echo "-----------------------------------------------"

    rm -rf $RDIR/build/ramdisk/fstab.exynos9820
    rm -rf $RDIR/build/ramdisk/fstab.exynos9825

    cp $RDIR/build/fstab.exynos$SOC $RDIR/build/ramdisk/

    pushd build/ramdisk > /dev/null
    find . ! -name . | LC_ALL=C sort | cpio -o -H newc -R root:root | gzip > ../out/$MODEL/ramdisk.cpio.gz || abort
    popd > /dev/null
    echo "-----------------------------------------------"

    # Create boot image
    echo "Creating boot image..."
    echo "-----------------------------------------------"
    ./toolchain/mkbootimg --base $BASE --board $BOARD --cmdline "$CMDLINE" --hashtype $HASHTYPE \
    --header_version $HEADER_VERSION --kernel $KERNEL_PATH --kernel_offset $KERNEL_OFFSET \
    --os_patch_level $OS_PATCH_LEVEL --os_version $OS_VERSION --pagesize $PAGESIZE \
    --ramdisk $RAMDISK --ramdisk_offset $RAMDISK_OFFSET --second_offset $SECOND_OFFSET \
    --tags_offset $TAGS_OFFSET -o $OUTPUT_FILE || abort

    rm -rf $RDIR/build/out/$MODEL/ramdisk.cpio.gz
    rm -rf $RDIR/build/out/$MODEL/Image
}

FUNC_BUILD_ZIP()
{
    rm -rf $RDIR/build/out/$MODEL/zip
    mkdir -p $RDIR/build/export
    mkdir -p $RDIR/build/out/$MODEL/zip
    mkdir -p $RDIR/build/out/$MODEL/zip/META-INF/com/google/android

    # Build zip
    echo "Building zip..."
    echo "-----------------------------------------------"
    cp build/out/$MODEL/boot.img build/out/$MODEL/zip/boot.img
    cp build/out/$MODEL/dtb.img build/out/$MODEL/zip/dtb.img
    cp build/out/$MODEL/dtbo.img build/out/$MODEL/zip/dtbo.img
    cp build/update-binary build/out/$MODEL/zip/META-INF/com/google/android/
    cp build/updater-script build/out/$MODEL/zip/META-INF/com/google/android/

    if [ "$SOC" == "9825" ]; then
        version=$(grep -o 'CONFIG_LOCALVERSION="[^"]*"' arch/arm64/configs/exynos9825.config | cut -d '"' -f 2)
    else
        version=$(grep -o 'CONFIG_LOCALVERSION="[^"]*"' arch/arm64/configs/oitsminez.config | cut -d '"' -f 2)
    fi

    version=${version:1}
    pushd build/export > /dev/null
    DATE=`date +"%d-%m-%Y_%H-%M-%S"`    
    
    if [[ "$KSU_OPTION" == "y" ]]; then
        NAME="$version"-"$MODEL"-KSU-NEXT+SuSFS-"$DATE".zip
    else
        NAME="$version"-"$MODEL"-"$DATE".zip
    fi

    cd $RDIR/build/out/$MODEL/zip
    zip -r -qq ../"$NAME" .
    rm -rf $RDIR/build/out/$MODEL/zip
    mv $RDIR/build/out/$MODEL/"$NAME" $RDIR/build/export/"$NAME"
    cd $RDIR/build/export

    rm -rf $RDIR/build/ramdisk/fstab.exynos9820
    rm -rf $RDIR/build/ramdisk/fstab.exynos9825
}

# MAIN FUNCTION
rm -rf ./build.log
(
	START_TIME=`date +%s`

	echo "Preparing the build environment..."

	FUNC_BUILD_KERNEL
	FUNC_BUILD_DTBO
	FUNC_BUILD_RAMDISK
	FUNC_BUILD_ZIP

	END_TIME=`date +%s`

	let "ELAPSED_TIME=$END_TIME-$START_TIME"
	echo "Total compile time was $ELAPSED_TIME seconds"

) 2>&1	| tee -a ./build.log
