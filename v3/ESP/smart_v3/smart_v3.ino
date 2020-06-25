/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   29/05/2020
 * ALL RIGHTS RESERVED.
 */

#include <painlessMesh.h>
#include <ESP8266Ping.h>
#include <PubSubClient.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <WiFiClient.h>
#include <ArduinoOTA.h>
#include "SmartFileSystem.h"
#include "SmartWebServer.h"
#include "SmartIO.h"
#include "SmartConstants.h"

#ifdef SWITCHING_NODE
  #if NO_OF_DEVICES == 4
    SmartIo io(LATCH_PIN, CLK_PIN, DATA_PIN, OE_PIN);
  #endif
#endif

#ifdef SENSOR_NODE
  byte motionState = LOW;
  volatile bool flagMotionIsr = false;
#endif

SmartFileSystem fsys;
SmartFileSystemFlags_t flag;
SmartWebServer configServer;

painlessMesh mesh;

WiFiClient wiCli;
PubSubClient mqtt(wiCli);

Scheduler sched;

WiFiUDP ntpUdp;
NTPClient ntp(ntpUdp);

// variables
String smartSsid;
DynamicJsonDocument confJson(JSON_BUF_SIZE);
DynamicJsonDocument stateJson(JSON_BUF_SIZE);
DynamicJsonDocument linkJson1(JSON_BUF_SIZE);
DynamicJsonDocument linkJson2(JSON_BUF_SIZE);
DynamicJsonDocument linkJson3(JSON_BUF_SIZE);
DynamicJsonDocument linkJson4(JSON_BUF_SIZE);
char stateJsonBuf[JSON_BUF_SIZE];
bool internetAvailable = false;
bool isMeshActive = false;
bool isOtaActive = false;
bool isTargetSsidFound = false;
bool isStateChanged = false;
unsigned long whenStateChanged = 0;
uint32_t rootNodeAddr;
int quality;
uint16_t channel = 0;
volatile unsigned long lastInterrupted = 0;
volatile bool isInterrupted = false;
SmartNtpStruct ntpStruct;
SmartTimerStruct timerStruct;

// Task scheduling
void taskCheckRootNode(void);
Task rootCheckTask(INTERVAL_ROOT_CHECK*TASK_SECOND, TASK_FOREVER, &taskCheckRootNode, &sched);
void taskSearchTargetSSID(void);
Task searchTargetTask(INTERVAL_TARGET_SEARCH*TASK_SECOND, TASK_ONCE, &taskSearchTargetSSID, &sched);
void taskBroadcastNtp(void);
Task broadcastNtpTask(INTERVAL_NTP_BROADCAST*TASK_SECOND, TASK_ONCE, &taskBroadcastNtp, &sched);
void taskGetNtp(void);
Task getNtpTask(INTERVAL_GET_NTP*TASK_SECOND, TASK_FOREVER, &taskGetNtp, &sched);

#ifdef SWITCHING_NODE
  void taskTimerSchedulerHandler(void);
  Task timerSchedulerHandlerTask(INTERVAL_TIMER_SCHED*TASK_SECOND, TASK_FOREVER, &taskTimerSchedulerHandler, &sched);
  
  void offTimeoutD1(void);
  void offTimeoutD2(void);
  void offTimeoutD3(void);
  void offTimeoutD4(void);
  Task offTimeoutD1Task(0, TASK_ONCE, &offTimeoutD1, &sched, false);
  Task offTimeoutD2Task(0, TASK_ONCE, &offTimeoutD2, &sched, false);
  Task offTimeoutD3Task(0, TASK_ONCE, &offTimeoutD3, &sched, false);
  Task offTimeoutD4Task(0, TASK_ONCE, &offTimeoutD4, &sched, false);
#endif

#ifdef SENSOR_NODE
  void taskGetSensorValues(void);
  Task getSensorValueTask(INTERVAL_GET_SENSOR*TASK_SECOND, TASK_FOREVER, &taskGetSensorValues, &sched);
#endif

void setup() {
  Serial.begin(115200);
  Serial.println("\n");

  smartSsid = getSmartSSID();
  randomSeed(analogRead(A0));
  uint16_t bd = random(0,BOOT_DLY);
  if(mDebug) {
    mesh.setDebugMsgTypes( ERROR | STARTUP | CONNECTION);
    Serial.printf("[+] SMART: INFO -> CHIP ID = SMART_%08X\n",ESP.getChipId());
    Serial.printf("[+] SMART: BOOT -> Random Delay = %udmS\n",bd);
    #ifdef SWITCHING_NODE
      io.setDebug(mDebug);
    #endif
    fsys.setDebug(mDebug);
  }

  #ifdef SWITCHING_NODE
    if(NO_OF_DEVICES == 4) {
      // Critical routine - load last known states to relays ASAP
      io.begin();
      io.addInterrupt(SW1, CHANGE);
      io.addInterrupt(SW2, CHANGE);
      io.addInterrupt(SW3, CHANGE);
      io.addInterrupt(SW4, CHANGE);
      io.setCallback(ioCallback);
      stateJson = fsys.loadState();
      serializeJson(stateJson, stateJsonBuf);
      io.setState(stateJsonBuf);
  
      // load timer JSON from SPIFFS... using SmartFileSystem here causes ESP to go PANIC!
      if(SPIFFS.begin()) {
        File f = SPIFFS.open(TIMER_FILE,"r");
        if(f) {
          char *buf = (char*)malloc(JSON_BUF_SIZE*4*sizeof(char));
          f.readBytes(buf,f.size());
          f.close();
          parseTimerJson(String(buf));
          if(mDebug) {
            Serial.println(F("[+] SMART: INFO -> Timer file loaded.."));
            Serial.println(buf);
          }
          free(buf);
        }
        else {
          if(mDebug)
            Serial.println(F("[+] SMART: ERROR -> Timer file not found!"));
        }
      }
      // Load sensor link conf from SPIFFS!
      linkJson1 = fsys.loadSensorLink(LINK_SENSOR_1_FILE);
      linkJson2 = fsys.loadSensorLink(LINK_SENSOR_2_FILE);
      linkJson3 = fsys.loadSensorLink(LINK_SENSOR_3_FILE);
      linkJson4 = fsys.loadSensorLink(LINK_SENSOR_4_FILE);
    }
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
    ESP.restart();
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

  #ifdef SENSOR_NODE
    initSensorHardware();
    sched.addTask(getSensorValueTask);
    getSensorValueTask.enable();
  #endif
  
  // Start scheduled task execution
  sched.addTask(rootCheckTask);
  sched.addTask(broadcastNtpTask);
  sched.addTask(getNtpTask);
  rootCheckTask.enable();
  broadcastNtpTask.enable();
  getNtpTask.enable();
  #ifdef SWITCHING_NODE
    sched.addTask(timerSchedulerHandlerTask);
    timerSchedulerHandlerTask.enable();
  #endif
}

void loop() {
  // Never disconnect from the MQTT broker
  while(!mqtt.connected()) {
    connectMqttClient();
  }
  looper(); 
}

unsigned long lastMillis = 0;

void looper() {
  mqtt.loop();
  mesh.update();
  sched.execute();
  if(internetAvailable) // Don't call this on Mesh node - Maybe UDP request drops the node out of the mesh!!
    ntp.update();
  
  // Read states when interrupted and update outputs and MQTT about it
  #ifdef SWITCHING_NODE
    if(isInterrupted) {
      io.getState().toCharArray(stateJsonBuf, io.getState().length());
      io.setState(stateJsonBuf);
      fsys.saveState(stateJsonBuf);
      broadcastStateChanged(stateJsonBuf);
      isInterrupted = false;
    }
    // When state changed remotely, read sensing lines after sometime and ACK MQTT
  /*TODO: The following should occur automatically through an INTR - observe & eliminate
  if(isStateChanged && (abs(millis() - whenStateChanged) > INTERVAL_SWITCHING_TIME)) {
    broadcastStateChanged(stateJsonBuf);
    isStateChanged = false;
  }*/
  #endif
  #ifdef SENSOR_NODE
    if(flagMotionIsr) {
      taskGetSensorValues();
      flagMotionIsr = false;
    }
  #endif
  if(mDebug)
    ArduinoOTA.handle();
}

ICACHE_RAM_ATTR void ioCallback(void) {
  if(abs(millis()-lastInterrupted) > DEBOUNCE_DLY) {
    noInterrupts();
    lastInterrupted = millis();
    isInterrupted = true;
    interrupts();
  }
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

// When Mesh receives anything
void meshReceiveCallback( uint32_t from, String &msg) {
  if(mDebug)
    Serial.printf("[+] SMART: Mesh Callback -> %s\n",msg.c_str());
  decisionMaker(msg);
}

// When anything is published to MQTT
void mqttCallback(char* topic, byte* payload, unsigned int length) {
  payload[length] = '\0';
  String p = (char*)payload;
  if(mDebug)
    Serial.printf("[+] SMART: MQTT Callback -> [%s] %s\n",topic,payload);
  mesh.sendBroadcast(p);
  decisionMaker(p);
}

// Function to parse received JSON and take action
void decisionMaker(String p) {
  DynamicJsonDocument doc(JSON_BUF_SIZE*4);
  deserializeJson(doc, p);

  // Check if the packet is targeted for 'this' node
  if(doc.containsKey(JSON_SMARTID)) {
    if(String((const char*)doc[JSON_SMARTID]) == smartSsid) {

      // Set output states as per the received JSON
      if(doc.containsKey(JSON_TYPE) && (String((const char*)doc[JSON_TYPE]) == JSON_TYPE_STATE)) {
        #ifdef SWITCHING_NODE
          JsonArray ja = doc[JSON_TYPE_DATA].as<JsonArray>();
          serializeJson(ja, stateJsonBuf);
          io.setState(stateJsonBuf);
          fsys.saveState(stateJsonBuf);     // This may be automatically triggered in ISR - TODO: observe and eliminate
          isStateChanged = true;
          whenStateChanged = millis();
        #endif
      }

      // Factory reset 'this' node - erase SPIFFS & reboot
      else if(doc.containsKey(JSON_TYPE) && (String((const char*)doc[JSON_TYPE]) == JSON_TYPE_FACT_RST)) {
        if(mDebug)
          Serial.println(F("[+] SMART: -> WARNING: Executing User requested FACTORY RESET!"));
        fsys.format();
        ESP.restart();
      }

      // Soft reset 'this' node - reboot
      else if(doc.containsKey(JSON_TYPE) && (String((const char*)doc[JSON_TYPE]) == JSON_TYPE_SOFT_RST)) {
        if(mDebug)
          Serial.println(F("[+] SMART: -> INFO: Executing User requested SOFT RESET!"));
        ESP.restart();
      }

      // Publish states whenever app requests
      else if(doc.containsKey(JSON_TYPE) && (String((const char*)doc[JSON_TYPE]) == JSON_TYPE_STATE_REQ)) {
        #ifdef SWITCHING_NODE
          io.getState().toCharArray(stateJsonBuf, io.getState().length());
          broadcastStateChanged(stateJsonBuf);
        #endif
      }
    }
  }

  // Sync broadcasted NTP frames if 'this' is mesh-only node.
  if(doc.containsKey(JSON_TYPE) && String((const char*)doc[JSON_TYPE]) == JSON_TYPE_NTP && !internetAvailable) {
    ntpStruct.hour = doc[JSON_NTP_HOUR].as<int>();
    ntpStruct.minute = doc[JSON_NTP_MINUTE].as<int>();
    ntpStruct.second = doc[JSON_NTP_SECOND].as<int>();
    ntpStruct.weekday = doc[JSON_NTP_WEEKDAY].as<int>();
    if(mDebug) {
      Serial.print(F("SMART: INFO -> NTP packet synced: "));
      serializeJson(doc, Serial);
      Serial.println();
    }
  }

  // Gateway is targeted.. [MeshNode -> Gateway -> App] Write control actions here..
  if(doc.containsKey(JSON_TO) && (String((const char*)doc[JSON_TO]) == JSON_TO_GATEWAY) && (String((const char*)doc[JSON_FROM]) == JSON_TO_NODE) && internetAvailable) {
    
    // route info packet to MQTT if 'this' is gateway
    if(doc.containsKey(JSON_TYPE) && (String((const char*)doc[JSON_TYPE]) == JSON_TYPE_INFO)) {
      char msg[JSON_BUF_SIZE];
      serializeJson(doc, msg);
      mqtt.publish((const char*)doc[JSON_TOPIC], msg, RETAIN);
      if(mDebug) {
        Serial.print(F("[+] SMART: INFO -> Forwarding INFO packet from "));
        serializeJson(doc[JSON_SMARTID], Serial);
        Serial.println();
      }
    }

    // route stateChanged packet to respective MQTT topic if 'this' is gateway
    if(doc.containsKey(JSON_TYPE) && (String((const char*)doc[JSON_TYPE]) == JSON_TYPE_STATE)) {
      char msg[JSON_BUF_SIZE];
      serializeJson(doc, msg);
      mqtt.publish((const char*)doc[JSON_TOPIC], msg, RETAIN);
      if(mDebug) {
        Serial.print(F("[+] SMART: INFO -> Forwarding STATE packet from "));
        serializeJson(doc[JSON_SMARTID], Serial);
        Serial.println();
      }
    }
  }

  // Gateway is targeted.. [MeshNode <- Gateway <- App] Write control actions here..
  // Either for 'this' or broadcast to mesh
  if(doc.containsKey(JSON_TO) && (String((const char*)doc[JSON_TO]) == JSON_TO_GATEWAY) && (String((const char*)doc[JSON_FROM]) == JSON_TO_APP) && internetAvailable) {
    if(mDebug) {
      Serial.println(F("[+] SMART: App -> Mesh -> Broadcasting following packet to mesh.."));
      serializeJson(doc, Serial);
      Serial.println();
    }
    char msgBuf[JSON_BUF_SIZE];
    serializeJson(doc, msgBuf);
    mesh.sendBroadcast(msgBuf);
  }

  parseTimerJson(p);
  parseSensorLinkJson(p);
  parseSensorBroadcast(p);

  if(mDebug) {                          // TODO: REMOVE THIS LATER
    pinMode(LED_BUILTIN,OUTPUT);
    if(p == "1")
      digitalWrite(LED_BUILTIN,LOW);
    if(p == "0")
      digitalWrite(LED_BUILTIN,HIGH);
  }
}
