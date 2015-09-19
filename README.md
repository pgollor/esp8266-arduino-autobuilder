## ESP8266 Arduino Autobuilder
[![Linux build status](https://travis-ci.org/pgollor/esp8266-arduino-autobuilder.svg)](https://travis-ci.org/pgollor/esp8266-arduino-autobuilder)

This repo contains some scripts which download the arduino-builder and some sources from Arduino ESP8266 to build a sketch without a GUI.
At this point the scripts are in pre aplha version.

## Usage
```
source script.sh
get_source
./test/test.sh
```
The compiled binary can be found in the `./build/` folder.


## TODO
- Add a script which use the current board managers json file from ESP Arduino to get download links.
- Finding a better solution for `boards.txt`: The arduino-builder can not chose the flash speed etc. from menu entries. So, at this point it is hard coded for one specific generic module.

## License and Credits
 Source | License
--------|--------
[Arduino builder](https://github.com/arduino/arduino-builder) | GPL
[Arduino IDE](https://github.com/arduino/Arduino) | GPL
[ESP8266 Arduino IDE](https://github.com/esp8266/Arduino) | GPL
[mkspiffs](https://github.com/igrr/mkspiffs) | Includes [SPIFFS](https://github.com/pellepl/spiffs) with MIT license
[esptool](https://github.com/igrr/esptool-ck) | @Christian Klippel GPLv2 - maintained by Ivan Grokhotkov
Espressif SDK | Espressif MIT License
ESP82GG core files | LGPL
