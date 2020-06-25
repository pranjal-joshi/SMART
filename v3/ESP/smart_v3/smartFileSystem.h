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

#define CONF_FILE             "/config.json"
#define STATE_FILE            "/state.json"
#define TIMER_FILE            "/timer.json"
#define LINK_SENSOR_1_FILE    "/link_sensor_1.json"
#define LINK_SENSOR_2_FILE    "/link_sensor_2.json"
#define LINK_SENSOR_3_FILE    "/link_sensor_3.json"
#define LINK_SENSOR_4_FILE    "/link_sensor_4.json"

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
    StaticJsonDocument<JSON_BUF_SIZE> loadState(void);
    SmartFileSystemFlags_t saveTimers(const char* buf);
    SmartTimerStruct loadTimers(void);
    SmartFileSystemFlags_t saveSensorLink(const char* buf, const char* fn);
    StaticJsonDocument<JSON_BUF_SIZE> loadSensorLink(const char* fn);
  private:
    bool DEBUG;
    void printDebug(String);
};

#endif
