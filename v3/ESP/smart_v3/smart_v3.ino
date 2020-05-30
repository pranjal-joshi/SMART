/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   29/05/2020
 * ALL RIGHTS RESERVED.
 */

#include <ESP8266WiFi.h>         
#include <DNSServer.h>            
#include <ESP8266WebServer.h>
#include <WiFiManager.h>
#include <ArduinoOTA.h>
#include "smartFileSystem.h"
#include "smartConstants.h"

smartFileSystem fsys;
smartFileSystemFlags_t flag;

WiFiManagerParameter userName("username","Registered username..","",32);
WiFiManagerParameter nodeName("nodename","Device name or Room name","",32);
WiFiManagerParameter mqttServerIp("mqttip","IoT Server IP","",15);
WiFiManagerParameter mqttServerPort("mqttport","IoT Server port","",4);

DynamicJsonDocument dj(1024);

void setup() {
  Serial.begin(115200);
  Serial.println();
  ArduinoOTA.setHostname("SMART_v3");
  ArduinoOTA.begin();
  fsys.setDebug(true);
  initWifiManager();
}

void loop() {
  ArduinoOTA.handle();
}

char* getSSID() {
  char n[] = "";
  String(String("SMART_")+String(ESP.getChipId(),HEX)).toCharArray(n,12);
  return n;
}

void initWifiManager() {
  WiFiManager mgr;
  //// REMOVE LATER ////
  //mgr.resetSettings();
  //fsys.format();
  ////
  mgr.setSaveConfigCallback(saveWifiCallback);
  mgr.setMinimumSignalQuality(MIN_SIG);
  mgr.setTimeout(CON_TIMEOUT);
  mgr.addParameter(&userName);
  mgr.addParameter(&nodeName);
  mgr.addParameter(&mqttServerIp);
  mgr.addParameter(&mqttServerPort);
  if(!mgr.autoConnect(getSSID(), AP_PASS)) {
    if(mDebug)
      Serial.println("[+] INFO: Timeout occured while waiting for WiFi. Rebooting..");
    // TODO - switch to mesh mode if WiFi connection is not available
    ESP.reset();
  }
}

void saveWifiCallback() {
  fsys.addConfig("username", userName.getValue());
  fsys.addConfig("nodename", nodeName.getValue());
  fsys.addConfig("mqtt_ip", mqttServerIp.getValue());
  fsys.addConfig("mqtt_port", mqttServerPort.getValue());
  if(mDebug)
    Serial.println("[+] INFO: User parameters are stored on the file system.");
}
