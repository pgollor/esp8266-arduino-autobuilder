#!/bin/bash

function arduino_build()
{
	local aBuilderPath=$1
	local sketch=$2

	# create build dir
	mkdir -p "./build"

	# add builder to path
	PATH=$aBuilderPath:$PATH

	cmd="arduino-builder -verbose -build-path ./build/ -hardware ./hardware/ -hardware ./esp8266/hardware/ -tools ./tools/ -tools ./esp8266/tools/ -tools ./esp8266/hardware/esp8266/$ESP_VERSION/tools/ -libraries ./esp8266/hardware/esp8266/$ESP_VERSION/libraries/ -fqbn esp8266:$ESP_VERSION:generic -prefs=build.flash_ld=eagle.flash.512k.ld -prefs=build.flash_size=512K -prefs=build.flash_mode=dio -prefs=build.flash_freq=40 $sketch"

	echo -e "\n$cmd\n"

	# execute command
	eval $cmd
}

function get_source()
{
	# download aduino builder first
	wget -q -O - "http://downloads.arduino.cc/tools/arduino-builder-linux64-1.0.0-beta12.tar.bz2" | tar xjf -

	mkdir "./src/"

	# get source links and filenames
	cmd="python3 ./get_source.py -d -u http://arduino.esp8266.com/staging/package_esp8266com_index.json"

	# execute command
	res=`$cmd`

	echo "----- python script end -----"

	IFS=';'
	for i in $res;
	do
		cmd="$(echo -e "${i}" | tr -d '[[\n]]')"

		# execute command
		eval $cmd
	
		if [ $? -ne 0 ];
		then
			break
		fi
	done

	rm -R "./src/"
}

function del_source()
{
	# delete downloaded files
	rm "./arduino-builder"
	rm -R "./esp8266/"
	rm -R "./hardware/"
	rm -R "./tools/"
	rm -R "./build/"
}

