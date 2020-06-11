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
    io.setDebug(mDebug);
    fsys.setDebug(mDebug);
  }

  if(NO_OF_DEVICES == 4) {
    // Critical routine - load last known states to relays ASAP
    io.begin();
    io.addInterrupt(SW1, CHANGE);
    io.addInterrupt(SW2, CHANGE);
    io.addInterrupt(SW3, CHANGE);
    io.addInterrupt(SW4, CHANGE);
    stateJson = fsys.loadState();
    //io.setState(stateJson.as<JsonVariant>());
    // TODO - Debug setState JSON passing
  }
  
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
  if(io.isInterrupted) {
    stateJson = io.getState();
    io.isInterrupted = false;
    if(mDebug) {
      Serial.print(F("[+] SMART: INTRPT -> States are "));
      serializeJson(stateJson, Serial);
      Serial.println();
    }
  }
  if(mDebug)
    ArduinoOTA.handle();
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

  // Broadcast info packets in changes in connection
  mesh.sendBroadcast(getNodeInfo());
}

// Get Node info in JSON so that App can know what to display
String getNodeInfo() {
  DynamicJsonDocument d(JSON_BUF_SIZE);
  char buf[JSON_BUF_SIZE];
  if(internetAvailable)
    d[JSON_TO] = JSON_TO_APP;
  else
    d[JSON_TO] = JSON_TO_GATEWAY;
  d[JSON_SMARTID] = smartSsid;
  d[JSON_TYPE] = JSON_TYPE_INFO;
  #ifdef SWITCHING_NODE
    d[JSON_DEVICE_TYPE] =  JSON_DEVICE_SWITCH;
  #endif
  #ifdef SENSOR_NODE
    d[JSON_DEVICE_TYPE] =  JSON_DEVICE_SENSOR;
  #endif
  d[JSON_NODENAME] = confJson[CONF_NODENAME];
  d[JSON_NoD] = NO_OF_DEVICES;
  d.shrinkToFit();
  if(mDebug) {
    Serial.println(F("[+] SMART: INFO -> Info packet generated as follow:"));
    serializeJson(d, Serial);
    Serial.println();
  }
  serializeJson(d, buf);
  return String(buf);
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

  if(doc.containsKey(JSON_TO) && (String((const char*)doc[JSON_TO]) == JSON_TO_GATEWAY) && internetAvailable) {
    // Gateway is targeted.. Write control actions here..
    
    // route info packet to MQTT if 'this' is gateway
    if(doc.containsKey(JSON_TYPE) && (String((const char*)doc[JSON_TYPE]) == JSON_TYPE_INFO)) {
      String s = "smart/"+String((const char*)confJson[CONF_USERNAME])+"/"+String((const char*)doc[JSON_SMARTID])+"/info";
      const char* topic = s.c_str();
      char msg[JSON_BUF_SIZE];
      serializeJson(doc, msg);
      mqtt.publish(topic, msg, RETAIN);
      if(mDebug) {
        Serial.print(F("[+] SMART: INFO -> Forwarding INFO packet from "));
        serializeJson(doc[JSON_SMARTID], Serial);
        Serial.println();
      }
    }
  }

  if(mDebug) {
    pinMode(LED_BUILTIN,OUTPUT);
    if(p == "1")
      digitalWrite(LED_BUILTIN,LOW);
    if(p == "0")
      digitalWrite(LED_BUILTIN,HIGH);
  }

  // Check if the packet is targeted for 'this' node
  if(doc.containsKey(JSON_SMARTID)) {
    if(String((const char*)doc[JSON_SMARTID]) == smartSsid) {
      if(doc.containsKey(JSON_TYPE) && (String((const char*)doc[JSON_TYPE]) == JSON_TYPE_STATE)) {
        JsonArray a = (JsonArray)doc[JSON_TYPE_DATA];
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
