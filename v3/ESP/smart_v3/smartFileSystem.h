/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   30/05/2020
 * INFO     :   Header for accessing SPIFFS for save/load JSON configs
 * ALL RIGHTS RESERVED.
 */

#ifndef SMARTFILESYSTEM_H
#define SMARTFILESYSTEM_H

#include <ArduinoJson.h>
#include "SmartConstants.h"

#define CONF_FILE "/config.json"
#define STATE_FILE "/state.json"

typedef enum SmartFileSystemFlags {
  FileWriteOk,
  FileReadOk,
  FileOpenError,
  SPIFFSError,
}SmartFileSystemFlags_t;

class SmartFileSystem {
  public:
    SmartFileSystem(void);
    void setDebug(bool);
    void format(void);
    void remove(const char *fn);
    SmartFileSystemFlags_t saveJsonFile(const JsonDocument&, const char*);
    SmartFileSystemFlags_t readJsonFile(JsonDocument *doc, const char* fn);
    SmartFileSystemFlags_t addConfig(char* key, String val);
    SmartFileSystemFlags_t addConfig(char* key, double val);
    SmartFileSystemFlags_t addConfig(char* key, int val);
    SmartFileSystemFlags_t removeConfig(char* key);
    StaticJsonDocument<JSON_BUF_SIZE> readConfigFile(void);
    bool isConfigEmpty(void);
    SmartFileSystemFlags_t saveState(const char* buf);
    DynamicJsonDocument loadState(void);
  private:
    bool DEBUG;
    void printDebug(String);
};

#endif
