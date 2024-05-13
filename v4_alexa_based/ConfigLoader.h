#ifndef CONFIGLOADER_H
#define CONFIGLOADER_H

#include <Effortless_SPIFFS.h>
#include <EEPROM.h>
#include <FS.h>

#define FILE_SSID "/ssid.txt"
#define FILE_PASS "/pass.txt"
#define FILE_LOCATION "/loc.txt"
#define FILE_TIMEOUT "/timeout.txt"
#define FILE_URL_ON "/url_on.txt"
#define FILE_URL_OFF "/url_off.txt"

#define EEPROM_ADDR 10

#define btoa(x) ((x)?"true":"false")

class ConfigLoader {
  public:
    ConfigLoader(void);
    String getConfig(const char*);
    uint8_t getLastMotionState(void);
    void setLastMotionState(uint8_t);
    void addConfig(const char*, const char*);
    void addConfig(const char*, long);
    void setDebug(bool);
    void begin(void);
    void erase(void);
  private:
};

#endif