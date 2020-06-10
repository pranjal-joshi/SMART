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
#include "SmartIO.h"
#include "SmartConstants.h"

SmartFileSystem fsys;
SmartFileSystemFlags_t flag;
SmartWebServer configServer;
#if NO_OF_DEVICES == 4
  SmartIo io(LATCH_PIN, CLK_PIN, DATA_PIN, OE_PIN);
#endif

painlessMesh mesh;

WiFiClient wiCli;
PubSubClient mqtt(wiCli);

Scheduler sched;

void taskCheckRootNode(void);
Task rootCheckTask(INTERVAL_ROOT_CHECK*TASK_SECOND, TASK_FOREVER, &taskCheckRootNode, &sched);
void taskSearchTargetSSID(void);
Task searchTargetTask(INTERVAL_TARGET_SEARCH*TASK_SECOND, TASK_ONCE, &taskSearchTargetSSID, &sched);

// variables
String smartSsid;
DynamicJsonDocument confJson(JSON_BUF_SIZE);
DynamicJsonDocument stateJson(NO_OF_DEVICES);
bool internetAvailable = false;
bool isMeshActive = false;
bool isOtaActive = false;
bool isTargetSsidFound = false;
uint32_t rootNodeAddr;
byte stateArray[NO_OF_DEVICES];
int quality;
uint16_t channel = 0;

void setup() {
  Serial.begin(115200);
  Serial.println("\n");

  randomSeed(analogRead(A0));
  uint16_t bd = random(0,BOOT_DLY);
  if(mDebug) {
    mesh.setDebugMsgTypes( ERROR | STARTUP | CONNECTION );
    Serial.printf("[+] SMART: INFO -> CHIP ID = SMART_%08X\n",ESP.getChipId());
    Serial.printf("[+] SMART: BOOT -> Random Delay = %udmS\n",bd);
    #if NO_OF_DEVICES == 4
      io.setDebug(mDebug);
    #endif
    fsys.setDebug(mDebug);
  }

  #if NO_OF_DEVICES == 4
    // Critical routine - load last known states to relays ASAP
    stateJson = fsys.loadState();
    io.setState(stateJson);
  #endif
  
  delay(bd);

  // Read config.json file to retrieve login creds
  if(fsys.isConfigEmpty()) {
    configServer.setDebug(mDebug);
    configServer.begin(getSmartSSID(),SMART_PASS);
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
  channel = getWiFiChannelForSSID((const char*)confJson[CONF_SSID], (int)confJson[CONF_WIFI_CH], quality);

  // Setup mesh network
  initMesh(channel, quality);

  // Start scheduled task execution
  sched.addTask(rootCheckTask);
  rootCheckTask.enable();
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
  size_t sz = snprintf(NULL, 0, "SMART_%08X", (uint32_t)ESP.getChipId()) + 1;
  char *ssid = (char*)malloc(sz);
  snprintf(ssid, 15, "SMART_%08X", (uint32_t)ESP.getChipId());
  smartSsid = String(ssid);
  return ssid;
}

void initMesh(uint8_t ch, int qual) {    
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
  #ifdef FORCE_ROOT
    mesh.setRoot(true);
    if(mDebug)
      Serial.println(F("[+] SMART: WARNING --> Node is in FORCE_ROOT mode!"));
  #endif
  mesh.setContainsRoot(true);
}

// setup arduino OTA only after device is connected to some network
void changedConCallback() {
  if(mDebug)
    Serial.println(F("[+] SMART: INFO -> Mesh -> Callback trigered -> onChangedConnection"));
  if(mesh.isConnected(mesh.getNodeId())) {
    isMeshActive = true;
  }
  else {
    isMeshActive = false;
  }
  taskCheckRootNode();
}

void taskCheckRootNode() {
  // Get the root node ID, No one is root? AND this connected to internet? -> Make this root
  if(!mesh.isRoot()) {
    if(mDebug) {
      Serial.print(F("[+] SMART: INFO -> checkRootTask -> getRootId = "));
      Serial.println(getRootId(mesh.asNodeTree()),HEX);
    }
    if(getRootId(mesh.asNodeTree()) == 0 && isInternetAvailable()) {
      mesh.setRoot(true);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> checkRootTask -> Setting this node as ROOT!"));
    }
  }
  else {
    if(mDebug) {
      Serial.print(F("[+] SMART: INFO -> checkRootTask -> This is ROOT! = "));
      Serial.println(smartSsid);
    }
  }
  // if anyone is ROOT, then stop scanning target SSID as the ROOT must be already connected to it!
  if(getRootId(mesh.asNodeTree()) > 0) {
    searchTargetTask.disable();
    sched.deleteTask(searchTargetTask);
    if(mDebug) {
      Serial.print(F("[+] SMART: INFO -> checkRootTask -> Disabled searchTargetTask as ROOT is found!"));
    }
  }
}

size_t getRootId(painlessmesh::protocol::NodeTree nt) {
  if(nt.root)
    return nt.nodeId;
  for(auto&& s : nt.subs) {
    auto id = getRootId(s);
    if(id != 0)
      return id;
  }
  return 0;
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
  if(mesh.isConnected(mesh.getNodeId()))
    mesh.stop();
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
      isTargetSsidFound = true;
      searchTargetTask.disable();
      sched.deleteTask(searchTargetTask);
      if(mDebug) {
        Serial.printf("[+] SMART: INFO -> TARGET CHANNEL: -> %d\n",WiFi.channel(i));
        Serial.printf("[+] SMART: INFO -> TARGET QUALITY: -> %d\n",quality);
      }
      WiFi.scanDelete();
      return WiFi.channel(i);
    }
  }
  WiFi.scanDelete();
  if(mDebug) {
    Serial.println(F("[+] SMART: ERROR -> TARGET SSID not found!"));
    Serial.printf("[+] SMART: INFO -> TARGET CHANNEL FROM CONF: -> %d\n",confCh);
  }
  quality = MESH_QUALITY_THRESH;
  isTargetSsidFound = false;
  searchTargetTask.restartDelayed(INTERVAL_TARGET_SEARCH * TASK_SECOND);
  //return confCh;
  return 0;
}

void taskSearchTargetSSID(void) {
  if(mDebug)
    Serial.println(F("[+] SMART: INFO -> taskSearchTargetSSIDTask -> Searching for target.."));
  mesh.stop();
  channel = getWiFiChannelForSSID((const char*)confJson[CONF_SSID], (int)confJson[CONF_WIFI_CH], quality);
  if(mDebug)
      Serial.print(F("[+] SMART: INFO -> taskSearchTargetSSIDTask -> Task completed, Resuming Mesh!"));
  initMesh(channel, quality);
}

bool isInternetAvailable(void) {
  #ifdef FORCE_MESH
    if(mDebug)
      Serial.println(F("[+] SMART: WARNING --> Node is in FORCE_MESH mode!"));
    return false;
  #endif
  if(WiFi.SSID() == (const char*)confJson[CONF_SSID]) {
    if(!isOtaActive) {
      setupArduinoOTA();
      isOtaActive = true;
    }
    return Ping.ping("www.google.co.in",1); 
  }
  return false;
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
  if(mDebug)
    Serial.printf("[+] SMART: Mesh Callback -> %s\n",msg.c_str());
  decisionMaker(msg);
}

void mqttCallback(char* topic, byte* payload, unsigned int length) { //write MQTT callback here
  payload[length] = '\0';
  String p = (char*)payload;
  if(mDebug)
    Serial.printf("[+] SMART: MQTT Callback -> [%s] %s\n",topic,payload);
  mesh.sendBroadcast(p);
  decisionMaker(p);
}

void decisionMaker(String p) {
  DynamicJsonDocument doc(JSON_BUF_SIZE + p.length());
  deserializeJson(doc, p);

  if(mDebug) {
    pinMode(LED_BUILTIN,OUTPUT);
    if(p == "1")
      digitalWrite(LED_BUILTIN,LOW);
    if(p == "0")
      digitalWrite(LED_BUILTIN,HIGH);
  }

  if(doc.containsKey(JSON_SMARTID)) {
    if(String((const char*)doc[JSON_SMARTID]) == smartSsid) {
      if(doc.containsKey(JSON_TYPE) && (String((const char*)doc[JSON_TYPE]) == JSON_STATE)) {
        JsonArray a = (JsonArray)doc[JSON_DATA];
        byte i=0;
        for(JsonVariant v : a) {
          stateArray[i] = v.as<byte>();
          i++;
        }
        if(mDebug) {
          Serial.print(F("[+] SMART: STATE -> State changed to "));
          serializeJson(a,Serial);
          Serial.println();
        }
      }
    }
  }
}
