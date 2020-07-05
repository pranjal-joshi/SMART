
#ifdef SENSOR_NODE

void initSensorHardware(void) {
  pinMode(MOTION_PIN, INPUT_PULLUP);
  attachInterrupt(MOTION_PIN, motionIsr, CHANGE);
}

ICACHE_RAM_ATTR void motionIsr(void) {
  flagMotionIsr = true;
}

void taskGetSensorValues(void) {
  motionState = digitalRead(MOTION_PIN);
  if(mDebug) {
    sensorInitDebug();
    Serial.printf("[+] SMART: getSensorValuesTask -> Motion: %d\n",motionState);
    sensorEndDebug();
  }
  broadcastSensorData();
}

void broadcastSensorData(void) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  doc[JSON_TOPIC] = getTopicName(TOPIC_SENSOR_VALUE);
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
    sensorInitDebug();
    Serial.println(F("[+] SMART: INFO -> Broadcasting following SENSOR packet.."));
    Serial.println(buf);
    sensorEndDebug();
  }
}

void sensorInitDebug(void) {
  pinMode(1, FUNCTION_0);
  pinMode(3, FUNCTION_0);
  Serial.begin(115200);
}

void sensorEndDebug(void) {
  Serial.flush();
  Serial.end();
  pinMode(1, FUNCTION_3);
  pinMode(3, FUNCTION_4);
  pinMode(MOTION_PIN, INPUT_PULLUP);
}

#endif
