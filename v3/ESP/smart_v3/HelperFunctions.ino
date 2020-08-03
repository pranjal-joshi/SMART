// Add vector linking of mesh nodeId & smartId
void parseVectorLink(String p) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  deserializeJson(doc, p);
  // todo - implement checking and updating STATUS TOPIC when node disconnects
  if(String((const char*)doc[JSON_TYPE]) == JSON_TYPE_VECTOR_LINK) {
    if (std::find(nodeIdVector.begin(), nodeIdVector.end(), doc[JSON_NODEID].as<uint32_t>()) == nodeIdVector.end()) {
      nodeIdVector.push_back(doc[JSON_NODEID].as<uint32_t>());
      smartIdVector.push_back(String(doc[JSON_SMARTID].as<const char*>()));
      if(mDebug) {
        Serial.print(F("[+] SMART: INFO -> New VECTOR LINK added:\tNodeID: "));
        serializeJson(doc[JSON_NODEID], Serial);
        Serial.print(F("\t SmartID: "));
        serializeJson(doc[JSON_SMARTID], Serial);
        Serial.println();
      }
    }
  }
}

// Broadcast vector linking for MESH
void broadcastVectorLink(void) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  doc[JSON_NODEID] = mesh.getNodeId();
  doc[JSON_SMARTID] = smartSsid;
  doc[JSON_TYPE] = JSON_TYPE_VECTOR_LINK;
  doc.shrinkToFit();
  char buf[JSON_BUF_SIZE];
  serializeJson(doc, buf);
  mesh.sendBroadcast(buf);
}

// Get sensor broadcast packet and perform a control action
void parseSensorBroadcast(String p) {
  DynamicJsonDocument doc(JSON_BUF_SIZE*4);
  deserializeJson(doc, p);
  if(String((const char*)doc[JSON_DEVICE_TYPE]) == JSON_DEVICE_SENSOR && String((const char*)doc[JSON_TYPE]) == JSON_TYPE_BROADCAST) {

    // Publish Sensor values to MQTT if 'this' is gateway
    if(internetAvailable && mqtt.connected()) {
      mqtt.publish((const char*)doc[JSON_TOPIC], p.c_str(), RETAIN);
    }

    #ifdef SWITCHING_NODE     // Execute only if SWITCHING_NODE
      // Control action as per the sensor broadcast packet
      if(linkJson1[JSON_TYPE_DATA][JSON_TYPE_STATE].as<uint8_t>() == 1
      && String((const char*)doc[JSON_SMARTID]) == String((const char*)linkJson1[JSON_TYPE_DATA][JSON_FROM])
      && !io.getByTimer(1)) {
        if(mDebug)
            Serial.println(F("[+] SMART: INFO -> MOTION trigger for D1"));
        if(!checkTimeForMotion(
          linkJson1[JSON_TYPE_DATA][JSON_SENSOR_EN_HR].as<uint8_t>(),linkJson1[JSON_TYPE_DATA][JSON_SENSOR_EN_MIN].as<uint8_t>(),
          linkJson1[JSON_TYPE_DATA][JSON_SENSOR_DS_HR].as<uint8_t>(),linkJson1[JSON_TYPE_DATA][JSON_SENSOR_DS_MIN].as<uint8_t>()
        )) {
          return;
        }
        if(doc[JSON_SENSOR_MOTION].as<uint8_t>() == 1) {
          if(!io.getRawState(1)) {
            io.setBySensor(1, true);
            io.setRawState(1, HIGH);
          }
        }
        else {
          offTimeoutD1Task.enableIfNot();
          offTimeoutD1Task.restartDelayed(linkJson1[JSON_TYPE_DATA][JSON_SENSOR_TIMEOUT].as<unsigned long>()*TASK_MINUTE);
        }
      }
      if(linkJson2[JSON_TYPE_DATA][JSON_TYPE_STATE].as<uint8_t>() == 1
      && String((const char*)doc[JSON_SMARTID]) == String((const char*)linkJson2[JSON_TYPE_DATA][JSON_FROM])
      && !io.getByTimer(2)) {
        if(mDebug)
            Serial.println(F("[+] SMART: INFO -> MOTION trigger for D2"));
        if(!checkTimeForMotion(
          linkJson2[JSON_TYPE_DATA][JSON_SENSOR_EN_HR].as<uint8_t>(),linkJson2[JSON_TYPE_DATA][JSON_SENSOR_EN_MIN].as<uint8_t>(),
          linkJson2[JSON_TYPE_DATA][JSON_SENSOR_DS_HR].as<uint8_t>(),linkJson2[JSON_TYPE_DATA][JSON_SENSOR_DS_MIN].as<uint8_t>()
        )) {
          return;
        }
        if(doc[JSON_SENSOR_MOTION].as<uint8_t>() == 1) {
          if(!io.getRawState(2)) {
            io.setBySensor(2, true);
            io.setRawState(2, HIGH);
          }
        }
        else {
          offTimeoutD2Task.enableIfNot();
          offTimeoutD2Task.restartDelayed(linkJson2[JSON_TYPE_DATA][JSON_SENSOR_TIMEOUT].as<unsigned long>()*TASK_MINUTE);
        }
      }
      if(linkJson3[JSON_TYPE_DATA][JSON_TYPE_STATE].as<uint8_t>() == 1
      && String((const char*)doc[JSON_SMARTID]) == String((const char*)linkJson3[JSON_TYPE_DATA][JSON_FROM])
      && !io.getByTimer(3)) {
        if(mDebug)
            Serial.println(F("[+] SMART: INFO -> MOTION trigger for D3"));
        if(!checkTimeForMotion(
          linkJson3[JSON_TYPE_DATA][JSON_SENSOR_EN_HR].as<uint8_t>(),linkJson3[JSON_TYPE_DATA][JSON_SENSOR_EN_MIN].as<uint8_t>(),
          linkJson3[JSON_TYPE_DATA][JSON_SENSOR_DS_HR].as<uint8_t>(),linkJson3[JSON_TYPE_DATA][JSON_SENSOR_DS_MIN].as<uint8_t>()
        )) {
          return;
        }
        if(doc[JSON_SENSOR_MOTION].as<uint8_t>() == 1) {
          if(!io.getRawState(3)) {
            io.setBySensor(3, true);
            io.setRawState(3, HIGH);
          }
        }
        else {
          offTimeoutD3Task.enableIfNot();
          offTimeoutD3Task.restartDelayed(linkJson3[JSON_TYPE_DATA][JSON_SENSOR_TIMEOUT].as<unsigned long>()*TASK_MINUTE);
        }
      }
      if(linkJson4[JSON_TYPE_DATA][JSON_TYPE_STATE].as<uint8_t>() == 1
      && String((const char*)doc[JSON_SMARTID]) == String((const char*)linkJson4[JSON_TYPE_DATA][JSON_FROM])
      && !io.getByTimer(4)) {
        if(mDebug)
            Serial.println(F("[+] SMART: INFO -> MOTION trigger for D4"));
        if(!checkTimeForMotion(
          linkJson4[JSON_TYPE_DATA][JSON_SENSOR_EN_HR].as<uint8_t>(),linkJson4[JSON_TYPE_DATA][JSON_SENSOR_EN_MIN].as<uint8_t>(),
          linkJson4[JSON_TYPE_DATA][JSON_SENSOR_DS_HR].as<uint8_t>(),linkJson4[JSON_TYPE_DATA][JSON_SENSOR_DS_MIN].as<uint8_t>()
        )) {
          return;
        }
        if(doc[JSON_SENSOR_MOTION].as<uint8_t>() == 1) {
          if(!io.getRawState(4)) {
            io.setBySensor(4, true);
            io.setRawState(4, HIGH);
          }
        }
        else {
          offTimeoutD4Task.enableIfNot();
          offTimeoutD4Task.restartDelayed(linkJson4[JSON_TYPE_DATA][JSON_SENSOR_TIMEOUT].as<unsigned long>()*TASK_MINUTE);
        }
      }
    #endif
  }
}

// Check and execute time scheduled tasks
void taskTimerSchedulerHandler(void) {

  #ifdef SWITCHING_NODE   // Execute only for SWITCHES, not SENSORS
  
  // if timer schedular is enabled for the task on this day
  if(timerStruct.statusD1 > 0 && timerStruct.weekdaysD1[ntpStruct.weekday] > 0 && NO_OF_DEVICES > 0) {
    if(ntpStruct.hour == timerStruct.onTimeD1[0] && ntpStruct.minute == timerStruct.onTimeD1[1] && (abs(millis()-timerStruct.onIgnoreD1) > INTERVAL_IGNORE_TIMER)) {
      timerStruct.onIgnoreD1 = millis();
      io.setByTimer(1, true);
      if(!io.getRawState(1))
        io.setRawState(1, HIGH);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> taskTimerSchedular -> D1 turned ON due to scheduled timer."));
    }
    if(ntpStruct.hour == timerStruct.offTimeD1[0] && ntpStruct.minute == timerStruct.offTimeD1[1] && (abs(millis()-timerStruct.offIgnoreD1) > INTERVAL_IGNORE_TIMER)) {
      timerStruct.offIgnoreD1 = millis();
      io.setByTimer(1, false);
      if(io.getRawState(1))
        io.setRawState(1, LOW);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> taskTimerSchedular -> D1 turned OFF due to scheduled timer."));
    } 
  }

  if(timerStruct.statusD2 > 0 && timerStruct.weekdaysD2[ntpStruct.weekday] > 0 && NO_OF_DEVICES > 1) {
    if(ntpStruct.hour == timerStruct.onTimeD2[0] && ntpStruct.minute == timerStruct.onTimeD2[1] && (abs(millis()-timerStruct.onIgnoreD2) > INTERVAL_IGNORE_TIMER)) {
      timerStruct.onIgnoreD2 = millis();
      io.setByTimer(2, true);
      if(!io.getRawState(2))
        io.setRawState(2, HIGH);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> taskTimerSchedular -> D2 turned ON due to scheduled timer."));
    }
    if(ntpStruct.hour == timerStruct.offTimeD2[0] && ntpStruct.minute == timerStruct.offTimeD2[1] && (abs(millis()-timerStruct.offIgnoreD2) > INTERVAL_IGNORE_TIMER)) {
      timerStruct.offIgnoreD2 = millis();
      io.setByTimer(2, false);
      if(io.getRawState(2))
        io.setRawState(2, LOW);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> taskTimerSchedular -> D2 turned OFF due to scheduled timer."));
    } 
  }

  if(timerStruct.statusD3 > 0 && timerStruct.weekdaysD3[ntpStruct.weekday] > 0 && NO_OF_DEVICES > 2) {
    if(ntpStruct.hour == timerStruct.onTimeD3[0] && ntpStruct.minute == timerStruct.onTimeD3[1] && (abs(millis()-timerStruct.onIgnoreD3) > INTERVAL_IGNORE_TIMER)) {
      timerStruct.onIgnoreD3 = millis();
      io.setByTimer(3, true);
      if(!io.getRawState(3))
        io.setRawState(3, HIGH);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> taskTimerSchedular -> D3 turned ON due to scheduled timer."));
    }
    if(ntpStruct.hour == timerStruct.offTimeD3[0] && ntpStruct.minute == timerStruct.offTimeD3[1] && (abs(millis()-timerStruct.offIgnoreD3) > INTERVAL_IGNORE_TIMER)) {
      timerStruct.offIgnoreD3 = millis();
      io.setByTimer(3, false);
      if(io.getRawState(3))
        io.setRawState(3, LOW);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> taskTimerSchedular -> D3 turned OFF due to scheduled timer."));
    } 
  }
  if(timerStruct.statusD4 > 0 && timerStruct.weekdaysD4[ntpStruct.weekday] > 0 && NO_OF_DEVICES > 2) {
    if(ntpStruct.hour == timerStruct.onTimeD4[0] && ntpStruct.minute == timerStruct.onTimeD4[1] && (abs(millis()-timerStruct.onIgnoreD4) > INTERVAL_IGNORE_TIMER)) {
      timerStruct.onIgnoreD4 = millis();
      io.setByTimer(4, true);
      if(!io.getRawState(4))
        io.setRawState(4, HIGH);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> taskTimerSchedular -> D4 turned ON due to scheduled timer."));
    }
    if(ntpStruct.hour == timerStruct.offTimeD4[0] && ntpStruct.minute == timerStruct.offTimeD4[1] && (abs(millis()-timerStruct.offIgnoreD4) > INTERVAL_IGNORE_TIMER)) {
      timerStruct.offIgnoreD4 = millis();
      io.setByTimer(4, false);
      if(io.getRawState(4))
        io.setRawState(4, LOW);
      if(mDebug)
        Serial.println(F("[+] SMART: INFO -> taskTimerSchedular -> D4 turned OFF due to scheduled timer."));
    } 
  }
  #endif
}

// Parse Sensor Linking JSON from PubSub
void parseSensorLinkJson(String buf) {
  DynamicJsonDocument doc(JSON_BUF_SIZE*2);
  deserializeJson(doc, buf);
  doc.shrinkToFit();
  if(doc.containsKey(JSON_SMARTID)&& String((const char*)doc[JSON_SMARTID]) == smartSsid
  && doc.containsKey(JSON_TYPE) && String((const char*)doc[JSON_TYPE]) == JSON_TYPE_LINK) {
    if(mDebug) {
      Serial.println(F("[+] SMART: INFO -> SensorLink JSON parsed as follow."));
      serializeJson(doc, Serial);
      Serial.println();
    }
    if(doc[JSON_DEVICE_NO].as<int>() == 1) {
      char buf[JSON_BUF_SIZE];
      linkJson1 = doc;
      serializeJson(doc, buf);
      fsys.saveSensorLink(buf, LINK_SENSOR_1_FILE);
    }
    else if(doc[JSON_DEVICE_NO].as<int>() == 2) {
      char buf[JSON_BUF_SIZE];
      linkJson2 = doc;
      serializeJson(doc, buf);
      fsys.saveSensorLink(buf, LINK_SENSOR_2_FILE);
    }
    else if(doc[JSON_DEVICE_NO].as<int>() == 3) {
      char buf[JSON_BUF_SIZE];
      linkJson3 = doc;
      serializeJson(doc, buf);
      fsys.saveSensorLink(buf, LINK_SENSOR_3_FILE);
    }
    else if(doc[JSON_DEVICE_NO].as<int>() == 4) {
      char buf[JSON_BUF_SIZE];
      linkJson4 = doc;
      serializeJson(doc, buf);
      fsys.saveSensorLink(buf, LINK_SENSOR_4_FILE);
    }
  }
}

// Parse JSON received from PubSub
void parseTimerJson(String buf) {
  DynamicJsonDocument doc(JSON_BUF_SIZE*4);
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

    fsys.saveTimers(buf.c_str());
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
  if(internetAvailable) {
    ntpStruct.hour = ntp.getHours();
    ntpStruct.minute = ntp.getMinutes();
    ntpStruct.second = ntp.getSeconds();
    ntpStruct.weekday = ntp.getDay();
  }
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
  doc.shrinkToFit();
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
void initMesh(uint16_t ch, int qual) {  
  if(mDebug) {
    Serial.print(F("[+] SMART: INFO -> Mesh init with channel: "));
    Serial.println(ch);
    Serial.print(F("[+] SMART: INFO -> Mesh SSID: "));
    serializeJson(confJson[CONF_MESH_SSID], Serial);
    Serial.println();
    Serial.print(F("[+] SMART: INFO -> Mesh PASS: "));
    serializeJson(confJson[CONF_MESH_PASS], Serial);
    Serial.println();
  }
  //mesh.init(MESH_SSID, MESH_PASS, MESH_PORT, WIFI_AP_STA, ch, MESH_HIDDEN);
  mesh.init(confJson[CONF_MESH_SSID].as<const char*>(), confJson[CONF_MESH_PASS].as<const char*>(), MESH_PORT, WIFI_AP_STA, ch, MESH_VISIBLE);
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
  mesh.onReceive(&meshReceiveCallback);
  mesh.onChangedConnections(&changedConCallback);
  mesh.onDroppedConnection(&meshDroppedCallback);
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
  mqtt.setBufferSize(JSON_BUF_SIZE);
  unsigned long oldNow = millis();
  while(!mqtt.connected()) {
    looper();
    if(millis() - oldNow > MQTT_DELAY) {
      internetAvailable = isInternetAvailable();
      oldNow = millis();
      if(internetAvailable) {
        ntp.begin();
        ntp.setTimeOffset(OFFSET_INDIA_GMT);
        //if(mqtt.connect(getSmartSSID())) {
        if(mqtt.connect(getSmartSSID(),getTopicName(TOPIC_STATUS).c_str(),1,RETAIN,setSmartStatus(JSON_STATUS_OFFLINE).c_str())) {    // Will Msg implemented - MQTT
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
          mqtt.subscribe(String((String)"smart/"+String(confJson[CONF_USERNAME].as<const char*>())+"/"+TOPIC_GATEWAY).c_str());    // subscribe to smart/username/gateway
          mqtt.publish(getTopicName(TOPIC_INFO).c_str(), getNodeInfo().c_str(), RETAIN);
          mqtt.publish(getTopicName(TOPIC_STATUS).c_str(), setSmartStatus(JSON_STATUS_ONLINE).c_str(), RETAIN);
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

// Get NodeName or SSID -> E.g. SMART_1A2B3C4D_NoD
const char* getSmartSSID() {
  #ifdef SWITCHING_NODE
    size_t sz = snprintf(NULL, 0, "SMART_%08X_%d", (uint32_t)ESP.getChipId(), NO_OF_DEVICES) + 1;
    char *ssid = (char*)malloc(sz);
    snprintf(ssid, 17, "SMART_%08X_%d", (uint32_t)ESP.getChipId(), NO_OF_DEVICES);
    smartSsid = String(ssid);
    return ssid;
  #endif
  #ifdef SENSOR_NODE
    size_t sz = snprintf(NULL, 0, "SMART_%08X_S", (uint32_t)ESP.getChipId()) + 1;
    char *ssid = (char*)malloc(sz);
    snprintf(ssid, 17, "SMART_%08X", (uint32_t)ESP.getChipId());
    smartSsid = String(ssid);
    return ssid;
  #endif
}

// set Smart Status for MQTT Will and to help app
String setSmartStatus(const char* msg) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  char buf[JSON_BUF_SIZE];
  doc[JSON_TOPIC] = getTopicName(TOPIC_STATUS);
  if(internetAvailable)
    doc[JSON_TO] = JSON_TO_APP;
  else
    doc[JSON_TO] = JSON_TO_GATEWAY;
  doc[JSON_FROM] = JSON_TO_NODE;
  doc[JSON_SMARTID] = smartSsid;
  doc[JSON_TYPE] = JSON_TYPE_STATUS;
  doc[JSON_TYPE_STATUS] = msg;
  doc.shrinkToFit();
  serializeJson(doc, buf);
  if(mqtt.connected()) {
    mqtt.publish(getTopicName(TOPIC_STATUS).c_str(), buf, RETAIN);
  }
  else {
    mesh.sendBroadcast(buf);
  }
  return String(buf);
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
  d[JSON_VERSION] = VERSION;
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
  WiFi.scanDelete();
  WiFi.mode(WIFI_AP_STA);
  WiFi.disconnect();
  if(mDebug)
    Serial.printf("[+] SMART: INFO -> Identifying Channel of SSID: %s\n",ssid);
  delay(100);
  int networks =  WiFi.scanNetworks();
  #ifndef FORCE_MESH
    for(int i=0;i<networks;i++) {
      if(mDebug)
        Serial.printf("[+] SMART: TARGET SCAN -> %s (%d)\n",WiFi.SSID(i).c_str(),WiFi.channel(i)); 
      if(String(WiFi.SSID(i)) == String(ssid)){
        quality = WiFi.RSSI(i);
        isTargetSsidFound = true;
        searchTargetTask.disable();
        sched.deleteTask(searchTargetTask);
        if(mDebug) {
          Serial.printf("[+] SMART: INFO -> TARGET CHANNEL: -> %d\n",WiFi.channel(i));
          Serial.printf("[+] SMART: INFO -> TARGET QUALITY: -> %d\n",quality);
        }
        return WiFi.channel(i);
      }
    }
  #endif
  if(mDebug) {
    Serial.println(F("[+] SMART: ERROR -> TARGET SSID not found!"));
    Serial.printf("[+] SMART: INFO -> TARGET CHANNEL FROM CONF: -> %d\n",confCh);
    Serial.println(F("[+] SMART: INFO -> NOW SCANNING FOR MESH SSID & CHANNEL"));
  }
  // Scan the MESH SSID & CH if TARGET isn't found
  WiFi.scanDelete();
  networks =  WiFi.scanNetworks(false, true);   // scan using blocking method but for HIDDEN SSIDs as well
  for(int i=0;i<networks;i++) {    
    if(mDebug)
      Serial.printf("[+] SMART: MESH SCAN -> %s (%d)\n",WiFi.SSID(i).c_str(),WiFi.channel(i));
    if(String(WiFi.SSID(i)) == "" || String(WiFi.SSID(i)) == confJson[CONF_MESH_SSID].as<const char*>()){
      quality = WiFi.RSSI(i);
      searchTargetTask.restartDelayed(INTERVAL_TARGET_SEARCH * TASK_SECOND);
      if(mDebug) {
        Serial.printf("[+] SMART: INFO -> MESH CHANNEL: -> %d\n",WiFi.channel(i));
        Serial.printf("[+] SMART: INFO -> MESH QUALITY: -> %d\n",quality);
      }
      return WiFi.channel(i);
    }
  }
  quality = MESH_QUALITY_THRESH;
  isTargetSsidFound = false;
  searchTargetTask.restartDelayed(INTERVAL_TARGET_SEARCH * TASK_SECOND);
  //return confCh;
  return 1;
}

// Task to search for target SSID if it's not observed since boot
void taskSearchTargetSSID(void) {
  if(mDebug)
    Serial.println(F("[+] SMART: INFO -> taskSearchTargetSSIDTask -> Searching for target.."));
  mesh.stop();
  channel = getWiFiChannelForSSID((const char*)confJson[CONF_SSID], (int)confJson[CONF_WIFI_CH], quality);
  if(mDebug)
      Serial.println(F("[+] SMART: INFO -> taskSearchTargetSSIDTask -> Task completed, Resuming Mesh!"));
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
    
    isTargetSsidFound = true;           // Also stop scanning for the target SSID as someone already connected! Yaay!
    searchTargetTask.disable();
    sched.deleteTask(searchTargetTask);
    
    if(mDebug) {
      Serial.println(F("[+] SMART: INFO -> checkRootTask -> Disabled searchTargetTask as ROOT is found!"));
    }
  }
  else {
    // If root node itself drops and 'this' is not connected to internet!
    sched.addTask(rootCheckTask);
    rootCheckTask.enableIfNot();
    if(!isInternetAvailable()) {
      isTargetSsidFound = false;
      sched.addTask(searchTargetTask);
      if(!searchTargetTask.isEnabled()) {
        searchTargetTask.restartDelayed(INTERVAL_TARGET_SEARCH * TASK_SECOND);
      }
    }
  }
}

// Check wether the NTP time is in range with user setted time to take motion related control action
bool checkTimeForMotion(uint8_t en_hr, uint8_t en_min, uint8_t ds_hr, uint8_t ds_min) {
  if(ntpStruct.hour >= en_hr || ntpStruct.hour <= ds_hr) {
    if(ntpStruct.hour == en_hr) {
      if(ntpStruct.minute >= en_min) {
        if(mDebug)
          Serial.println(F("[+] SMART: INFO -> CheckTimeForMotion - Within Time Limits!"));
        return true;
      }
    }
    if(ntpStruct.hour == ds_hr) {
      if(ntpStruct.minute <= ds_min) {
        if(mDebug)
          Serial.println(F("[+] SMART: INFO -> CheckTimeForMotion - Within Time Limits!"));
        return true;
      }
    }
    if(mDebug)
      Serial.println(F("[+] SMART: INFO -> CheckTimeForMotion - Within Time Limits!"));
    return true;
  }
  if(mDebug)
    Serial.println(F("[+] SMART: INFO -> CheckTimeForMotion - NOT within Time Limits!"));
  return false;
}

#ifdef SWITCHING_NODE
  void offTimeoutD1(void) {
    if(io.getRawState(1)) {
      io.setBySensor(1, false);
      io.setRawState(1, LOW);
    }
    if(mDebug)
      Serial.println(F("[+] SMART: INFO -> D1 MOTION timed out!"));
  }
  
  void offTimeoutD2(void) {
    if(io.getRawState(2)) {
      io.setBySensor(2, false);
      io.setRawState(2, LOW);
    }
    if(mDebug)
      Serial.println(F("[+] SMART: INFO -> D2 MOTION timed out!"));
  }
  
  void offTimeoutD3(void) {
    if(io.getRawState(3)) {
      io.setBySensor(3, false);
      io.setRawState(3, LOW);
    }
    if(mDebug)
      Serial.println(F("[+] SMART: INFO -> D3 MOTION timed out!"));
  }
  
  void offTimeoutD4(void) {
    if(io.getRawState(4)) {
      io.setBySensor(4, false);
      io.setRawState(4, LOW);
    }
    if(mDebug)
      Serial.println(F("[+] SMART: INFO -> D4 MOTION timed out!"));
  }
#endif
