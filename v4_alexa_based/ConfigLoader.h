#ifndef CONFIGLOADER_H
#define CONFIGLOADER_H

#include <Effortless_SPIFFS.h>
#include <EEPROM.h>

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
    struct configData {
      const char* ssid;
      const char* pass;
      const char* device_location;
      unsigned int timeout;
      const char* url_on;
      const char* url_off;
      bool fs_error_read;
      bool fs_error_write;
    };
    ConfigLoader(void);
    void getConfig(configData*);
    String getConfig(const char*);
    void setConfig(configData*);
    uint8_t getLastMotionState(void);
    void setLastMotionState(uint8_t);
    void addConfig(const char*, const char*);
    void addConfig(const char*, long);
    void setDebug(bool);
    void begin(void);
  private:
};

#endif