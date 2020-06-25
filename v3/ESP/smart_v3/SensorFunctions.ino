
#ifdef SENSOR_NODE

void initSensorHardware(void) {
  pinMode(MOTION_PIN, INPUT);
  attachInterrupt(MOTION_PIN, motionIsr, CHANGE);
}

ICACHE_RAM_ATTR void motionIsr(void) {
  flagMotionIsr = true;
}

void taskGetSensorValues(void) {
  motionState = digitalRead(MOTION_PIN);
  if(mDebug)
    Serial.printf("[+] SMART: getSensorValuesTask -> Motion: %d",motionState);
  broadcastSensorData();
}

void broadcastSensorData(void) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  doc[JSON_SMARTID] = smartSsid;
  doc[JSON_DEVICE_TYPE] = JSON_DEVICE_SENSOR;
  doc[JSON_TYPE] = JSON_TYPE_BROADCAST;
  doc[JSON_SENSOR_MOTION] = motionState;
  doc.shrinkToFit();

  char buf[JSON_BUF_SIZE];
  serializeJson(doc,buf);
  if(mqtt.connected()) {
    mqtt.publish(getTopicName(TOPIC_SENSOR_VALUE).c_str(), buf);
  }
  mesh.sendBroadcast(buf);
  if(mDebug) {
    Serial.println(F("[+] SMART: INFO -> Broadcasting following SENSOR packet.."));
    Serial.println(buf);
  }
}

#endif
