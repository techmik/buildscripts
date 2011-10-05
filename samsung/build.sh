#!/bin/bash

# ARCH LINUX
if test -e /etc/arch-release ; then
	if which sudo >/dev/null; then
		sudo rm -f /usr/bin/python
		sudo ln -s /usr/bin/python2 /usr/bin/python
	fi
fi

START=$(date +%s)

DEVICE="$1"
ADDITIONAL="$2"

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
	galaxys2att)
                board=c1att
		lunch=cyanogen_galaxys2att-eng
		brunch=galaxys2att
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
		echo "Supported Devices: captivatemtd, epic, fascinate, galaxys2, galaxysmtd, galaxysbmtd, vibrantmtd"
		exit 2
		;;
esac


. build/envsetup.sh


case "$ADDITIONAL" in
	kernel)
		lunch ${lunch}
		cd samsung/kernel/${board}
		./build.sh "$DEVICE"
		cd ../../..
		brunch ${brunch}
		;;
	*)
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

# ARCH LINUX
if test -e /etc/arch-release ; then
	if which sudo >/dev/null; then
		sudo rm -f /usr/bin/python
		sudo ln -s /usr/bin/python3 /usr/bin/python
	fi
fi
