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

enum smartFileSystemFlags {
  FileWriteOk,
  FileReadOk,
  FileOpenError,
  SPIFFSError
};

class smartFileSystem {
  public:
    smartFileSystem(void);
    void setDebug(bool);
    void format(void);
    enum smartFileSystemFlags saveJsonFile(const JsonDocument&, const char*);
    enum smartFileSystemFlags readJsonFile(JsonDocument *doc, const char* fn);
  private:
    bool DEBUG;
    void printDebug(const char*);
};

#endif
