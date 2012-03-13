#!/bin/bash

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
DEVICE="$1"
ADDITIONAL="$2"
#Moved to arch-dependent case above
#THREADS=`cat /proc/cpuinfo | grep processor | wc -l`

# Device specific settings
case "$DEVICE" in
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
	galaxys2att)
		board=smdk4210
		lunch=cm_galaxys2att-userdebug
		brunch=cm_galaxys2att-userdebug
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
		echo -e "${txtred}Usage: $0 DEVICE ADDITIONAL"
		echo -e "Example: ./build.sh galaxys2"
		echo -e "Example: ./build.sh galaxys2 kernel"
		echo -e "Supported Devices: captivatemtd, epic, fascinate, galaxys2, galaxys2att, galaxynote, galaxysmtd, galaxysbmtd, maguro, vibrantmtd${txtrst}"
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
case "$ADDITIONAL" in
	kernel)
		echo -e "${txtgrn}Building Kernel...${txtrst}"
		cd kernel/samsung/${board}
		./build.sh "$DEVICE"
		cd ../../..
		echo -e "${txtgrn}Building Android...${txtrst}"
		brunch ${brunch}
		;;
	*)
		echo -e "${txtgrn}Building Android...${txtrst}"
		brunch ${brunch}
		;;
esac

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
