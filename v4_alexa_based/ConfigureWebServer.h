#ifndef CONFIGUREWEBSERVER_H
#define CONFIGUREWEBSERVER_H

#define WEBSERVER_H         // This avoids Redeclaration Error in ESPAsyncWebServer.h

#include <ESP8266mDNS.h>
#include <ESP8266HTTPUpdateServer.h>
#include <ESP8266WiFi.h>
#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>

class ConfigureWebServer {
  public:
    ConfigureWebServer(void);
    void setDebug(bool);
    void begin(const char* ssid, const char* pass,  String hostname, bool async_scan);
    void showWifiNetworks(void);
    void loop(void);
  private:
};

#endif