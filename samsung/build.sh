#!/bin/bash

COMMAND="$1"

check_root() {
    if [ ! $( id -u ) -eq 0 ]; then
        echo "Please run this script as root."
        exit
    fi
}

install_sun_jdk()
{
    add-apt-repository "deb http://archive.canonical.com/ lucid partner"
    apt-get update
    apt-get install sun-java6-jdk
}

install_ubuntu_packages()
{
    case $arch in
    "1")
        # i686
        apt-get install git-core gnupg flex bison gperf build-essential \
        zip curl zlib1g-dev libc6-dev libncurses5-dev x11proto-core-dev \
        libx11-dev libreadline6-dev libgl1-mesa-dev tofrodos python-markdown \
        libxml2-utils xsltproc
        ;;
    "2")
        # x86_64
        apt-get install git-core gnupg flex bison gperf build-essential \
        zip curl zlib1g-dev libc6-dev lib32ncurses5-dev ia32-libs \
        x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev \
        libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown \
        libxml2-utils xsltproc
        ;;
    *)
        # no arch
        echo "No arch defined, aborting."
        exit
        ;;
    esac
}

install_arch_packages()
{
    case $arch in
    "1")
        # i686
        pacman -S openjdk6 perl git gnupg flex bison gperf zip unzip sdl wxgtk \
        squashfs-tools ncurses libpng zlib libusb libusb-compat readline
        ;;
    "2")
        # x86_64
        pacman -S openjdk6 perl git gnupg flex bison gperf zip unzip sdl wxgtk \
        squashfs-tools ncurses libpng zlib libusb libusb-compat readline gcc-multilib
        ;;
    *)
        # no arch
        echo "No arch defined, aborting."
        exit
        ;;
    esac
}

prepare_environment()
{
    echo "Which distribution are you running?"
    echo "1) Ubuntu 10.04"
    echo "2) Ubuntu 10.10"
    echo "3) Ubuntu 11.04"
    echo "4) Ubuntu 11.10"
    echo "5) Ubuntu 12.04"
    echo "6) Arch Linux"
    read -n1 distribution
    echo -e "\r\n"
    
    echo "Arch?"
    echo "1) i686"
    echo "2) x86_64"
    read -n1 arch
    echo -e "\r\n"

    case $distribution in
    "1")
        # Ubuntu 10.04
        echo "Installing packages for Ubuntu 10.04"
        install_sun_jdk
        install_ubuntu_packages
        ;;
    "2")
        # Ubuntu 10.10
        echo "Installing packages for Ubuntu 10.10"
        install_sun_jdk
        install_ubuntu_packages
        ln -s /usr/lib32/mesa/libGL.so.1 /usr/lib32/mesa/libGL.so
        ;;
    "3")
        # Ubuntu 11.04
        echo "Installing packages for Ubuntu 11.04"
        install_sun_jdk
        install_ubuntu_packages
        ;;
    "4")
        # Ubuntu 11.10
        echo "Installing packages for Ubuntu 11.10"
        install_sun_jdk
        install_ubuntu_packages
        apt-get install libx11-dev:i386
        ;;
    "5")
        # Ubuntu 12.04
        echo "Installing packages for Ubuntu 12.04"
        apt-get update
        apt-get install git-core gnupg flex bison gperf build-essential \
        zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
        libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-dev:i386 \
        g++-multilib mingw32 openjdk-6-jdk tofrodos python-markdown \
        libxml2-utils xsltproc zlib1g-dev:i386
        ;;
    
    "6")
        # Arch Linux
        echo "Installing packages for Arch Linux"
        install_arch_packages
        mv /usr/bin/python /usr/bin/python.bak
        ln -s /usr/bin/python2 /usr/bin/python
        ;;
        
    *)
        # No distribution
        echo "No distribution set. Aborting."
        exit
        ;;
    esac
    
    echo "Do you want us to get android sources for you? (y/n)"
    read -n1 sources
    echo -e "\r\n"

    case $sources in
    "Y" | "y")
        echo "Choose a branch:"
        echo "1) gingerbread"
        echo "2) ics"
        read -n1 branch
        echo -e "\r\n"

        case $branch in
            "1")
                # gingerbread
                branch="gingerbread"
                ;;
            "2")
                # ics
                branch="ics"
                ;;
            *)
                # no branch
                echo "No branch choosen. Aborting."
                exit
                ;;
        esac

        echo "Target Directory (~/android/system):"
        read working_directory

        if [ ! -n $working_directory ]; then 
            working_directory="~/android/system"
        fi

        echo "Installing to $working_directory"
        mkdir ~/bin
        export PATH=~/bin:$PATH
        curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
        chmod a+x ~/bin/repo        
        
        mkdir -p $working_directory
        cd $working_directory
        repo init -u git://github.com/CyanogenMod/android.git -b $branch
        repo sync
        echo "Sources synced to $working_directory"        
        exit
        ;;
    "N" | "n")
        # nothing to do
        exit
        ;;
    esac
}

# Common defines (Arch-dependent)
case `uname -s` in
	Darwin)
		txtrst='\033[0m'  # Color off
		txtred='\033[0;31m' # Red
		txtgrn='\033[0;32m' # Green
		txtylw='\033[0;33m' # Yellow
		txtblu='\033[0;34m' # Blue
		THREADS=`sysctl -an hw.logicalcpu`
		;;
	*)
		txtrst='\e[0m'  # Color off
		txtred='\e[0;31m' # Red
		txtgrn='\e[0;32m' # Green
		txtylw='\e[0;33m' # Yellow
		txtblu='\e[0;34m' # Blue
		THREADS=`cat /proc/cpuinfo | grep processor | wc -l`
		;;
esac

echo -e "${txtgrn}##########################################"
echo -e "${txtgrn}#                                        #"
echo -e "${txtgrn}#    TEAMHACKSUNG ANDROID BUILDSCRIPT    #"
echo -e "${txtgrn}# visit us @ http://www.teamhacksung.org #"
echo -e "${txtgrn}#                                        #"
echo -e "${txtgrn}##########################################"
echo -e "\r\n ${txtrst}"

# Starting Timer
START=$(date +%s)

# Device specific settings
case "$COMMAND" in
    prepare)
        check_root
        prepare_environment
        exit
        ;;
	clean)
		make clean
		rm -rf ./out/target/product
		exit
		;;
	captivatemtd)
		board=aries
		lunch=cm_captivatemtd-userdebug
		brunch=cm_captivatemtd-userdebug
	;;
	fascinatemtd)
		board=aries
		lunch=cm_fascinatemtd-userdebug
		brunch=cm_fascinatemtd-userdebug
		;;
	galaxys2)
		board=smdk4210
		lunch=cm_galaxys2-userdebug
		brunch=cm_galaxys2-userdebug
		;;
	i777)
		board=smdk4210
		lunch=cm_i777-userdebug
		brunch=cm_i777-userdebug
		;;
	i9100g)
		board=t1
		lunch=cm_i9100g-userdebug
		brunch=cm_i9100g-userdebug
		;;
	galaxysl)
		board=latona
		lunch=cm_galaxysl-userdebug
		brunch=cm_galaxysl-userdebug
		;;
	galaxynote)
		board=smdk4210
		lunch=cm_galaxynote-userdebug
		brunch=cm_galaxynote-userdebug
		;;
	galaxysmtd)
		board=aries
		lunch=cm_galaxysmtd-userdebug
		brunch=cm_galaxysmtd-userdebug
		;;
	galaxysbmtd)
		board=aries
		lunch=cm_galaxysbmtd-userdebug
		brunch=cm_galaxysbmtd-userdebug
		;;
	maguro)
		board=tuna
		lunch=cm_maguro-userdebug
		brunch=cm_maguro-userdebug
		;;
	vibrantmtd)
	    board=aries
	    lunch=cm_vibrantmtd-userdebug
	    brunch=cm_vibrantmtd-userdebug
	    ;;
	*)
		echo -e "${txtred}Usage: $0 DEVICE"
		echo -e "Example: ./build.sh galaxys2"
		echo -e "Supported Devices: captivatemtd, epic, fascinate, galaxys2, i777, galaxynote, galaxysmtd, galaxysbmtd, maguro, vibrantmtd${txtrst}"
		exit 2
		;;
esac

# Check for Prebuilts
		echo -e "${txtylw}Checking for Prebuilts...${txtrst}"
if [ ! -e vendor/cm/proprietary/RomManager.apk ] || [ ! -e vendor/cm/proprietary/Term.apk ] || [ ! -e vendor/cm/proprietary/lib/armeabi/libjackpal-androidterm3.so ]; then
		echo -e "${txtred}Prebuilts not found, downloading now...${txtrst}"
		cd vendor/cm
		./get-prebuilts
		cd ../..
else
		echo -e "${txtgrn}Prebuilts found.${txtrst}"
fi

# Setting up Build Environment
echo -e "${txtgrn}Setting up Build Environment...${txtrst}"
. build/envsetup.sh
lunch ${lunch}

# Start the Build
echo -e "${txtgrn}Building Android...${txtrst}"
brunch ${brunch}


END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
