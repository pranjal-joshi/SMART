// Parse JSON received from PubSub
void parseTimerJson(const char* buf) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  deserializeJson(doc, buf);
  if(doc.containsKey(JSON_SMARTID)&& String((const char*)doc[JSON_SMARTID]) == smartSsid
  && doc.containsKey(JSON_TYPE) && String((const char*)doc[JSON_TYPE]) == JSON_TYPE_TIMER) {
    if(mDebug) {
      Serial.println(F("[+] SMART: INFO -> TIMER packet received.."));
      serializeJson(doc, Serial);
      Serial.println();
    }
    JsonObject data = doc["data"];
    
    JsonArray data_time = data["time"];
    
    JsonArray data_time_0_0 = data_time[0][0];
    timerStruct.onTimeD1[0] = data_time_0_0[0]; // 1
    timerStruct.onTimeD1[1] = data_time_0_0[1]; // 2
    timerStruct.onTimeD1[2] = data_time_0_0[2]; // 3
    
    JsonArray data_time_0_1 = data_time[0][1];
    timerStruct.offTimeD1[0] = data_time_0_1[0]; // 1
    timerStruct.offTimeD1[1] = data_time_0_1[1]; // 2
    timerStruct.offTimeD1[2] = data_time_0_1[2]; // 3
    
    JsonArray data_time_1_0 = data_time[1][0];
    timerStruct.onTimeD2[0] = data_time_1_0[0]; // 1
    timerStruct.onTimeD2[1] = data_time_1_0[1]; // 2
    timerStruct.onTimeD2[2] = data_time_1_0[2]; // 3
    
    JsonArray data_time_1_1 = data_time[1][1];
    timerStruct.offTimeD2[0] = data_time_1_1[0]; // 1
    timerStruct.offTimeD2[1] = data_time_1_1[1]; // 2
    timerStruct.offTimeD2[2] = data_time_1_1[2]; // 3
    
    JsonArray data_time_2_0 = data_time[2][0];
    timerStruct.onTimeD3[0] = data_time_2_0[0]; // 1
    timerStruct.onTimeD3[1] = data_time_2_0[1]; // 2
    timerStruct.onTimeD3[2] = data_time_2_0[2]; // 3
    
    JsonArray data_time_2_1 = data_time[2][1];
    timerStruct.offTimeD3[0] = data_time_2_1[0]; // 1
    timerStruct.offTimeD3[1] = data_time_2_1[1]; // 2
    timerStruct.offTimeD3[2] = data_time_2_1[2]; // 3
    
    JsonArray data_time_3_0 = data_time[3][0];
    timerStruct.onTimeD4[0] = data_time_3_0[0]; // 1
    timerStruct.onTimeD4[1] = data_time_3_0[1]; // 2
    timerStruct.onTimeD4[2] = data_time_3_0[2]; // 3
    
    JsonArray data_time_3_1 = data_time[3][1];
    timerStruct.offTimeD4[0] = data_time_3_1[0]; // 1
    timerStruct.offTimeD4[1] = data_time_3_1[1]; // 2
    timerStruct.offTimeD4[2] = data_time_3_1[2]; // 3
    
    JsonArray data_weekday = data["weekday"];

    JsonArray data_weekday_0 = data_weekday[0];
    timerStruct.weekdaysD1[0] = data_weekday_0[0]; // 0
    timerStruct.weekdaysD1[1] = data_weekday_0[1]; // 1
    timerStruct.weekdaysD1[2] = data_weekday_0[2]; // 2
    timerStruct.weekdaysD1[3] = data_weekday_0[3]; // 3
    timerStruct.weekdaysD1[4] = data_weekday_0[4]; // 4
    timerStruct.weekdaysD1[5] = data_weekday_0[5]; // 5
    timerStruct.weekdaysD1[6] = data_weekday_0[6]; // 6
    
    JsonArray data_weekday_1 = data_weekday[1];
    timerStruct.weekdaysD2[0] = data_weekday_1[0]; // 0
    timerStruct.weekdaysD2[1] = data_weekday_1[1]; // 1
    timerStruct.weekdaysD2[2] = data_weekday_1[2]; // 2
    timerStruct.weekdaysD2[3] = data_weekday_1[3]; // 3
    timerStruct.weekdaysD2[4] = data_weekday_1[4]; // 4
    timerStruct.weekdaysD2[5] = data_weekday_1[5]; // 5
    timerStruct.weekdaysD2[6] = data_weekday_1[6]; // 6
    
    JsonArray data_weekday_2 = data_weekday[2];
    timerStruct.weekdaysD3[0] = data_weekday_2[0]; // 0
    timerStruct.weekdaysD3[1] = data_weekday_2[1]; // 1
    timerStruct.weekdaysD3[2] = data_weekday_2[2]; // 2
    timerStruct.weekdaysD3[3] = data_weekday_2[3]; // 3
    timerStruct.weekdaysD3[4] = data_weekday_2[4]; // 4
    timerStruct.weekdaysD3[5] = data_weekday_2[5]; // 5
    timerStruct.weekdaysD3[6] = data_weekday_2[6]; // 6
    
    JsonArray data_weekday_3 = data_weekday[3];
    timerStruct.weekdaysD4[0] = data_weekday_0[0]; // 0
    timerStruct.weekdaysD4[1] = data_weekday_0[1]; // 1
    timerStruct.weekdaysD4[2] = data_weekday_0[2]; // 2
    timerStruct.weekdaysD4[3] = data_weekday_0[3]; // 3
    timerStruct.weekdaysD4[4] = data_weekday_0[4]; // 4
    timerStruct.weekdaysD4[5] = data_weekday_0[5]; // 5
    timerStruct.weekdaysD1[6] = data_weekday_0[6]; // 6
    
    JsonArray data_status = data["status"];
    timerStruct.statusD1 = data_status[0]; // "enable"
    timerStruct.statusD2 = data_status[1]; // "disable"
    timerStruct.statusD3 = data_status[2]; // "enable"
    timerStruct.statusD4 = data_status[3]; // "disable"

    // TODO - add task dynamically to switch devices
  }
}

// Parse NTP packet from Mesh
void parseNtpJson(const char* buf) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  deserializeJson(doc, buf);
  if(mDebug) {
    Serial.println(F("[+] SMART: SYNC -> NTP packet received.."));
    serializeJson(doc, Serial);
    Serial.println();
  }
  if(doc.containsKey(JSON_TYPE)&& String((const char*)doc[JSON_TYPE]) == JSON_TYPE_NTP) {
    ntpStruct.hour = doc[JSON_NTP_HOUR].as<int>();
    ntpStruct.minute = doc[JSON_NTP_MINUTE].as<int>();
    ntpStruct.second = doc[JSON_NTP_SECOND].as<int>();
    ntpStruct.weekday = doc[JSON_NTP_WEEKDAY].as<int>();
  }
}

// Broadcast time received by NTP
void taskBroadcastNtp(void) {
  if(internetAvailable) {
    DynamicJsonDocument doc(JSON_BUF_SIZE);
    char charBuf[JSON_BUF_SIZE];
    doc[JSON_FROM] = JSON_TO_GATEWAY;
    doc[JSON_TO] = JSON_TO_NODE;
    doc[JSON_TYPE] = JSON_TYPE_NTP;
    taskGetNtp();
    doc[JSON_NTP_HOUR] = ntpStruct.hour;
    doc[JSON_NTP_MINUTE] = ntpStruct.minute;
    doc[JSON_NTP_SECOND] = ntpStruct.second;
    doc[JSON_NTP_WEEKDAY] = ntpStruct.weekday;
    doc.shrinkToFit();
    if(mDebug) {
      Serial.print(F("[+] SMART: BroadcastNtpTask -> "));
      serializeJson(doc, Serial);
      Serial.println();
    }
    serializeJson(doc, charBuf);
    mesh.sendBroadcast(charBuf);
  }
  else {
    if(mDebug)
      Serial.println(F("[+] SMART: BroadcastNtpTask -> No Internet - Not broadcasting.."));
  }
  broadcastNtpTask.restartDelayed((INTERVAL_NTP_BROADCAST - ntpStruct.second)*TASK_SECOND);
}

// Get NTP data into global variable structure
void taskGetNtp(void) {
  ntpStruct.hour = ntp.getHours();
  ntpStruct.minute = ntp.getMinutes();
  ntpStruct.second = ntp.getSeconds();
  ntpStruct.weekday = ntp.getDay();
}

// Brodcast changed states to MQTT or Mesh Gateway
void broadcastStateChanged(const char* stateBuf) {
  DynamicJsonDocument doc(JSON_BUF_SIZE), arr(JSON_BUF_SIZE);
  char charBuf[JSON_BUF_SIZE];
  deserializeJson(arr, stateBuf);
  arr.shrinkToFit();
  if(internetAvailable)
    doc[JSON_TO] = JSON_TO_APP;
  else
    doc[JSON_TO] = JSON_TO_GATEWAY;
  doc[JSON_TOPIC] = getTopicName(JSON_TYPE_STATE);
  doc[JSON_FROM] = JSON_TO_NODE;
  doc[JSON_SMARTID] = smartSsid;
  doc[JSON_TYPE] = JSON_TYPE_STATE;
  doc[JSON_TYPE_DATA] = arr.as<JsonArray>();
  serializeJson(doc, charBuf);
  if(mDebug) {
    Serial.print(F("[+] SMART: INTR -> Broadcasting stateChanged packet: "));
    serializeJson(doc, Serial);
    Serial.println();
  }
  if(internetAvailable) {
    mqtt.publish(getTopicName(JSON_TYPE_STATE).c_str(), charBuf, RETAIN);
  }
  else {
    mesh.sendBroadcast(charBuf);
  }
}

// Init Mesh network on boot
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

// Connect to MQTT server if not connected & subscribe to required topics
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
        ntp.begin();
        ntp.setTimeOffset(OFFSET_INDIA_GMT);
        if(mqtt.connect(getSmartSSID())) {
          if(mDebug) {
            Serial.println(F("[+] SMART: INFO -> MQTT broker connected."));
            Serial.print(F("[+] SMART: INFO -> MQTT IP: "));
            Serial.println(confJson[CONF_MQTT_IP].as<const char*>());
            Serial.print(F("[+] SMART: INFO -> MQTT PORT: "));
            Serial.println(confJson[CONF_MQTT_PORT].as<int>());
            mqtt.publish(TOPIC_TEST,"SMART: MQTT Client Ready!");
            mqtt.subscribe(TOPIC_TEST);
          }
          // TODO - Subscribe here for required topics
          mqtt.subscribe(String((String)"smart/"+String(confJson[CONF_USERNAME].as<const char*>())+"/gateway").c_str());    // subscribe to smart/username/gateway
          mqtt.publish(getTopicName("info").c_str(), getNodeInfo().c_str(), RETAIN);
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

// Get NodeName or SSID -> E.g. SMART_1A2B3C4D
const char* getSmartSSID() {
  size_t sz = snprintf(NULL, 0, "SMART_%08X", (uint32_t)ESP.getChipId()) + 1;
  char *ssid = (char*)malloc(sz);
  snprintf(ssid, 15, "SMART_%08X", (uint32_t)ESP.getChipId());
  smartSsid = String(ssid);
  return ssid;
}

// returns the nodeId of Root node in painlessMesh format
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

// Get Node info in JSON so that App can know what to display
String getNodeInfo() {
  DynamicJsonDocument d(JSON_BUF_SIZE);
  char buf[JSON_BUF_SIZE];
  d[JSON_TOPIC] = getTopicName(JSON_TYPE_INFO);
  if(internetAvailable)
    d[JSON_TO] = JSON_TO_APP;
  else
    d[JSON_TO] = JSON_TO_GATEWAY;
  d[JSON_FROM] = JSON_TO_NODE;
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

// Check for internet availability and control ArduinoOTA accordingly
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

// Setup Arduino OTA
void setupArduinoOTA(void) {
  if(mDebug) {
    Serial.println(F("[+] SMART: INFO -> Starting ArduinoOTA service..."));
    ArduinoOTA.setHostname(getSmartSSID()) ;
    ArduinoOTA.begin();
  }
}

// Get topic name in format = smart/username/smartId/topic
String getTopicName(String tn) {
  return String((String)"smart/"+String(confJson[CONF_USERNAME].as<const char*>())+"/"+String(getSmartSSID())+"/"+tn);
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

// Task to search for target SSID if it's not observed since boot
void taskSearchTargetSSID(void) {
  if(mDebug)
    Serial.println(F("[+] SMART: INFO -> taskSearchTargetSSIDTask -> Searching for target.."));
  mesh.stop();
  channel = getWiFiChannelForSSID((const char*)confJson[CONF_SSID], (int)confJson[CONF_WIFI_CH], quality);
  if(mDebug)
      Serial.print(F("[+] SMART: INFO -> taskSearchTargetSSIDTask -> Task completed, Resuming Mesh!"));
  initMesh(channel, quality);
}

// Task to check/set for root node periodically
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
    rootCheckTask.disable();
    sched.deleteTask(rootCheckTask);
    if(mDebug) {
      Serial.println(F("[+] SMART: INFO -> checkRootTask -> Disabled searchTargetTask as ROOT is found!"));
    }
  }
}
