/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   31/05/2020
 * INFO     :   Class for AP web server to acquire config
 * ALL RIGHTS RESERVED.
 */

#include "SmartWebServer.h"

AsyncWebServer server(80);
bool SWS_DEBUG = false;

const char index_html[] PROGMEM = R"rawliteral(
<!DOCTYPE HTML><html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    html {
     font-family: Arial;
     display: inline-block;
     margin: 0px auto;
     text-align: center;
    }
    h2 { font-size: 3.0rem; }
    p { font-size: 3.0rem; }
    .units { font-size: 1.2rem; }
    .dht-labels{
      font-size: 1.5rem;
      vertical-align:middle;
      padding-bottom: 15px;
    }
  </style>
</head>
<body>
  <h2>SMART_v3 Configuration Portal</h2>
)rawliteral";

SmartWebServer::SmartWebServer(void){
  
}

void SmartWebServer::setDebug(bool d) {
  SWS_DEBUG = d;
}

void SmartWebServer::begin(String ssid, String pass) {
  WiFi.softAP(ssid,pass);
  while(WiFi.status() != WL_CONNECTED);
  if(SWS_DEBUG) {
    Serial.println(F("[+] SmartWebServer: INFO: Starting SmartWebServer in AP mode."));
    Serial.print(F("[+] SmartWebServer: IP"));
    Serial.println(WiFi.softAPIP());
  }
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html);
  });
  server.begin();
}
