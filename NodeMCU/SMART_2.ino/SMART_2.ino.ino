
#include<FS.h>
#include<BlynkSimpleEsp8266.h>
#include<ArduinoJson.h>
#include<ESP8266WiFi.h>
#include<ESP8266WebServer.h>
#include<EEPROM.h>
#include<WiFiManager.h>
#include "config.h"

long lastAttemptToConnect = millis();
bool SAVE_WI_AP_CALLBACK_FLAG = false;
char authToken[] = AUTH;

void setup() {
  Serial.begin(9600);
  bootDump();
  readWifiConfigFromFileSystem();
  initWirelessAP();
}

void loop() {
  if(WiFi.status() == WL_CONNECTED) {
    // run blynk here
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
  WiFiManagerParameter blynkAuthToken("auth","Enter Scanned Key Here..","",32);
  
  //wifiMgr.resetSettings();
  wifiMgr.setDebugOutput(WI_MGR_DBG);
  wifiMgr.setMinimumSignalQuality(WI_SIG_QUALITY);
  wifiMgr.setTimeout(CON_TIMEOUT);
  wifiMgr.addParameter(&blynkAuthToken);
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
  SAVE_WI_AP_CALLBACK_FLAG = true;
}

void readWifiConfigFromFileSystem() {
  if(SPIFFS.begin()) {
    #ifdef DEBUG
      Serial.println(F("[+] Mounting SPIFFS"));
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
        JsonObject& json = jBuf.parseObject(configFile);
        if(json.success()) {
          #ifdef DEBUG
            Serial.println(F("[+] Parsed " WI_CONFIG_FILE " JSON Output:"));
            json.printTo(Serial);
          #endif
          strcpy(authToken,json["auth"]);
        }
        else {
          #ifdef DEBUG
            Serial.println(F("[+] Failed to load/parse " WI_CONFIG_FILE));
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
        Serial.println(F("[+] " WI_CONFIG_FILE " not found! Creating.."));
      #endif
      File configFile = SPIFFS.open(WI_CONFIG_FILE,"w");
      if(!configFile) {
        #ifdef DEBUG
          Serial.println(F("[+] Failed to open " WI_CONFIG_FILE));
        #endif
      }
      DynamicJsonBuffer jBuf;
      JsonObject& json = jBuf.createObject();
      json["auth"] = "AUTO_GENERATED_AUTH_TOKEN";
      #ifdef DEBUG
        Serial.println(F("[+] Printing auto generated JSON " WI_CONFIG_FILE));
        json.printTo(Serial);
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
  ESP.restart();
}

BLYNK_CONNECTED() {
  Blynk.syncAll();
  disableLedOnBlynkConnect();
}

