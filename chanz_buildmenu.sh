#!/bin/bash
# CHANZ-KERNEL-BUILD menu

# Variables
menu_version="v2.4.2"
DIR=`readlink -f .`
OUT_DIR=$DIR/out
PARENT_DIR=`readlink -f ${DIR}/..`

export PLATFORM_VERSION=10
export ANDROID_MAJOR_VERSION=q

# Download Linaro GCC toolchain if not downloaded yet
if [ ! -f "$HOME/tc/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu.tar.xz" ]; then
  echo "Downloading Linaro GCC toolchain..."
  wget -P "$HOME/tc" https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/aarch64-linux-gnu/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu.tar.xz
  echo "Linaro GCC toolchain downloaded."
fi

# Extract and rename Linaro GCC toolchain if not extracted yet
TC_DIR="$HOME/tc"
GCC_TOOLCHAIN_DIR="$TC_DIR/gcc-linaro-6.5.0/bin"
BUILD_CROSS_COMPILE="$GCC_TOOLCHAIN_DIR/aarch64-linux-gnu-"

if [ ! -d "$TC_DIR/gcc-linaro-6.5.0" ]; then
  echo "Extracting Linaro GCC toolchain..."
  mkdir -p "$TC_DIR"
  tar -xf "$HOME/tc/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu.tar.xz" -C "$TC_DIR"
  mv "$TC_DIR/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu" "$TC_DIR/gcc-linaro-6.5.0"
  echo "Linaro GCC toolchain extracted."
fi
CC_TOOLCHAIN_DIR="$TC_DIR/gcc-linaro-6.5.0/bin"
BUILD_CROSS_COMPILE="$GCC_TOOLCHAIN_DIR/aarch64-linux-gnu-"

if [ ! -d "$TC_DIR/gcc-linaro-6.5.0" ]; then
  echo "Extracting Linaro GCC toolchain..."
  mkdir -p "$TC_DIR"
  tar -xf $HOME/tc/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu.tar.xz -C "$TC_DIR"
  mv "$TC_DIR/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu" "$TC_DIR/gcc-linaro-6.5.0"
  echo "Linaro GCC toolchain extracted."
fi


# BUILD_CROSS_COMPILE=$HOME/gcc-linaro-6.5.0/bin/aarch64-linux-gnu-
KERNEL_MAKE_ENV="LOCALVERSION=-Ядро_Чанца-☭"
KERNEL_ZIP_VERSION=Sputnik_Kernel-☭
# DEFCONFIGS
D1=chanz_crownqltechn_open_defconfig
D2=chanz_star2qltechn_open_defconfig
D3=chanz_starqltechn_open_defconfig

# LOG FILE NAME
LOG_FILE=compilation-HFK.log

# Color
ON_BLUE=`echo -e "\033[44m"`	# On Blue
BRED=`echo -e "\033[1;31m"`	# Bold Red
BBLUE=`echo -e "\033[1;34m"`	# Bold Blue
BGREEN=`echo -e "\033[1;32m"`	# Bold Green
UNDER_LINE=`echo -e "\e[4m"`	# Text Under Line
STD=`echo -e "\033[0m"`		# Text Clear
 
# Functions
pause(){
  read -p "${BRED}$2${STD}Press ${BBLUE}[Enter]${STD} key to $1..." fackEnterKey
}

variant(){
  findconfig=""
  findconfig=($(ls arch/arm64/configs/chanz_* 2>/dev/null))
  declare -i i=1
  shift 2
  echo ""
  echo "${ON_BLUE}Variant Selection:${STD}"
  for e in "${findconfig[@]}"; do
    echo " $i. $(basename $e | cut -d'_' -f2)"
    i=i+1
  done
  local choice
  read -p "Enter choice [ 1 - $((i-1)) ] " choice
  i="$choice"
  if [[ $i -gt 0 && $i -le ${#findconfig[@]} ]]; then
    export v="${findconfig[$i-1]}"
    export VARIANT=$(basename $v | cut -d'_' -f2)
    echo ${VARIANT} selected
    pause 'continue'
  else
    pause 'return to Main menu' 'Error E1: Invalid option, '
    . $DIR/build_menu
  fi
}

clean(){
  echo "${BBLUE}***** Cleaning in Progress... *****${STD}"
  make $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE  clean 
  make $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE  mrproper
  [ -d "$OUT_DIR" ] && rm -rf $OUT_DIR
  echo "${BGREEN}***** Cleaning Process Done... *****${STD}"
  pause 'continue'
 }

build_kernel(){
  variant
  echo "${ON_BLUE}***** Compiling kernel just wait... *****${STD}"
  [ ! -d "$OUT_DIR" ] && mkdir $OUT_DIR
  make -j$(nproc) -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE chanz_${VARIANT}_defconfig
  
  DATE_START=$(date +"%s")
  
  make -j$(nproc) -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE 2>&1 |tee ../$LOG_FILE

  [ -e $OUT_DIR/arch/arm64/boot/Image.gz ] && cp $OUT_DIR/arch/arm64/boot/Image.gz $OUT_DIR/Image.gz
  if [ -e $OUT_DIR/arch/arm64/boot/Image.gz-dtb ]; then
    cp $OUT_DIR/arch/arm64/boot/Image.gz-dtb $OUT_DIR/Image.gz-dtb
    
    DATE_END=$(date +"%s")
    DIFF=$(($DATE_END - $DATE_START))

echo "Time wasted: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

    echo "${BGREEN}***** Ready to Roar! *****${STD}"
    pause 'continue'
  else
    pause 'return to Main menu' 'Kernel STUCK in BUILD! E2: check if theres an error, '
  fi
}

anykernel3(){
  if [ ! -d $PARENT_DIR/AnyKernel3 ]; then
    pause 'clone AnyKernel3 - Flashable Zip Template'
    git clone https://github.com/Elchanz3/AnyKernel3 $PARENT_DIR/AnyKernel3
  fi
  variant
  if [ -e $OUT_DIR/arch/arm64/boot/Image.gz-dtb ]; then
    cd $PARENT_DIR/AnyKernel3

    cp $OUT_DIR/arch/arm64/boot/Image.gz-dtb zImage
    sed -i "s/ExampleKernel by osm0sis/${VARIANT} kernel by chanz22/g" anykernel.sh
    sed -i "s/=maguro/=${VARIANT}/g" anykernel.sh
    sed -i "s/=toroplus/=/g" anykernel.sh
    sed -i "s/=toro/=/g" anykernel.sh
    sed -i "s/=tuna/=/g" anykernel.sh
    sed -i "s/backup_file/#backup_file/g" anykernel.sh
    sed -i "s/replace_string/#replace_string/g" anykernel.sh
    sed -i "s/insert_line/#insert_line/g" anykernel.sh
    sed -i "s/append_file/#append_file/g" anykernel.sh
    sed -i "s/patch_fstab/#patch_fstab/g" anykernel.sh
    sed -i "s/dump_boot/split_boot/g" anykernel.sh
    sed -i "s/write_boot/flash_boot/g" anykernel.sh
    zip -r9 $PARENT_DIR/${VARIANT}_${KERNEL_ZIP_VERSION}.zip * -x .git README.md *placeholder
    cd $DIR
    pause 'continue'
  else
    pause 'return to Main menu' 'Build kernel first, '
  fi
}

dependencies(){
echo "auto installing necessary dependencies please wait."

sudo apt-get update && sudo apt-get upgrade && sudo apt-get install git ccache automake lzop bison gperf build-essential zip curl zlib1g-dev libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng bc gcc-aarch64-linux-gnu clang -y

}

# Run once
toolchain

# Show menu
show_menus(){
  clear
  echo "${BRED}Chanz22-SDM845-KERNEL-BUILD menu $menu_version${STD} ☭"
  echo " 1. ${UNDER_LINE}B${STD}uild kernel ☭"
  echo " 2. ${UNDER_LINE}C${STD}lean ☭"
  echo " 3. Make ${UNDER_LINE}f${STD}lashable zip ☭"
  echo " 4. install necessary dependencies ☭"
  echo " 5. E${UNDER_LINE}x${STD}it ☭"
}

# Read input
read_options(){
  local choice
  read -p "Enter choice [ 1 - 5 ] " choice
  case $choice in
    1|b|B) build_kernel ;;
    2|c|C) clean ;;
    3|f|F) anykernel3 ;;
    4|d|D) dependencies ;;
    5|x|X) exit 0 ;;
    *) pause 'return to Main menu' 'E1: Invalid option, '
  esac
}

# Trap CTRL+C, CTRL+Z and quit singles
trap '' SIGINT SIGQUIT SIGTSTP
 
# Step # Main logic - infinite loop
while true
do
  show_menus
  read_options
done
