/*
 * SMART_2.0 NODE
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   02/06/2019
 * ALL RIGHTS RESERVED.
 */
 
#include<FS.h>
#include<Blynk.h>
#include<BlynkSimpleEsp8266.h>
#include<ArduinoJson.h>
#include<ESP8266WiFi.h>
#include<ESP8266WebServer.h>
#include<EEPROM.h>
#include<WiFiManager.h>
#include "config.h"

long lastAttemptToConnect = millis();
char authToken[32];
char deviceName[] = DEVICE_NAME;
BlynkTimer blynkTimer;
WiFiManagerParameter blynkAuthToken("auth","Enter Scanned Key Here..","",33);
WiFiManagerParameter blynkDeviceName("deviceName","Enter Device Name E.g: Bedroom","",32);

void setup() {
  Serial.begin(9600);
  bootDump();
  initWirelessAP();
  readJsonConfigFromFileSystem();
  initBlynk();
}


void loop() {
  if(WiFi.status() == WL_CONNECTED) {
    Blynk.run();
    blynkTimer.run();
  }
  else {
    if(millis() - lastAttemptToConnect > CON_TIMEOUT/8) {
      reboot();
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
  WiFiManager wifiMgr;
  #ifdef RST_WI_MGR
    Serial.println(F("[+] RST_WI_MGR is enabled through program. Resetting WiFi Config. EVERYTIME!! COMMENT THIS LATER"));
    wifiMgr.resetSettings();
  #endif
  wifiMgr.setDebugOutput(WI_MGR_DBG);
  wifiMgr.setMinimumSignalQuality(WI_SIG_QUALITY);
  wifiMgr.setTimeout(CON_TIMEOUT);
  wifiMgr.addParameter(&blynkAuthToken);
  wifiMgr.addParameter(&blynkDeviceName);
  wifiMgr.setSaveConfigCallback(saveWirelessAPConfigCallback);
  
  if(!wifiMgr.autoConnect(AP_SSID, AP_PASS)) {
    #ifdef DEBUG
      Serial.println(F("[+] Failed to connect WiFi & Timed out!"));
      delay(2000);
    #endif
    reboot();
  }
}

void saveWirelessAPConfigCallback() {
  #ifdef DEBUG
    Serial.println(F("[+] SAVE_WI_AP_CALLBACK_TRIGGER"));
  #endif
  strcpy(authToken, blynkAuthToken.getValue());  
  strcpy(deviceName, blynkDeviceName.getValue());
  saveJsonConfigToFileSystem(authToken, deviceName);
  reboot();
}

void saveJsonConfigToFileSystem(char authTokenLocal[], char deviceNameLocal[]) {
  if(SPIFFS.begin()) {
    #ifdef DEBUG
      Serial.println(F("[+] Mounting SPIFFS - saveJsonConfig"));
    #endif
    File configFile = SPIFFS.open(WI_CONFIG_FILE,"w");
      if(!configFile) {
        #ifdef DEBUG
          Serial.println(F("[+] Failed to open " WI_CONFIG_FILE));
        #endif
      }
      DynamicJsonBuffer jBuf;
      JsonObject& json = jBuf.createObject();
      json["auth"] = authTokenLocal;
      json["deviceName"] = deviceNameLocal;
      #ifdef DEBUG
        Serial.println(F("[+] Printing user generated JSON " WI_CONFIG_FILE));
        json.printTo(Serial);
        Serial.println();
      #endif
      json.printTo(configFile);
      configFile.close();
  }
  else {
    #ifdef DEBUG
      Serial.println(F("[+] Failed to mount SPIFFS!"));
    #endif
    reboot();
  }
}

void readJsonConfigFromFileSystem() {
  if(SPIFFS.begin()) {
    #ifdef RST_SPIFFS
      Serial.println(F("[+] RST_SPIFFS is enabled through program. Formatting SPIFFS EVERYTIME!! COMMENT THIS LATER!"));
      Serial.flush();
      SPIFFS.format();
    #endif
    #ifdef DEBUG
      Serial.println(F("[+] Mounting SPIFFS - readJsonConfig"));
    #endif
    if(SPIFFS.exists(WI_CONFIG_FILE)) {
      #ifdef DEBUG
        Serial.println(F("[+] Reading " WI_CONFIG_FILE));
      #endif 
      File configFile = SPIFFS.open(WI_CONFIG_FILE,"r");
      if(configFile) {
        size_t sz = configFile.size();
        std::unique_ptr<char[]> fileBuf(new char[sz]);
        configFile.readBytes(fileBuf.get(),sz);
        DynamicJsonBuffer jBuf;
        JsonObject& json = jBuf.parseObject(fileBuf.get());
        if(json.success()) {
          strcpy(authToken, json["auth"]);
          strcpy(deviceName, json["deviceName"]);
          String authTokenString(authToken);
          #ifdef DEBUG
            Serial.println(F("[+] Dumping parsed " WI_CONFIG_FILE " JSON Output:"));
            json.printTo(Serial);
            Serial.println(authTokenString.length());
          #endif
          if(authTokenString.length() < 32) {
            #ifdef DEBUG
              Serial.println(F("[+] Empty Auth Token detected.. Resetting WiFi Settings & formatting SPIFFS for survival.."));
            #endif
            WiFiManager wifiMgr;
            wifiMgr.resetSettings();
            SPIFFS.format();
            reboot();
          }
        }
        else {
          #ifdef DEBUG
            Serial.println(F("[+] Failed to load/parse " WI_CONFIG_FILE));
            Serial.println(F("[+] Formatting SPIFFS partition.. " WI_CONFIG_FILE));
          #endif
        }
        configFile.close();
      }
      else {
        #ifdef DEBUG
          Serial.println(F("[+] Failed to load " WI_CONFIG_FILE));
        #endif
      }
    } else {
      #ifdef DEBUG
        Serial.println(F("[+] Formatting SPIFFS partition.."));
        Serial.println(F("[+] " WI_CONFIG_FILE " not found! Creating.."));
      #endif
      SPIFFS.format();
      File configFile = SPIFFS.open(WI_CONFIG_FILE,"w");
      if(!configFile) {
        #ifdef DEBUG
          Serial.println(F("[+] Failed to open " WI_CONFIG_FILE));
        #endif
      }
      DynamicJsonBuffer jBuf;
      JsonObject& json = jBuf.createObject();
      json["auth"] = F("SAVE_BLYNK_AUTH_TOKEN_HERE");
      json["deviceName"] = F("DEVICE_NAME E.g. Bedroom");
      #ifdef DEBUG
        Serial.println(F("[+] Printing auto generated JSON " WI_CONFIG_FILE));
        json.printTo(Serial);
        Serial.println();
      #endif
      json.printTo(configFile);
      configFile.close();
    }
  }
  else {
    #ifdef DEBUG
      Serial.println(F("[+] Failed to mount SPIFFS!"));
    #endif
    reboot();
  }
}

void reboot() {
  #ifdef DEBUG
    Serial.println(F("[+] Reboot Requested. Rebooting system in 3 Seconds.."));
  #endif
  delay(3000);
  ESP.reset();
}

void initBlynk() {
  #ifdef DEBUG
    Serial.print(F("[+] Connecting to Blynk cloud with token: "));
    Serial.println(authToken);
    #define BLYNK_PRINT Serial
  #endif
  Blynk.config(authToken);
  while(!Blynk.connected()) {
    Blynk.connect();
  }
}

BLYNK_CONNECTED() {
  Blynk.syncAll();
  disableLedOnBlynkConnect();
}

