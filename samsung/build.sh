#!/bin/bash

START=$(date +%s)

DEVICE="$1"
ADDITIONAL="$2"
THREADS=`cat /proc/cpuinfo | grep processor | wc -l`

case "$DEVICE" in
	clean)
		make clean
		rm -rf ./out 
		exit
		;;
	captivatemtd)
        board=aries
		lunch=teamhacksung_captivatemtd-eng
		brunch=captivatemtd
		;;
	fascinatemtd)
        board=aries
		lunch=teamhacksung_fascinatemtd-eng
		brunch=fascinatemtd
		;;
	galaxys2)
        board=c1
		lunch=teamhacksung_galaxys2-eng
		brunch=galaxys2
		;;
	galaxys2att)
        board=c1att
		lunch=teamhacksung_galaxys2att-eng
		brunch=galaxys2att
		;;
	galaxysmtd)
        board=aries
		lunch=teamhacksung_galaxysmtd-eng
		brunch=galaxysmtd
		;;
	*)
		echo "Usage: $0 DEVICE ADDITIONAL"
		echo "Example: ./build.sh galaxys2 (prebuilt kernel + android)"
		echo "Example: ./build.sh galaxys2 kernel (kernel + android)"
		echo "Supported Devices: captivatemtd, epic, fascinate, galaxys2, galaxys2att galaxysl, galaxysmtd"
		exit 2
		;;
esac


. build/envsetup.sh


case "$ADDITIONAL" in
	kernel)
		lunch ${lunch}
		cd kernel/samsung/${board}
		./build.sh "$DEVICE"
		cd ../../..
		lunch ${lunch}
        make -j$THREADS CC=gcc-4.4 CXX=g++-4.4
		;;
	*)
		lunch ${lunch}
        make -j$THREADS CC=gcc-4.4 CXX=g++-4.4
		;;
esac

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
