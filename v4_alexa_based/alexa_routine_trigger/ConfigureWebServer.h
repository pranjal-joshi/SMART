#ifndef CONFIGUREWEBSERVER_H
#define CONFIGUREWEBSERVER_H

#define WEBSERVER_H         // This avoids Redeclaration Error in ESPAsyncWebServer.h

#include <ESP8266mDNS.h>
#include <ESP8266HTTPUpdateServer.h>
#include <ESP8266WiFi.h>
#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include <ESP8266HTTPClient.h>
#include <AsyncElegantOTA.h>
// #include <ElegantOTA.h>
#include <ezLED.h>
#include "fauxmoESP.h"
#include "Timer.h"
#include "Webpages.h"

extern bool alexaSensingEnabled;
extern fauxmoESP alexaListener;
extern bool task_reset;
extern ezLED led;
extern Timer timer_ignore_sensor(MILLIS);

class ConfigureWebServer {
  public:
    ConfigureWebServer(void);
    void setDebug(bool);
    void begin(const char* ssid, const char* pass,  String hostname, bool async_scan, bool provision = true);
    void showWifiNetworks(void);
    void loop(void);
  private:
};

#endif