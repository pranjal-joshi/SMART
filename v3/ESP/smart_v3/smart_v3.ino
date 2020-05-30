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
#include "smartFileSystem.h"
#include "smartConstants.h"

smartFileSystem fsys;
smartFileSystemFlags_t flag;

WiFiManagerParameter userName("username","Registered username..","",31);
WiFiManagerParameter nodeName("nodename","Device name or Room name","",32);
WiFiManagerParameter mqttIp("ip","IoT Server IP","",33);
WiFiManagerParameter mqttPort("port","IoT Server port","",34);

DynamicJsonDocument dj(1024);

void setup() {
  Serial.begin(115200);
  Serial.println();
  fsys.setDebug(true);
  initWifiManager();
}

void loop() {
  delay(10);
}

void initWifiManager() {
  WiFiManager mgr;
  mgr.setMinimumSignalQuality(MIN_SIG);
  mgr.setTimeout(CON_TIMEOUT);
  mgr.addParameter(&userName);
  mgr.addParameter(&nodeName);
  mgr.addParameter(&mqttIp);
  mgr.addParameter(&mqttPort);
  mgr.autoConnect(AP_SSID, AP_PASS);
  mgr.setSaveConfigCallback(wifiManagerCallback);
}

void wifiManagerCallback() {
  Serial.println("TRIGGEREEED");
  fsys.addConfig("username", userName.getValue());
  fsys.addConfig("nodename", nodeName.getValue());
  fsys.addConfig("mqtt_ip", mqttIp.getValue());
  fsys.addConfig("mqtt_port", mqttPort.getValue());
}
