
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
      Serial.print(F("[+] SMART: INFO -> checkRootTask -> Disabled searchTargetTask as ROOT is found!"));
    }
  }
}
