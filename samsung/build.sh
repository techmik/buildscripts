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

# Device specific settings
case "$DEVICE" in
	clean)
		make clean
		rm -rf ./out 
		exit
		;;
    prepare) 
        cd vendor/cyanogen 
        ./get-rommanager
        exit
        ;;
	captivatemtd)
        board=aries
		lunch=cyanogen_captivatemtd-eng
		brunch=captivatemtd
		;;
	epic)
        board=aries
		lunch=cyanogen_epic-eng
		brunch=epic		
        ;;
	epic4gtouch)
        board=c1spr
		lunch=cyanogen_epic4gtouch-eng
		brunch=epic4gtouch	
        ;;
	fascinate)
        board=aries
		lunch=cyanogen_fascinate-eng
		brunch=fascinate
        ;;
	galaxys2)
        board=c1
		lunch=cyanogen_galaxys2-eng
		brunch=galaxys2
		;;
	i9100g)
        board=t1
		lunch=cyanogen_i9100g-eng
		brunch=i9100g
		;;
	galaxys2att)
                board=c1att
		lunch=cyanogen_galaxys2att-eng
		brunch=galaxys2att
		;;
	galaxysl)
        board=latona
		lunch=cyanogen_galaxysl-eng
		brunch=galaxysl
		;;
	galaxysmtd)
        board=aries
		lunch=cyanogen_galaxysmtd-eng
		brunch=galaxysmtd
		;;
	galaxysbmtd)
        board=aries
		lunch=cyanogen_galaxysbmtd-eng
		brunch=galaxysbmtd
		;;
	vibrantmtd)
        board=aries
		lunch=cyanogen_vibrantmtd-eng
		brunch=vibrantmtd
		;;
	*)
		echo "Usage: $0 DEVICE ADDITIONAL"
		echo "Example: ./build.sh galaxys2 (prebuilt kernel + android)"
		echo "Example: ./build.sh galaxys2 kernel (kernel + android)"
		echo "Supported Devices: captivatemtd, epic, epic4gtouch, fascinate, galaxys2, galaxys2att galaxysl, galaxysmtd, galaxysbmtd, vibrantmtd"
		exit 2
		;;
esac

# Check for Prebuilts
		echo -e "${txtylw}Checking for Prebuilts...${txtrst}"
if [ ! -e vendor/cyanogen/proprietary/RomManager.apk ]; then
		echo -e "${txtred}Prebuilts not found, downloading now...${txtrst}"
		cd vendor/cyanogen
		./get-rommanager
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
