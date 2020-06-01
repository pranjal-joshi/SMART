/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   29/05/2020
 * ALL RIGHTS RESERVED.
 */

#include <painlessMesh.h>
#include <PubSubClient.h>
#include <WiFiClient.h>
#include "SmartFileSystem.h"
#include "SmartWebServer.h"
#include "SmartConstants.h"

bool mDebug = true;

SmartFileSystem fsys;
SmartFileSystemFlags_t flag;

SmartWebServer configServer;

painlessMesh mesh;

void mqttCallback(char* topic, byte* payload, unsigned int length) {}     //write MQTT callback here
WiFiClient wiCli;
IPAddress mqttIpAddress;
PubSubClient mqtt(wiCli);

DynamicJsonDocument confJson(1024*2);

void setup() {
  Serial.begin(115200);
  Serial.println();
  
  fsys.setDebug(mDebug);
  if(fsys.isConfigEmpty()) {
    configServer.setDebug(mDebug);
    configServer.begin(getSmartSSID(),AP_PASS);
    while(fsys.isConfigEmpty()) {
      // Stay here until config isn't provided!
      delay(2000);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> Blocking to obtain config.."));
    }
  }
  else {
    confJson = fsys.readConfigFile();
  }
  Serial.print(F("[+] SMART: INFO -> SSID: "));
  //serializeJson(confJson[CONF_SSID], Serial);
  Serial.println(confJson[CONF_SSID].as<const char*>());
  Serial.print(F("[+] SMART: INFO -> PASS: "));
  //serializeJson(confJson[CONF_PASS], Serial);
  Serial.println(confJson[CONF_PASS].as<const char*>());
  WiFi.begin((const char*)confJson[CONF_SSID], (const char*)confJson[CONF_PASS]);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.print("Channel: ");
  Serial.println(WiFi.channel());
  unsigned int ch = WiFi.channel();
  WiFi.disconnect();
  
  mesh.setDebugMsgTypes( ERROR | STARTUP | CONNECTION );
  mesh.init(MESH_SSID,MESH_PASS,MESH_PORT,WIFI_AP_STA,ch);
  mesh.stationManual((const char*)confJson[CONF_SSID], (const char*)confJson[CONF_PASS]);
  mesh.setHostname(getSmartSSID());

  initMqttClient();
}

unsigned long lastMsg=0,value=1; char msg[100];
void loop() {
  mqtt.loop();
  mesh.update();
  /*
  unsigned long now = millis();
  if (now - lastMsg > 3000) {
    lastMsg = now;
    ++value;
    snprintf (msg, 100, "hello world #%ld", value);
    Serial.print("Publish message: ");
    Serial.println(msg);
    mqtt.publish("smart", msg);
  }*/
}

const char * getSmartSSID() {
  char n[14];
  snprintf(n, 14, "SMART_%08X", (uint32_t)ESP.getChipId());
  return n;
}

void initMqttClient() {
  mqtt.setServer(MQTT_SERVER_IP,String(MQTT_SERVER_PORT).toInt());
  mqtt.setCallback(mqttCallback);
  mqtt.connect(getSmartSSID());
  mqtt.publish("smart","[+] SMART: MQTT Client Ready!");
}
