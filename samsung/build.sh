#!/bin/bash

START=$(date +%s)
DEVICE="$1"
ADDITIONAL="$2"
THREADS=`cat /proc/cpuinfo | grep processor | wc -l`

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
		board=c1
		lunch=cm_galaxys2-userdebug
		brunch=cm_galaxys2-userdebug
		;;
	galaxys2att)
		board=c1att
		lunch=cm_galaxys2att-userdebug
		brunch=cm_galaxys2att-userdebug
		;;
	galaxynote)
		board=galaxynote
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
	*)
		echo "Usage: $0 DEVICE ADDITIONAL"
		echo "Example: ./build.sh galaxys2"
		echo "Example: ./build.sh galaxys2 kernel"
		echo "Supported Devices: captivatemtd, epic, fascinate, galaxys2, galaxys2att, galaxynote, galaxysmtd, galaxysbmtd"
		exit 2
		;;
esac

. build/envsetup.sh

case "$ADDITIONAL" in
	kernel)
		cd kernel/samsung/${board}
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
