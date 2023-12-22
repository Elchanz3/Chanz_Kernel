#!/usr/bin/env python3
import os
import subprocess
import platform
import signal
import glob
import time

# Variables
menu_version = "v1.0.1"
DIR = os.path.abspath(os.path.dirname(__file__))
OUT_DIR = os.path.join(DIR, 'out')
PARENT_DIR = os.path.abspath(os.path.join(DIR, os.pardir))

export_vars = {
    'PLATFORM_VERSION': 10,
    'ANDROID_MAJOR_VERSION': 'q',
    'BUILD_CROSS_COMPILE': '/home/chanz22/Downloads/gcc-linaro-6.5.0/gcc-linaro/bin/aarch64-linux-gnu-',
    'KERNEL_MAKE_ENV': 'LOCALVERSION=-PowerGaming_V1.0.7_Chanz22',
    'KERNEL_ZIP_VERSION': 'PowerGaming_V1.0.7'
}

# Colors
ON_BLUE = '\033[44m'
BRED = '\033[1;31m'
BBLUE = '\033[1;34m'
BGREEN = '\033[1;32m'
STD = '\033[0m'

def clear():
    os.system('clear' if os.name == 'posix' else 'cls')

def pause(action, message=''):
    input(f"{BRED}{message}{STD}Press {BBLUE}[Enter]{STD} key to {action}...")

def dependencies():
    print("Installing necessary dependencies. Please wait.")
    os.system("sudo apt-get update && sudo apt-get upgrade && sudo apt-get install git ccache automake lzop bison gperf build-essential zip curl zlib1g-dev libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng bc gcc-aarch64-linux-gnu clang -y")
    print("Dependencies installed successfully.")

def main_menu():
    while True:
        clear()
        print(f"{BRED}Chanz22-SDM845-KERNEL-BUILD menu {menu_version}{STD}")
        print(" 1. Build kernel")
        print(" 2. Clean")
        print(" 3. Make flashable zip")
        print(" 4. Install necessary dependencies")
        print(" 5. Exit")
        choice = input("Enter choice [ 1 - 5 ] ")
        if choice in ['1']:
            build_kernel()
        elif choice in ['2']:
            clean()
        elif choice in ['3']:
            anykernel3()
        elif choice in ['4']:
            dependencies()
        elif choice in ['5']:
            exit(0)
        else:
            pause('return to Main menu', 'E1: Invalid option, ')

def variant():
    findconfig = ""
    findconfig = [os.path.basename(e) for e in glob.glob("arch/arm64/configs/afaneh_*")]
    i = 1
    print("")
    print(f"{ON_BLUE}Variant Selection:{STD}")
    for e in findconfig:
        print(f" {i}. {e.split('_')[1]}")
        i += 1
    choice = int(input(f"Enter choice [ 1 - {i-1} ] "))
    if 0 < choice < i:
        v = findconfig[choice-1]
        VARIANT = v.split('_')[1]
        print(f"{VARIANT} selected")
        pause('continue')
    else:
        pause('return to Main menu', 'Error E1: Invalid option, ')
        main_menu()

def clean():
    print(f"{BBLUE}***** Cleaning in Progress... *****{STD}")
    os.system(f"make {export_vars['KERNEL_MAKE_ENV']} ARCH=arm64 CROSS_COMPILE={export_vars['BUILD_CROSS_COMPILE']} clean")
    os.system(f"make {export_vars['KERNEL_MAKE_ENV']} ARCH=arm64 CROSS_COMPILE={export_vars['BUILD_CROSS_COMPILE']} mrproper")
    if os.path.isdir(OUT_DIR):
        os.system(f"rm -rf {OUT_DIR}")
    print(f"{BGREEN}***** Cleaning Process Done... *****{STD}")
    pause('continue')

def build_kernel():
    variant()
    VARIANT = None  # Define VARIANT here to avoid the NameError
    print(f"{ON_BLUE}***** Compiling kernel, please wait... *****{STD}")
    if not os.path.isdir(OUT_DIR):
        os.mkdir(OUT_DIR)
    os.system(f"make -j$(nproc) -C $(pwd) O=$(pwd)/out {export_vars['KERNEL_MAKE_ENV']} ARCH=arm64 CROSS_COMPILE={export_vars['BUILD_CROSS_COMPILE']} afaneh_${VARIANT}_defconfig")
    
    DATE_START = int(time.time())
    
    os.system(f"make -j$(nproc) -C $(pwd) O=$(pwd)/out {export_vars['KERNEL_MAKE_ENV']} ARCH=arm64 CROSS_COMPILE={export_vars['BUILD_CROSS_COMPILE']} 2>&1 | tee ../{LOG_FILE}")

    if os.path.exists(f"{OUT_DIR}/arch/arm64/boot/Image.gz"):
        os.system(f"cp {OUT_DIR}/arch/arm64/boot/Image.gz {OUT_DIR}/Image.gz")
        if os.path.exists(f"{OUT_DIR}/arch/arm64/boot/Image.gz-dtb"):
            os.system(f"cp {OUT_DIR}/arch/arm64/boot/Image.gz-dtb {OUT_DIR}/Image.gz-dtb")
            
            DATE_END = int(time.time())
            DIFF = DATE_END - DATE_START
            print(f"Time taken: {DIFF // 60} minute(s) and {DIFF % 60} seconds.")
            print(f"{BGREEN}***** Compilation Successful! *****{STD}")
            pause('continue')
        else:
            pause('return to Main menu', 'Kernel compilation error! E2: Check if there\'s an error, ')
    else:
        pause('return to Main menu', 'Kernel compilation error! E2: Check if there\'s an error, ')

def anykernel3():
    if not os.path.isdir(os.path.join(PARENT_DIR, 'AnyKernel3')):
        pause('clone AnyKernel3 - Flashable Zip Template')
        os.system(f"git clone https://github.com/Elchanz3/AnyKernel3 {os.path.join(PARENT_DIR, 'AnyKernel3')}")
    variant()
    if os.path.exists(f"{OUT_DIR}/arch/arm64/boot/Image.gz-dtb"):
        os.chdir(os.path.join(PARENT_DIR, 'AnyKernel3'))

        os.system(f"cp {OUT_DIR}/arch/arm64/boot/Image.gz-dtb zImage")
        os.system(f"sed -i 's/ExampleKernel by osm0sis/{VARIANT} kernel by chanz22/g' anykernel.sh")
        os.system(f"sed -i 's/=maguro/={VARIANT}/g' anykernel.sh")
        os.system(f"sed -i 's/=toroplus/=/g' anykernel.sh")
        os.system(f"sed -i 's/=toro/=/g' anykernel.sh")
        os.system(f"sed -i 's/=tuna/=/g' anykernel.sh")
        for line in ["backup_file", "replace_string", "insert_line", "append_file", "patch_fstab", "dump_boot", "write_boot"]:
            os.system(f"sed -i 's/{line}/#{line}/g' anykernel.sh")
        os.system(f"zip -r9 {os.path.join(PARENT_DIR, VARIANT + '_' + KERNEL_ZIP_VERSION + '.zip')} * -x .git README.md *placeholder")
        os.chdir(DIR)
        pause('continue')
    else:
        pause('return to Main menu', 'Build kernel first, ')

def exit_signal_handler(signum, frame):
    print("Exiting...")
    exit(0)
    
    pass

# Signal handlers
signal.signal(signal.SIGINT, exit_signal_handler)
signal.signal(signal.SIGQUIT, exit_signal_handler)
signal.signal(signal.SIGTSTP, exit_signal_handler)

# Show menu
if __name__ == "__main__":
    main_menu()

