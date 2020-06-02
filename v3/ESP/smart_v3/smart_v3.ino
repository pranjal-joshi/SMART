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
PubSubClient mqtt(wiCli);

DynamicJsonDocument confJson(JSON_BUF_SIZE);
//StaticJsonDocument<JSON_BUF_SIZE> confJson;

void setup() {
  Serial.begin(115200);
  Serial.println();

  // Read config.json file to retrieve login creds
  fsys.setDebug(mDebug);
  if(fsys.isConfigEmpty()) {
    configServer.setDebug(mDebug);
    configServer.begin(getSmartSSID(),AP_PASS);
    while(fsys.isConfigEmpty()) {
      // Start SmartWebServer and stay here until config isn't provided!
      delay(2000);
      if(mDebug)
        Serial.println("[+] SMART: INFO -> Blocking to obtain config..");
    }
  }
  confJson = fsys.readConfigFile();

  // Temporarily connect to given WiFi to get channel
  // TODO - Modify code below to obtain target AP RSSI w/o connect
  Serial.print("[+] SMART: INFO -> SSID: ");
  Serial.println(confJson[CONF_SSID].as<const char*>());
  Serial.print("[+] SMART: INFO -> PASS: ");
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

  // Setup mesh network
  initMesh(ch);
}

unsigned long lastMsg=0,value=1; char msg[100];
void loop() {
  mqtt.loop();
  mesh.update();

  // Never disconnect from the MQTT broker
  while(!mqtt.connected()) {
    connectMqttClient();
  }
  
  unsigned long now = millis();
  if (now - lastMsg > 3000) {
    lastMsg = now;
    ++value;
    snprintf (msg, 100, "hello world #%ld", value);
    Serial.print("Publish message: ");
    Serial.println(msg);
    mqtt.publish("smart", msg);
  }
}

const char * getSmartSSID() {
  char n[14];
  snprintf(n, 14, "SMART_%08X", (uint32_t)ESP.getChipId());
  return n;
}

void initMesh(uint8_t ch) {
  mesh.setDebugMsgTypes( ERROR | STARTUP | CONNECTION );
  mesh.init(MESH_SSID,MESH_PASS,MESH_PORT,WIFI_AP_STA,ch);
  mesh.stationManual((const char*)confJson[CONF_SSID], (const char*)confJson[CONF_PASS]);
  mesh.setHostname(getSmartSSID());
}

// TODO - Implement this
void checkMesh() {
  if(!mesh.isRoot()) {
    mesh.setRoot(true);
    if(mDebug) {
      Serial.println("[+] SMART: INFO -> Making this node as ROOT. Hostname = ");
      Serial.println(getSmartSSID());
    }
  }
  mesh.setContainsRoot(true);
}

void connectMqttClient() {
  Serial.println("[+] SMART: INFO -> Attempting to connect MQTT broker.");
  mqtt.setServer((const char*)confJson[CONF_MQTT_IP],(int)confJson[CONF_MQTT_PORT]);
  mqtt.setCallback(mqttCallback);
  unsigned long oldNow = millis();
  while(!mqtt.connected()) {
    mesh.update();
    if(millis() - oldNow > MQTT_DELAY) {
      oldNow = millis();
      if(mqtt.connect(getSmartSSID())) {
        if(mDebug) {
          Serial.println("[+] SMART: INFO -> MQTT broker connected.");
          Serial.print("[+] SMART: INFO -> MQTT IP: ");
          Serial.println(confJson[CONF_MQTT_IP].as<const char*>());
          Serial.print("[+] SMART: INFO -> MQTT PORT: ");
          Serial.println(confJson[CONF_MQTT_PORT].as<int>());
        }
        mqtt.publish("smart","[+] SMART: MQTT Client Ready!");
      }
      else {
        if(mDebug) {
          Serial.print("[+] SMART: ERROR -> MQTT broker failed. Error Code -> ");
          Serial.println(mqtt.state());
        }
      }
    }
  }
}
