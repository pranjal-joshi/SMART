// Code to handle Configuration data on SPIFFS and EEPROM

#include "ConfigLoader.h"

bool FS_DEBUG = false;
// eSPIFFS fileSystem(&Serial);
eSPIFFS fileSystem;

ConfigLoader::ConfigLoader(void) {
}

void ConfigLoader::setDebug(bool val) {
  FS_DEBUG = val;
}

void ConfigLoader::begin(void) {
  EEPROM.begin(512);
  if(FS_DEBUG) {
    if (!fileSystem.checkFlashConfig()) {
      Serial.println("Flash size was not correct! Please check your SPIFFS config and try again");
      delay(100000);
      ESP.restart();
    }
  }
}

String ConfigLoader::getConfig(const char* filename) {
  String data;
  fileSystem.openFromFile(filename, data);
  return data;
}

void ConfigLoader::addConfig(const char* filepath, const char* data) {
  fileSystem.saveToFile(filepath, data);
  if(FS_DEBUG) {
    Serial.printf("[CONFIG] addConfig : %s\t\t->\t%s\n", filepath, data);
    Serial.flush();
  }
}

void ConfigLoader::addConfig(const char* filepath, long data) {
  fileSystem.saveToFile(filepath, data);
  if(FS_DEBUG) {
    Serial.printf("[CONFIG] addConfig : %s\t\t->\t%ld\n", filepath, data);
    Serial.flush();
  }
}

void ConfigLoader::erase(void) {
  if(FS_DEBUG) {
    Serial.println("[CONFIG] Clearing Config files...");
  }
  SPIFFS.begin();
  SPIFFS.remove(FILE_SSID);
  SPIFFS.remove(FILE_PASS);
  SPIFFS.remove(FILE_LOCATION);
  SPIFFS.remove(FILE_TIMEOUT);
  SPIFFS.remove(FILE_URL_ON);
  SPIFFS.remove(FILE_URL_OFF);
  SPIFFS.remove(FILE_SENSOR_STATE);
}


void ConfigLoader::setLastMotionState(uint8_t val) {
  EEPROM.write(EEPROM_ADDR, val);
  EEPROM.commit();
}

uint8_t ConfigLoader::getLastMotionState(void) {
  uint8_t state;
  state = EEPROM.read(EEPROM_ADDR);
  if(state > LOW) {
    state = HIGH;
  }
  return state;
}
