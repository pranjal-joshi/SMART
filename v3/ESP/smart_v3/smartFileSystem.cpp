/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   30/05/2020
 * INFO     :   Class for accessing SPIFFS for save/load JSON configs
 * ALL RIGHTS RESERVED.
 */

#include <FS.h>
#include "smartFilesystem.h"

#define DBG_FS String("[+] smartFileSystem: ")
#define CONF_FILE "/config.json"
#define JSON_BUF_SIZE 1024*2

bool DEBUG = false;

smartFileSystem::smartFileSystem(void) {
  SPIFFS.begin();
}

void smartFileSystem::setDebug(bool dbg) {
  DEBUG = dbg;
}

void smartFileSystem::printDebug(String c) {
  String p = String(c);
  Serial.println(DBG_FS+p);
}

void smartFileSystem::remove(const char *fn) {
  SPIFFS.remove(fn);
  if(DEBUG)
    printDebug("INFO: File Removed - " + String(fn));
}

void smartFileSystem::format(void) {
  if(DEBUG)
    printDebug("INFO: Formatting SPIFFS, Please wait!");
  SPIFFS.format();
  if(DEBUG)
    printDebug("INFO: SPIFFS formatted.");
}

smartFileSystemFlags_t smartFileSystem::saveJsonFile(const JsonDocument& jsonDoc, const char *fn) {
  if(SPIFFS.begin()) {
    char jsonChar[] = "";
    File f = SPIFFS.open(fn,"w");
    if(!f) {
      if(DEBUG)
         printDebug("ERROR: Failed to open file for writting.");
      return FileOpenError;
    }
    serializeJson(jsonDoc, f);
    f.close();
    if(DEBUG) {
      Serial.print(DBG_FS);
      Serial.print("INFO: Saved following data to file ");
      Serial.println(fn);
      Serial.print(DBG_FS);
      Serial.print("DATA: ");
      serializeJson(jsonDoc, Serial);
      Serial.println();
      Serial.flush();
    }
    return FileWriteOk;
  }
  else {
    if(DEBUG)
      printDebug("ERROR: Failed to mount SPIFFS.");
    return SPIFFSError;
  }
}

smartFileSystemFlags_t smartFileSystem::readJsonFile(JsonDocument *doc, const char* fn) {
  if(SPIFFS.begin()) {
    uint16_t i;
    char buf[JSON_BUF_SIZE];
    File f = SPIFFS.open(fn,"r");
    if(!f) {
      if(DEBUG)
         printDebug("ERROR: Failed to open file for reading.");
         return FileOpenError;
    }
    f.readBytes(buf,f.size());
    deserializeJson(*doc, buf);
    if(DEBUG) {
      Serial.print(DBG_FS);
      Serial.print("INFO: Read following data from file ");
      Serial.println(fn);
      Serial.print(DBG_FS);
      Serial.print("DATA: ");
      serializeJson(*doc, Serial);
      Serial.println();
      Serial.flush();
    }
    return FileReadOk;
  }
  else {
    if(DEBUG)
      printDebug("ERROR: Failed to mount SPIFFS.");
    return SPIFFSError;
  }
}

smartFileSystemFlags_t smartFileSystem::addConfig(char* key, String val) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  readJsonFile(&doc,CONF_FILE);
  serializeJson(doc,Serial);
  doc[String(key)] = val;
  serializeJson(doc,Serial);
  if(DEBUG) {
    Serial.print(DBG_FS);
    Serial.print("INFO: Adding following data to ");
    Serial.println(CONF_FILE);
    Serial.print(DBG_FS);
    Serial.print("DATA: ");
    Serial.println(val);
    Serial.flush();
  }
  return saveJsonFile(doc, CONF_FILE);
}

smartFileSystemFlags_t smartFileSystem::addConfig(char* key, double val) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  readJsonFile(&doc,CONF_FILE);
  doc[String(key)] = val;
  if(DEBUG) {
    Serial.print(DBG_FS);
    Serial.print("INFO: Adding following data to ");
    Serial.println(CONF_FILE);
    Serial.print(DBG_FS);
    Serial.print("DATA: ");
    Serial.println(val);
    Serial.flush();
  }
  return saveJsonFile(doc, CONF_FILE);
}

smartFileSystemFlags_t smartFileSystem::addConfig(char* key, int val) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  readJsonFile(&doc,CONF_FILE);
  doc[String(key)] = val;
  if(DEBUG) {
    Serial.print(DBG_FS);
    Serial.print("INFO: Adding following data to ");
    Serial.println(CONF_FILE);
    Serial.print(DBG_FS);
    Serial.print("DATA: ");
    Serial.println(val);
    Serial.flush();
  }
  return saveJsonFile(doc, CONF_FILE);
}

smartFileSystemFlags_t smartFileSystem::removeConfig(char* key) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  readJsonFile(&doc,CONF_FILE);
  doc.remove(key);
  if(DEBUG) {
    Serial.print(DBG_FS);
    Serial.print("INFO: Removing following data from ");
    Serial.println(CONF_FILE);
    Serial.print(DBG_FS);
    Serial.print("DATA: ");
    Serial.println(key);
    Serial.flush();
  }
  return saveJsonFile(doc, CONF_FILE);
}

DynamicJsonDocument smartFileSystem::readConfigFile(void) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  readJsonFile(&doc, CONF_FILE);
  return doc;
}
