/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   29/05/2020
 * ALL RIGHTS RESERVED.
 */

#include <painlessMesh.h>
#include <PubSubClient.h>
#include <WiFiClient.h>
#include "SmartMQTTClient.h"
#include "SmartFileSystem.h"
#include "SmartWebServer.h"
#include "SmartConstants.h"

bool mDebug = true;

SmartFileSystem fsys;
SmartFileSystemFlags_t flag;

SmartWebServer configServer;

SmartMQTTClient cli;

painlessMesh mesh;

void mqttCallback(char* topic, byte* payload, unsigned int length) {}     //write MQTT callback here
/*WiFiClient wiCli;
PubSubClient mqtt(wiCli);*/

DynamicJsonDocument confJson(JSON_BUF_SIZE);

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
      configServer.showWifiNetworks();
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> Blocking to obtain config.."));
    }
    if(fsys.isConfigEmpty()) {
      if(mDebug)
        Serial.println(F("[+] SMART: ERROR -> Config file appears empty even after saving.. Auto-Resetting"));
    }
    delay(RST_DLY);
    ESP.reset();
  }
  confJson = fsys.readConfigFile();

  // Temporarily connect to given WiFi to get channel
  // TODO - Modify code below to obtain target AP RSSI w/o connect
  Serial.print(F("[+] SMART: INFO -> TARGET SSID: "));
  Serial.println(confJson[CONF_SSID].as<const char*>());
  Serial.print(F("[+] SMART: INFO -> TARGET PASS: "));
  Serial.println(confJson[CONF_PASS].as<const char*>());
  unsigned int channel = getWiFiChannelForSSID((const char*)confJson[CONF_SSID]);
  /*
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
  */

  // Setup mesh network
  initMesh(channel);

  // Setup MQTT client
  cli.setDebug(mDebug);
  cli.begin((const char*)confJson[CONF_MQTT_IP],(int)confJson[CONF_MQTT_PORT],mqttCallback);
}

unsigned long lastMsg=0,value=1; char msg[100];
void loop() {
  //mqtt.loop();
  mesh.update();

  // Never disconnect from the MQTT broker
  /*while(!mqtt.connected()) {
    connectMqttClient();
  }*/
  
  /*unsigned long now = millis();
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

// Connect to MQTT
/*void connectMqttClient() {
  if(mDebug)
    Serial.println(F("[+] SMART: INFO -> Attempting to connect MQTT broker."));
  mqtt.setServer((const char*)confJson[CONF_MQTT_IP],(int)confJson[CONF_MQTT_PORT]);
  mqtt.setCallback(mqttCallback);
  unsigned long oldNow = millis();
  while(!mqtt.connected()) {
    mesh.update();
    if(millis() - oldNow > MQTT_DELAY) {
      oldNow = millis();
      if(mqtt.connect(getSmartSSID())) {
        if(mDebug) {
          Serial.println(F("[+] SMART: INFO -> MQTT broker connected."));
          Serial.print(F("[+] SMART: INFO -> MQTT IP: "));
          Serial.println(confJson[CONF_MQTT_IP].as<const char*>());
          Serial.print(F("[+] SMART: INFO -> MQTT PORT: "));
          Serial.println(confJson[CONF_MQTT_PORT].as<int>());
        }
        mqtt.publish("smart","[+] SMART: MQTT Client Ready!");
        // TODO - Subscribe here for required topics
      }
      else {
        if(mDebug) {
          Serial.print(F("[+] SMART: ERROR -> MQTT broker failed. Error Code -> "));
          Serial.println(mqtt.state());
        }
      }
    }
  }
}*/

// Get the channel of target SSID to be connected to
unsigned int getWiFiChannelForSSID(const char* ssid) {
  if(mDebug)
    Serial.printf("[+] SMART: INFO -> Identifying Channel of SSID: %s",ssid);
  WiFi.disconnect();
  WiFi.scanNetworks();
  int networks = WiFi.scanComplete();
  for(int i=0;i<networks;i++) {
    if(WiFi.SSID(i).c_str() == ssid){
      if(mDebug)
        Serial.printf("[+] SMART: INFO -> TARGET CHANNEL: -> %d",WiFi.channel(i));
      WiFi.scanDelete();
      return WiFi.channel(i);
    }
  }
  WiFi.scanDelete();
  return 0;
}
