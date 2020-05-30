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

bool DEBUG = false;

smartFileSystem::smartFileSystem(void) {
  SPIFFS.begin();
}

void smartFileSystem::setDebug(bool dbg) {
  DEBUG = dbg;
}

void smartFileSystem::printDebug(const char *c) {
  String p = String(c);
  Serial.println(DBG_FS+p);
}

void smartFileSystem::format(void) {
  if(DEBUG)
    printDebug("INFO: Formatting SPIFFS, Please wait!");
  SPIFFS.format();
  if(DEBUG)
    printDebug("INFO: SPIFFS formatted.");
}

enum smartFileSystemFlags smartFileSystem::saveJsonFile(const JsonDocument& jsonDoc, const char *fn) {
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
      serializeJson(jsonDoc, Serial);;
    }
    return FileWriteOk;
  }
  else {
    if(DEBUG)
      printDebug("ERROR: Failed to mount SPIFFS.");
    return SPIFFSError;
  }
}

enum smartFileSystemFlags smartFileSystem::readJsonFile(JsonDocument *doc, const char* fn) {
  if(SPIFFS.begin()) {
    uint16_t i;
    char jsonChar[] = "";
    File f = SPIFFS.open(fn,"r");
    if(!f) {
      if(DEBUG)
         printDebug("ERROR: Failed to open file for reading.");
         return FileOpenError;
    }
    size_t sz = f.size();
    std::unique_ptr<char[]> fileBuf(new char[sz]);
    f.readBytes(fileBuf.get(),sz);
    deserializeJson(*doc, fileBuf.get());
    if(DEBUG) {
      Serial.print(DBG_FS);
      Serial.print("INFO: Read following data from file ");
      Serial.println(fn);
      Serial.print(DBG_FS);
      Serial.print("DATA: ");
      Serial.print(fileBuf.get());
    }
    return FileReadOk;
  }
  else {
    if(DEBUG)
      printDebug("ERROR: Failed to mount SPIFFS.");
    return SPIFFSError;
  }
}
