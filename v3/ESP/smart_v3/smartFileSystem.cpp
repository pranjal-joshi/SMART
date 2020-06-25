/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   30/05/2020
 * INFO     :   Class for accessing SPIFFS for save/load JSON configs
 * ALL RIGHTS RESERVED.
 */

#include <FS.h>
#include "SmartFilesystem.h"

#define DBG_FS String("[+] SmartFileSystem: ")

bool DEBUG = false;

SmartFileSystem::SmartFileSystem(void) {
  SPIFFS.begin();
}

void SmartFileSystem::setDebug(bool dbg) {
  DEBUG = dbg;
}

void SmartFileSystem::printDebug(String c) {
  String p = String(c);
  Serial.println(DBG_FS+p);
}

void SmartFileSystem::remove(const char *fn) {
  SPIFFS.remove(fn);
  if(DEBUG)
    printDebug("INFO: File Removed - " + String(fn));
}

void SmartFileSystem::format(void) {
  if(DEBUG)
    printDebug("INFO: Formatting SPIFFS, Please wait!");
  SPIFFS.format();
  if(DEBUG)
    printDebug("INFO: SPIFFS formatted.");
}

SmartFileSystemFlags_t SmartFileSystem::saveJsonFile(const JsonDocument& jsonDoc, const char *fn) {
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
    }
    return FileWriteOk;
  }
  else {
    if(DEBUG)
      printDebug("ERROR: Failed to mount SPIFFS.");
    return SPIFFSError;
  }
}

SmartFileSystemFlags_t SmartFileSystem::readJsonFile(JsonDocument *doc, const char* fn) {
  if(SPIFFS.begin()) {
    uint16_t i;
    char buf[JSON_BUF_SIZE*4];
    File f = SPIFFS.open(fn,"r");
    if(!f) {
      if(DEBUG)
         printDebug("ERROR: Failed to open file for reading.");
         return FileOpenError;
    }
    f.readBytes(buf,f.size());
    f.close();
    deserializeJson(*doc, buf);
    if(DEBUG) {
      Serial.print(DBG_FS);
      Serial.print("INFO: Read following data from file ");
      Serial.println(fn);
      Serial.print(DBG_FS);
      Serial.print("DATA: ");
      serializeJson(*doc, Serial);
      Serial.println();
    }
    return FileReadOk;
  }
  else {
    if(DEBUG)
      printDebug("ERROR: Failed to mount SPIFFS.");
    return SPIFFSError;
  }
}

SmartFileSystemFlags_t SmartFileSystem::addConfig(char* key, String val) {
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
  }
  return saveJsonFile(doc, CONF_FILE);
}

SmartFileSystemFlags_t SmartFileSystem::addConfig(char* key, double val) {
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
  }
  return saveJsonFile(doc, CONF_FILE);
}

SmartFileSystemFlags_t SmartFileSystem::addConfig(char* key, int val) {
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
  }
  return saveJsonFile(doc, CONF_FILE);
}

SmartFileSystemFlags_t SmartFileSystem::removeConfig(char* key) {
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
  }
  return saveJsonFile(doc, CONF_FILE);
}

StaticJsonDocument<JSON_BUF_SIZE> SmartFileSystem::readConfigFile(void) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  readJsonFile(&doc, CONF_FILE);
  doc.shrinkToFit();
  return doc;
}

bool SmartFileSystem::isConfigEmpty(void) {
  DynamicJsonDocument cf(JSON_BUF_SIZE);
  SmartFileSystemFlags_t flag = readJsonFile(&cf, CONF_FILE);
  if(flag == FileOpenError || flag == SPIFFSError) {
    if(DEBUG) {
      printDebug("ERROR: Can't read the config file!");
    }
    return true;
  }
  if(cf[CONF_SSID] == "" || cf[CONF_PASS] == "" || cf[CONF_USERNAME] =="" ||
     cf[CONF_NODENAME] == "" || cf[CONF_MQTT_IP] == "" || cf[CONF_MQTT_PORT] == "") {
      if(DEBUG) {
        printDebug("INFO: Config file is Empty!");
      }
      return true;
     }
  if(DEBUG)
    printDebug("INFO: Config file is not Empty.");
  return false;
}

SmartFileSystemFlags_t SmartFileSystem::saveState(const char* buf) {
  DynamicJsonDocument d(JSON_BUF_SIZE);
  deserializeJson(d, buf);
  return saveJsonFile(d, STATE_FILE);
}

StaticJsonDocument<JSON_BUF_SIZE> SmartFileSystem::loadState(void) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  readJsonFile(&doc, STATE_FILE);
  doc.shrinkToFit();
  if(DEBUG) {
    Serial.print(F("[+] SmartFileSystem: INFO -> Loading output states from SPIFFS.. -> "));
    serializeJson(doc, Serial);
    Serial.println();
  }
  return doc;
}

SmartFileSystemFlags_t SmartFileSystem::saveTimers(const char* buf) {
  DynamicJsonDocument d(JSON_BUF_SIZE*4);
  deserializeJson(d, buf);
  return saveJsonFile(d, TIMER_FILE);
}

SmartTimerStruct SmartFileSystem::loadTimers(void) {
  DynamicJsonDocument doc(JSON_BUF_SIZE*4);
  readJsonFile(&doc, TIMER_FILE);
  doc.shrinkToFit();
  SmartTimerStruct timerStruct;
  if(doc.containsKey(JSON_TYPE) && String((const char*)doc[JSON_TYPE]) == JSON_TYPE_TIMER) {
    JsonObject data = doc["data"];
    
    JsonArray data_time = data["time"];
    
    JsonArray data_time_0_0 = data_time[0][0];
    timerStruct.onTimeD1[0] = data_time_0_0[0]; // 1
    timerStruct.onTimeD1[1] = data_time_0_0[1]; // 2
    timerStruct.onTimeD1[2] = data_time_0_0[2]; // 3
    
    JsonArray data_time_0_1 = data_time[0][1];
    timerStruct.offTimeD1[0] = data_time_0_1[0]; // 1
    timerStruct.offTimeD1[1] = data_time_0_1[1]; // 2
    timerStruct.offTimeD1[2] = data_time_0_1[2]; // 3
    
    JsonArray data_time_1_0 = data_time[1][0];
    timerStruct.onTimeD2[0] = data_time_1_0[0]; // 1
    timerStruct.onTimeD2[1] = data_time_1_0[1]; // 2
    timerStruct.onTimeD2[2] = data_time_1_0[2]; // 3
    
    JsonArray data_time_1_1 = data_time[1][1];
    timerStruct.offTimeD2[0] = data_time_1_1[0]; // 1
    timerStruct.offTimeD2[1] = data_time_1_1[1]; // 2
    timerStruct.offTimeD2[2] = data_time_1_1[2]; // 3
    
    JsonArray data_time_2_0 = data_time[2][0];
    timerStruct.onTimeD3[0] = data_time_2_0[0]; // 1
    timerStruct.onTimeD3[1] = data_time_2_0[1]; // 2
    timerStruct.onTimeD3[2] = data_time_2_0[2]; // 3
    
    JsonArray data_time_2_1 = data_time[2][1];
    timerStruct.offTimeD3[0] = data_time_2_1[0]; // 1
    timerStruct.offTimeD3[1] = data_time_2_1[1]; // 2
    timerStruct.offTimeD3[2] = data_time_2_1[2]; // 3
    
    JsonArray data_time_3_0 = data_time[3][0];
    timerStruct.onTimeD4[0] = data_time_3_0[0]; // 1
    timerStruct.onTimeD4[1] = data_time_3_0[1]; // 2
    timerStruct.onTimeD4[2] = data_time_3_0[2]; // 3
    
    JsonArray data_time_3_1 = data_time[3][1];
    timerStruct.offTimeD4[0] = data_time_3_1[0]; // 1
    timerStruct.offTimeD4[1] = data_time_3_1[1]; // 2
    timerStruct.offTimeD4[2] = data_time_3_1[2]; // 3
    
    JsonArray data_weekday = data["weekday"];

    JsonArray data_weekday_0 = data_weekday[0];
    timerStruct.weekdaysD1[0] = data_weekday_0[0]; // 0
    timerStruct.weekdaysD1[1] = data_weekday_0[1]; // 1
    timerStruct.weekdaysD1[2] = data_weekday_0[2]; // 2
    timerStruct.weekdaysD1[3] = data_weekday_0[3]; // 3
    timerStruct.weekdaysD1[4] = data_weekday_0[4]; // 4
    timerStruct.weekdaysD1[5] = data_weekday_0[5]; // 5
    timerStruct.weekdaysD1[6] = data_weekday_0[6]; // 6
    
    JsonArray data_weekday_1 = data_weekday[1];
    timerStruct.weekdaysD2[0] = data_weekday_1[0]; // 0
    timerStruct.weekdaysD2[1] = data_weekday_1[1]; // 1
    timerStruct.weekdaysD2[2] = data_weekday_1[2]; // 2
    timerStruct.weekdaysD2[3] = data_weekday_1[3]; // 3
    timerStruct.weekdaysD2[4] = data_weekday_1[4]; // 4
    timerStruct.weekdaysD2[5] = data_weekday_1[5]; // 5
    timerStruct.weekdaysD2[6] = data_weekday_1[6]; // 6
    
    JsonArray data_weekday_2 = data_weekday[2];
    timerStruct.weekdaysD3[0] = data_weekday_2[0]; // 0
    timerStruct.weekdaysD3[1] = data_weekday_2[1]; // 1
    timerStruct.weekdaysD3[2] = data_weekday_2[2]; // 2
    timerStruct.weekdaysD3[3] = data_weekday_2[3]; // 3
    timerStruct.weekdaysD3[4] = data_weekday_2[4]; // 4
    timerStruct.weekdaysD3[5] = data_weekday_2[5]; // 5
    timerStruct.weekdaysD3[6] = data_weekday_2[6]; // 6
    
    JsonArray data_weekday_3 = data_weekday[3];
    timerStruct.weekdaysD4[0] = data_weekday_0[0]; // 0
    timerStruct.weekdaysD4[1] = data_weekday_0[1]; // 1
    timerStruct.weekdaysD4[2] = data_weekday_0[2]; // 2
    timerStruct.weekdaysD4[3] = data_weekday_0[3]; // 3
    timerStruct.weekdaysD4[4] = data_weekday_0[4]; // 4
    timerStruct.weekdaysD4[5] = data_weekday_0[5]; // 5
    timerStruct.weekdaysD1[6] = data_weekday_0[6]; // 6
    
    JsonArray data_status = data["status"];
    timerStruct.statusD1 = data_status[0]; // "enable"
    timerStruct.statusD2 = data_status[1]; // "disable"
    timerStruct.statusD3 = data_status[2]; // "enable"
    timerStruct.statusD4 = data_status[3]; // "disable"

    if(DEBUG) {
      Serial.println(F("[+] SmartFileSystem: INFO -> loading timers..."));
      serializeJson(doc, Serial);
      Serial.println();
    }
      
  }
  return timerStruct;
}

SmartFileSystemFlags_t SmartFileSystem::saveSensorLink(const char* buf, const char* fn) {
  DynamicJsonDocument d(JSON_BUF_SIZE);
  deserializeJson(d, buf);
  d.shrinkToFit();
  return saveJsonFile(d, fn);
}

StaticJsonDocument<JSON_BUF_SIZE> SmartFileSystem::loadSensorLink(const char* fn) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  readJsonFile(&doc, fn);
  doc.shrinkToFit();
  return doc;
}
