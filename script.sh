#!/bin/bash

function arduino_build()
{
	local aBuilderPath=$1
	local sketch=$2

	# create build dir
	mkdir -p "./build"

	# add builder to path
	PATH=$aBuilderPath:$PATH

	echo -e "\n arduino-builder -verbose -build-path ./build/ -hardware ./hardware/ -hardware ./esp8266/hardware/ -tools ./tools/ -tools ./esp8266/tools/ -tools ./esp8266/hardware/esp8266/1.6.5-1106-g8253b82/tools/ -libraries ./esp8266/hardware/esp8266/1.6.5-1106-g8253b82/libraries/ -fqbn esp8266:1.6.5-1106-g8253b82:generic -prefs=build.flash_ld=eagle.flash.512k.ld -prefs=build.flash_size=512K -prefs=build.flash_mode=dio -prefs=build.flash_freq=40 $sketch \n"

	arduino-builder -verbose -build-path ./build/ -hardware ./hardware/ -hardware ./esp8266/hardware/ -tools ./tools/ -tools ./esp8266/tools/ -tools ./esp8266/hardware/esp8266/1.6.5-1106-g8253b82/tools/ -libraries ./esp8266/hardware/esp8266/1.6.5-1106-g8253b82/libraries/ -fqbn esp8266:1.6.5-1106-g8253b82:generic -prefs=build.flash_ld=eagle.flash.512k.ld -prefs=build.flash_size=512K -prefs=build.flash_mode=dio -prefs=build.flash_freq=40 $sketch
}

function get_source()
{
	# download aduino builder first
	wget -q -O - "http://downloads.arduino.cc/tools/arduino-builder-linux64-1.0.0-beta8.tar.bz2" | tar xjf -

	# versions
	local espVersion="1.6.5-1106-g8253b82"
	local esptoolVersion="0.4.6"
	local mkspiffsVersion="0.1.1"
	local xtensaVersion="1.20.0-26-gb404fb9-2"

	# sources
	local hardware="http://arduino.esp8266.com/versions/"$espVersion"/esp8266-"$espVersion".zip"
	local esptool="https://github.com/igrr/esptool-ck/releases/download/"$esptoolVersion"/esptool-"$esptoolVersion"-linux64.tar.gz"
	local mkspiffs="https://github.com/igrr/mkspiffs/releases/download/"$mkspiffsVersion"/mkspiffs-"$mkspiffsVersion"-linux64.tar.gz"
	local xtensa="http://arduino.esp8266.com/linux64-xtensa-lx106-elf-gb404fb9.tar.gz"

	# create tmp soruce dir
	mkdir "./src"
	cd "./src"

	# get sources
	wget $mkspiffs
	wget $esptool
	wget $xtensa
	wget $hardware

	# unpack
	unzip "esp8266-1.6.5-1106-g8253b82.zip"
	tar xzf "esptool-0.4.6-linux64.tar.gz"
	tar xzf "mkspiffs-0.1.1-linux64.tar.gz"
	tar xzf "linux64-xtensa-lx106-elf-gb404fb9.tar.gz"
	cd "../"

	# create arduino dirs
	mkdir -p "./esp8266/hardware/esp8266/"
	mkdir -p "./esp8266/tools/esptool/"
	mkdir -p "./esp8266/tools/mkspiffs/"
	mkdir -p "./esp8266/tools/xtensa-lx106-elf-gcc/"

	# get source
	mv "./src/esp8266-"$espVersion"/" "./esp8266/hardware/esp8266/"$espVersion
	mv "./src/esptool-"$esptoolVersion"-linux64/" "./esp8266/tools/esptool/"$esptoolVersion
	mv "./src/mkspiffs-"$mkspiffsVersion"-linux64/" "./esp8266/tools/mkspiffs/"$mkspiffsVersion
	mv "./src/xtensa-lx106-elf/" "./esp8266/tools/xtensa-lx106-elf-gcc/"$xtensaVersion

	rm -R "./src/"
}
