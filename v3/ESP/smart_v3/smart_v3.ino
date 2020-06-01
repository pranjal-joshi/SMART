/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   29/05/2020
 * ALL RIGHTS RESERVED.
 */

#include "SmartFileSystem.h"
#include "SmartWebServer.h"
#include "SmartConstants.h"
//#include <WiFiManager.h>
#include <PubSubClient.h>
#include <WiFiClient.h>

bool mDebug = true;

SmartFileSystem fsys;
SmartFileSystemFlags_t flag;

SmartWebServer configServer;

void mqttCallback(char* topic, byte* payload, unsigned int length) {}     //write MQTT callback here
WiFiClient wiCli;
IPAddress mqttIpAddress;
PubSubClient mqtt(wiCli);

void setup() {
  Serial.begin(115200);
  Serial.println();
  fsys.setDebug(mDebug);
  if(fsys.isConfigEmpty()) {
    configServer.setDebug(mDebug);
    configServer.begin(getSmartSSID(),AP_PASS);
  }
  /*
  mesh.setDebugMsgTypes( ERROR | STARTUP | CONNECTION );
  
  initWifiManager();
  //mesh.init(MESH_SSID,MESH_PASS,MESH_PORT,WIFI_AP_STA,WiFi.channel());

  initMqttClient();
  */
}

unsigned long lastMsg=0,value=1; char msg[100];
void loop() {
  //mqtt.loop();
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

char * getSmartSSID() {
  char n[20] = "";
  String(String("SMART_")+String(ESP.getChipId(),HEX)).toCharArray(n,13);
  return n;
}

/*void initMqttClient() {
  mqtt.setServer(MQTT_SERVER_IP,String(MQTT_SERVER_PORT).toInt());
  mqtt.setCallback(mqttCallback);
  mqtt.connect(getSmartSSID());
  mqtt.publish("smart","[+] SMART: MQTT Client Ready!");
}*/
