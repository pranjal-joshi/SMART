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

typedef enum smartFileSystemFlags {
  FileWriteOk,
  FileReadOk,
  FileOpenError,
  SPIFFSError,
}smartFileSystemFlags_t;

class smartFileSystem {
  public:
    smartFileSystem(void);
    void setDebug(bool);
    void format(void);
    void remove(const char *fn);
    smartFileSystemFlags_t saveJsonFile(const JsonDocument&, const char*);
    smartFileSystemFlags_t readJsonFile(JsonDocument *doc, const char* fn);
    smartFileSystemFlags_t addConfig(char* key, String val);
    smartFileSystemFlags_t addConfig(char* key, double val);
    smartFileSystemFlags_t addConfig(char* key, int val);
    smartFileSystemFlags_t removeConfig(char* key);
    DynamicJsonDocument readConfigFile(void);
  private:
    bool DEBUG;
    void printDebug(String);
};

#endif
