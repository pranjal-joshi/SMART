
#include<BlynkSimpleEsp8266.h>
#include<ArduinoJson.h>
#include<ESP8266WiFi.h>
#include<ESP8266WebServer.h>
#include<EEPROM.h>
#include "config.h"

WiFiServer apServer(80);
long lastAttemptToConnect = millis();

void setup() {
  Serial.begin(9600);
  bootDump();
  initAPModeHw();
}

void loop() {
  if(WiFi.status() == WL_CONNECTED) {
    // run blynk here
  }
  else {
    if(millis() - lastAttemptToConnect > CON_TIMEOUT) {
      WiFi.begin(CLI_SSID, CLI_PASS);
      lastAttemptToConnect = millis();
    }
  }
}

void initAPModeHw() {
  #ifdef DEBUG
    Serial.println(F("[+] Init AP_MODE_SWITCH at pin: D3"));
  #endif
  pinMode(AP_MODE_SW, INPUT);
  digitalWrite(AP_MODE_SW, HIGH);
  delay(10);
  if(digitalRead(AP_MODE_SW)) {
    delay(2000);
    if(digitalRead(AP_MODE_SW)) {
      #ifdef DEBUG
        Serial.println(F("[+] AP_MODE_SW - Key pressed for 2 sec.."));
      #endif
      initWirelessAP();
    }
  }
}

void bootDump() {
  #ifdef DEBUG
    Serial.println(F("\n\n[+] SMART_2.0\n[+] Firmware version:\t" VERSION "\tBlynk version: " BLYNK_VERSION));
    Serial.println(F("[+] AuthToken:\t" AUTH));
  #endif
}

void disableLedOnBlynkConnect() {
  pinMode(16,OUTPUT);
  pinMode(2,OUTPUT);
  digitalWrite(16, HIGH);
  digitalWrite(2, HIGH);
}

void initWirelessAP() {
  WiFi.softAP(AP_SSID, AP_PASS);
  apServer.stop();
  apServer.begin();
  #ifdef DEBUG
    Serial.println(F("[+] Started WiFi AP & Webserver at: "));
    Serial.println(F("[+] AP_SSID:\t" AP_SSID));
    Serial.println(F("[+] AP_PASS:\t" AP_PASS));
    Serial.print(F("[+] AP_IP:\t"));
    Serial.println(WiFi.softAPIP());
  #endif
}

void reboot() {
  ESP.restart();
}

BLYNK_CONNECTED() {
  Blynk.syncAll();
  disableLedOnBlynkConnect();
}

