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

void getRootId(void);
Scheduler sched;
Task rootCheckTask(5000, TASK_FOREVER, &getRootId, &sched);

// variables
String smartSsid;
DynamicJsonDocument confJson(JSON_BUF_SIZE);
bool internetAvailable = false;
uint32_t rootNodeAddr;
byte stateArray[NO_OF_DEVICES];

void setup() {
  Serial.begin(115200);
  Serial.println("\n");

  if(mDebug)
    Serial.printf("[+] SMART: INFO -> CHIP ID = SMART_%08X\n",ESP.getChipId());

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
  int quality;
  unsigned int channel = getWiFiChannelForSSID((const char*)confJson[CONF_SSID], (int)confJson[CONF_WIFI_CH], quality);

  // Setup mesh network
  initMesh(channel, quality);

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

const char* getSmartSSID() {
  char n[14];
  snprintf(n, 14, "SMART_%08X", (uint32_t)ESP.getChipId());
  smartSsid = (const char*)n;
  return n;
}

void initMesh(uint8_t ch, int qual) {
  if(mDebug)
    mesh.setDebugMsgTypes( ERROR | STARTUP | CONNECTION );
  mesh.init(MESH_SSID, MESH_PASS, MESH_PORT, WIFI_AP_STA, ch, MESH_HIDDEN);
  #ifndef FORCE_MESH
    if(qual > MESH_QUALITY_THRESH) {
      mesh.stationManual((const char*)confJson[CONF_SSID], (const char*)confJson[CONF_PASS]);
      if(mDebug)
        Serial.printf("[+] SMART: INFO -> Connecting to Target AP.. Signal Quality: %d %\n",qual);
    }
    else {
      if(mDebug)
        Serial.printf("[+] SMART: INFO -> Using Mesh-only mode.. Signal Quality: %d %\n",qual);
    }
  #endif
  #ifdef FORCE_MESH
    if(mDebug)
      Serial.println(F("[+] SMART: WARNING --> Node is in FORCE_MESH mode, Skipping mannualStation!"));
  #endif
  mesh.setHostname(getSmartSSID());
  mesh.onChangedConnections(&changedConCallback);
  mesh.onReceive(&meshReceiveCallback);
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
    Serial.print(F("[+] SMART: MeshNode -> Running checkRoot Task...\n"));
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
unsigned int getWiFiChannelForSSID(const char* ssid, int confCh, int& quality) {
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  if(mDebug)
    Serial.printf("[+] SMART: INFO -> Identifying Channel of SSID: %s\n",ssid);
  delay(100);
  int networks =  WiFi.scanNetworks();
  for(int i=0;i<networks;i++) {    
    if(String(WiFi.SSID(i)) == ssid){
      //quality = map(WiFi.RSSI(i),-90,-20,0, 100);
      quality = WiFi.RSSI(i);
      if(mDebug) {
        Serial.printf("[+] SMART: INFO -> TARGET CHANNEL: -> %d\n",WiFi.channel(i));
        Serial.printf("[+] SMART: INFO -> TARGET QUALITY: -> %d\n",quality);
      }
      WiFi.scanDelete();
      return WiFi.channel(i);
    }
  }
  WiFi.scanDelete();
  if(mDebug)
    Serial.printf("[+] SMART: INFO -> TARGET CHANNEL FROM CONF: -> %d",confCh);
  quality = MESH_QUALITY_THRESH;
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

const char* getTopicName(String tn) {
  return String(String("smart/")+String(getSmartSSID())+String("/")+tn).c_str();
}

// When Mesh receives anything
void meshReceiveCallback( uint32_t from, String &msg) {
  decisionMaker(msg);
  pinMode(LED_BUILTIN,OUTPUT);
  Serial.printf("[+] SMART: Mesh Rx -> %s\n",msg.c_str());
  if(msg == "1")
    digitalWrite(LED_BUILTIN,LOW);
  if(msg == "0")
    digitalWrite(LED_BUILTIN,HIGH);
}

void mqttCallback(char* topic, byte* payload, unsigned int length) { //write MQTT callback here
  payload[length] = '\0';
  String p = (char*)payload;
    
  mesh.sendBroadcast(p);
  decisionMaker(p);
    
  if(mDebug)
    Serial.printf("[+] SMART: MQTT Callback -> [%s] %s\n",topic,payload);
}

void decisionMaker(String p) {
  DynamicJsonDocument doc(JSON_BUF_SIZE + p.length());
  deserializeJson(doc, p);

  if(doc.containsKey(JSON_SMARTID)) {
    Serial.println((const char*)doc[JSON_SMARTID] == smartSsid.c_str());
    Serial.println((const char*)doc[JSON_SMARTID]);
    Serial.println(smartSsid);
    if((const char*)doc[JSON_SMARTID] == smartSsid.c_str()) {
      Serial.println(doc.containsKey(JSON_TYPE) && ((const char*)doc[JSON_TYPE] == JSON_STATE));
      if(doc.containsKey(JSON_TYPE) && ((const char*)doc[JSON_TYPE] == JSON_STATE)) {
        JsonArray a = doc[JSON_TYPE].as<JsonArray>();
        byte i=0;
        for(JsonVariant v : a) {
          stateArray[i] = v.as<byte>();
          i++;
        }
        if(mDebug) {
          Serial.print(F("[+] SMART: STATE -> State changed to ["));
          for(byte k=0;k<i;k++) {
            Serial.print(stateArray[k]);
            Serial.print(F(", "));
          }
          Serial.println(F("]"));
        }
      }
    }
  }
}
