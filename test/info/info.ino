/**
 * @file info.ino
 *
 * @author Pascal Gollor (http://www.pgollor.de/cms/)
 */

#include <ESP8266WiFi.h>

ADC_MODE(ADC_VCC);

void setup()
{
  Serial.begin(115200);
  
  delay(10);

  Serial.println("\r\n");
  
  Serial.print("Chip ID: ");
  Serial.print(ESP.getChipId());
  Serial.print("(0x");
  Serial.print(ESP.getChipId(), HEX);
  Serial.println(")");

  Serial.print("Flash ID: ");
  Serial.println(ESP.getFlashChipId());

  Serial.print("MAC: ");
  Serial.println(WiFi.macAddress());

  Serial.print("Flash Size: ");
  Serial.print(ESP.getFlashChipSize());
  Serial.print(" Byte - ");
  Serial.print(ESP.getFlashChipSize() / 1024 / 1024);
  Serial.println(" MByte");

  Serial.print("Flash Speed: ");
  Serial.print(ESP.getFlashChipSpeed() / 1000000);
  Serial.println(" MHz");
}


void loop()
{
  Serial.println(ESP.getVcc());

  delay(1000);
}
