// Code to handle Configuration data on SPIFFS and EEPROM

#include "ConfigLoader.h"

bool FS_DEBUG = false;
eSPIFFS fileSystem(&Serial);

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

const char* ConfigLoader::getConfig(const char* filename) {
  String data;
  fileSystem.openFromFile(filename, data);
  return data.c_str();
}

void ConfigLoader::getConfig(ConfigLoader::configData* structLoaded) {
  // Load from SPIFFS
  char* data = "";
  fileSystem.openFromFile(FILE_SSID, structLoaded->ssid);
  fileSystem.openFromFile(FILE_PASS, structLoaded->pass);
  fileSystem.openFromFile(FILE_LOCATION, structLoaded->device_location);
  fileSystem.openFromFile(FILE_TIMEOUT, structLoaded->timeout);
  fileSystem.openFromFile(FILE_URL_ON, structLoaded->url_on);
  fileSystem.openFromFile(FILE_URL_OFF, structLoaded->url_off);
  // Validate data
  if (structLoaded->ssid == "" || structLoaded->pass == "" || structLoaded->device_location == "" || structLoaded->timeout < 1 || structLoaded->timeout > 60 || structLoaded->url_off == "" || structLoaded->url_on == "") {
    structLoaded->fs_error_read = true;
    // terminate strings with null-char to avoid printf crashing everywhere!
    structLoaded->ssid = "";
    structLoaded->pass = "";
    structLoaded->device_location = "SmartMotion";
    structLoaded->url_on = "";
    structLoaded->url_off = "";
    if(FS_DEBUG) {
      Serial.println("[CONFIG] Validation Error in getConfig!");
    }
  }
  // Debug print
  if(FS_DEBUG) {  
    Serial.printf("[CONFIG] Filename: %s\t\t->\t%s\n", FILE_PASS, structLoaded->pass);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t%s\n", FILE_LOCATION, structLoaded->device_location);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t%d\n", FILE_TIMEOUT, structLoaded->timeout);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t%s\n", FILE_URL_ON, structLoaded->url_on);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t%s\n", FILE_URL_OFF, structLoaded->url_off);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t%s\n", "fs_error_read", btoa(structLoaded->fs_error_read));
    Serial.printf("[CONFIG] Filename: %s\t\t->\t%s\n", "fs_error_write", btoa(structLoaded->fs_error_write));
  }
}

void ConfigLoader::setConfig(ConfigLoader::configData* structLoaded) {
  // Write to SPIFFS
  fileSystem.saveToFile(FILE_SSID, structLoaded->ssid);
  fileSystem.saveToFile(FILE_PASS, structLoaded->pass);
  fileSystem.saveToFile(FILE_LOCATION, structLoaded->device_location);
  fileSystem.saveToFile(FILE_TIMEOUT, structLoaded->timeout);
  fileSystem.saveToFile(FILE_URL_ON, structLoaded->url_on);
  fileSystem.saveToFile(FILE_URL_OFF, structLoaded->url_off);
}

void ConfigLoader::addConfig(const char* filepath, const char* data) {
  fileSystem.saveToFile(filepath, data);
  if(FS_DEBUG) {
    Serial.printf("[CONFIG] addConfig : %s\t\t->\t%s\n", filepath, data);
  }
}

void ConfigLoader::addConfig(const char* filepath, long data) {
  if(FS_DEBUG) {
    Serial.printf("[CONFIG] addConfig : %s\t\t->\t%l\n", filepath, data);
  }
  fileSystem.saveToFile(filepath, data);
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
