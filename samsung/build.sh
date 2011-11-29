#!/bin/bash

# ARCH LINUX
if [ -f /etc/arch-release ] ; then
	echo "ARCHLINUX detected."
	ARCHLINUX=true
	if which sudo >/dev/null; then
		sudo rm -f /usr/bin/python
		sudo ln -s /usr/bin/python2 /usr/bin/python
	fi
fi

START=$(date +%s)
DEVICE="$1"
ADDITIONAL="$2"
THREADS=`cat /proc/cpuinfo | grep processor | wc -l`

# otapackage as third argument
case "$3" in
	otapackage)
	otapackage=otapackage
	;;
esac

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
	galaxynote)
		board=galaxynote
		lunch=teamhacksung_galaxynote-eng
		brunch=galaxynote
		;;
	galaxysmtd)
		board=aries
		lunch=teamhacksung_galaxysmtd-eng
		brunch=galaxysmtd
		;;
	galaxysbmtd)
		board=aries
		lunch=teamhacksung_galaxysbmtd-eng
		brunch=galaxysbmtd
		;;
	*)
		echo "Usage: $0 DEVICE ADDITIONAL"
		echo "Example: ./build.sh galaxys2"
		echo "Example: ./build.sh galaxys2 otapackage"
		echo "Example: ./build.sh galaxys2 kernel"
		echo "Example: ./build.sh galaxys2 kernel otapackage"
		echo "Supported Devices: captivatemtd, epic, fascinate, galaxys2, galaxys2att, galaxynote, galaxysmtd, galaxysbmtd"
		exit 2
		;;
esac


. build/envsetup.sh
lunch ${lunch}

case "$ADDITIONAL" in
	kernel)
		cd kernel/samsung/${board}
		./build.sh "$DEVICE"
		cd ../../..
		lunch ${lunch}
		make -j$THREADS ${otapackage}
		;;
	otapackage)
		make -j$THREADS otapackage
		;;
	*)
		make -j$THREADS
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
if [ -f /etc/arch-release ] ; then
	echo "ARCHLINUX revert changes."
	if which sudo >/dev/null; then
		sudo rm -f /usr/bin/python
		sudo ln -s /usr/bin/python3 /usr/bin/python
	fi
fi
