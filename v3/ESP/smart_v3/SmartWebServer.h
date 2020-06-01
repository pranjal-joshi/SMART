/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   31/05/2020
 * INFO     :   Header for AP web server to acquire config
 * ALL RIGHTS RESERVED.
 */

#ifndef SMARTWEBSERVER_H
#define SMARTWEBSERVER_H

#include <ESP8266WiFi.h>
#include <Hash.h>
#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>

class SmartWebServer {
  public:
    SmartWebServer(void);
    void setDebug(bool);
    void begin(const char* ssid, const char* pass);
  private:
};

#endif
