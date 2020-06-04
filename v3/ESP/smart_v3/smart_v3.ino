/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   29/05/2020
 * ALL RIGHTS RESERVED.
 */

#include <painlessMesh.h>
#include <ESP8266Ping.h>
#include <PubSubClient.h>
#include <WiFiClient.h>
#include <ArduinoOTA.h>
#include "SmartFileSystem.h"
#include "SmartWebServer.h"
#include "SmartConstants.h"

bool mDebug = true;

SmartFileSystem fsys;
SmartFileSystemFlags_t flag;
SmartWebServer configServer;

painlessMesh mesh;

WiFiClient wiCli;
PubSubClient mqtt(wiCli);

DynamicJsonDocument confJson(JSON_BUF_SIZE);
bool internetAvailable = false;
uint32_t rootNodeAddr;

void getRootId(void);
Scheduler sched;
Task rootCheckTask(5000, TASK_FOREVER, &getRootId, &sched);

void setup() {
  Serial.begin(115200);
  Serial.println("\n");

  if(mDebug) {
    Serial.print(F("[+] SMART: INFO -> CHIP ID = "));
    Serial.println(getSmartSSID());
  }

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
  if(mDebug) {
    Serial.print(F("[+] SMART: INFO -> TARGET SSID: "));
    Serial.println(confJson[CONF_SSID].as<const char*>());
    Serial.print(F("[+] SMART: INFO -> TARGET PASS: "));
    Serial.println(confJson[CONF_PASS].as<const char*>());
  }

  // Run a WiFi scan to acquire the channel info of target SSID so that same channel can be used for mesh.
  unsigned int channel = getWiFiChannelForSSID((const char*)confJson[CONF_SSID],(int)confJson[CONF_WIFI_CH]);

  // Setup mesh network
  initMesh(channel);

  sched.enableAll();
}

void loop() {
  // Never disconnect from the MQTT broker
  while(!mqtt.connected()) {
    connectMqttClient();
  }
  looper(); 
}

void looper() {
  mqtt.loop();
  mesh.update();
  sched.execute();
  if(mDebug)
    ArduinoOTA.handle();
}

const char * getSmartSSID() {
  char n[14];
  //snprintf(n, 14, "SMART_%08X", (uint32_t)ESP.getChipId());
  snprintf(n, 14, "SMART_%08X", mesh.getNodeId());
  return n;
}

void initMesh(uint8_t ch) {
  if(mDebug)
    mesh.setDebugMsgTypes( ERROR | STARTUP | CONNECTION );
  mesh.init(MESH_SSID, MESH_PASS, MESH_PORT, WIFI_AP_STA, ch, MESH_HIDDEN);
  #ifndef FORCE_MESH
    mesh.stationManual((const char*)confJson[CONF_SSID], (const char*)confJson[CONF_PASS]);
  #endif
  mesh.setHostname(getSmartSSID());
  mesh.onChangedConnections(&changedConCallback);
}

// setup arduino OTA only after device is connected to some network
void changedConCallback() {
  setupArduinoOTA();
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

void getRootId(void) {
  size_t i=0;
  SimpleList<uint32_t> nl = mesh.getNodeList();
  SimpleList<uint32_t>::iterator itr = nl.begin();
  if(mDebug)
    Serial.print(F("[+] SMART: MeshNode -> Running checkRoot Task..."));
  while(itr != nl.end()) {
    if(mDebug) {
      Serial.print(F("[+] SMART: MeshNode (Chip-ID) -> "));
      Serial.println(*itr,HEX);
    }
    itr++;
  }
}

void getRootId2(void) {
  auto layout = mesh.asNodeTree();
}

// Connect to MQTT
void connectMqttClient() {
  if(mDebug)
    Serial.println(F("[+] SMART: INFO -> Attempting to connect MQTT broker."));
  mqtt.setServer((const char*)confJson[CONF_MQTT_IP],(int)confJson[CONF_MQTT_PORT]);
  mqtt.setCallback(mqttCallback);
  unsigned long oldNow = millis();
  while(!mqtt.connected()) {
    looper();
    if(millis() - oldNow > MQTT_DELAY) {
      internetAvailable = isInternetAvailable();
      oldNow = millis();
      if(internetAvailable) {
        if(mqtt.connect(getSmartSSID())) {
          if(mDebug) {
            Serial.println(F("[+] SMART: INFO -> MQTT broker connected."));
            Serial.print(F("[+] SMART: INFO -> MQTT IP: "));
            Serial.println(confJson[CONF_MQTT_IP].as<const char*>());
            Serial.print(F("[+] SMART: INFO -> MQTT PORT: "));
            Serial.println(confJson[CONF_MQTT_PORT].as<int>());
            mqtt.publish(TOPIC_TEST,"[+] SMART: MQTT Client Ready!",RETAIN);
            mqtt.subscribe(TOPIC_TEST);
          }
          // TODO - Subscribe here for required topics
        }
        else {
          if(mDebug) {
            Serial.print(F("[+] SMART: ERROR -> MQTT broker failed. Error Code -> "));
            Serial.println(mqtt.state());
          }
        }
      }
      else {
        Serial.println(F("[+] SMART: INFO -> Internet not available (Mesh Only Mode Active)"));
      }
    }
  }
}

// Get the channel of target SSID to be connected to
unsigned int getWiFiChannelForSSID(const char* ssid, int confCh) {
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  if(mDebug)
    Serial.printf("[+] SMART: INFO -> Identifying Channel of SSID: %s\n",ssid);
  delay(100);
  int networks =  WiFi.scanNetworks();
  for(int i=0;i<networks;i++) {    
    if(String(WiFi.SSID(i)) == ssid){
      if(mDebug)
        Serial.printf("[+] SMART: INFO -> TARGET CHANNEL: -> %d",WiFi.channel(i));
      WiFi.scanDelete();
      return WiFi.channel(i);
    }
  }
  WiFi.scanDelete();
  if(mDebug)
    Serial.printf("[+] SMART: INFO -> TARGET CHANNEL FROM CONF: -> %d",confCh);
  return confCh;
}

bool isInternetAvailable(void) {
  #ifdef FORCE_MESH
    if(mDebug)
      Serial.println(F("[+] SMART: WARNING --> Node is in FORCE_MESH mode!"));
    return false;
  #endif
  return Ping.ping("www.google.co.in");
}

void setupArduinoOTA(void) {
  if(mDebug) {
    Serial.println(F("[+] SMART: INFO -> Starting ArduinoOTA service..."));
    ArduinoOTA.setHostname(getSmartSSID()) ;
    ArduinoOTA.begin();
  }
}

void mqttCallback(char* topic, byte* payload, unsigned int length) { //write MQTT callback here
  char p[length];
  for(uint16_t i=0;i<length;i++)
    p[i] = char(payload[i]);
    
  if(mDebug)
    Serial.printf("[+] SMART: MQTT Callback -> [%s] %s\n",topic,p);
}
