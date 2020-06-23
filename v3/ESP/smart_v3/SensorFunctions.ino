
#ifdef SENSOR_NODE

void initSensorHardware(void) {
  pinMode(DHT_PIN, INPUT_PULLUP);
  pinMode(MOTION_PIN, INPUT);
  dht.begin();
  attachInterrupt(MOTION_PIN, motionIsr, CHANGE);
}

float getTemp(void) {
  return (float)dht.readTemperature();
}

float getHum(void) {
  return (float)dht.readHumidity();
}

uint16_t getLightRaw(void) {
  return (uint16_t)analogRead(LIGHT_PIN);
}

uint16_t getLight(void) {
  return (uint16_t)map(getLightRaw(),0,1024,0,100);
}

ICACHE_RAM_ATTR void motionIsr(void) {
  flagMotionIsr = true;
}

void taskGetSensorValues(void) {
  // Save old values for comparision for thresholding
  dhtTempLast = dhtTemp;
  dhtHumLast = dhtHum;
  lightLast = light;
  // Get new values
  dhtTemp = dht.readTemperature();
  dhtHum = dht.readHumidity();
  light = getLight();
  lightRaw = getLightRaw();
  motionState = digitalRead(MOTION_PIN);

  if(mDebug)
    Serial.printf("[+] SMART: getSensorValuesTask -> T: %.1f\tH: %.1f\tL: %u\tLR: %u\n",dhtTemp,dhtHum,light,lightRaw);

  broadcastSensorData();
}

void broadcastSensorData(void) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  doc[JSON_SMARTID] = smartSsid;
  doc[JSON_DEVICE_TYPE] = JSON_DEVICE_SENSOR;
  doc[JSON_TYPE] = JSON_TYPE_BROADCAST;
  doc[JSON_SENSOR_TEMP] = dhtTemp;
  doc[JSON_SENSOR_HUM] = dhtHum;
  doc[JSON_SENSOR_LIGHT] = light;
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

void conditionalBroadcastSensorData(void) {
  if(!isnan(dhtTemp) && !isnan(dhtHum)) {
    if((abs(light-lightLast) >= THRESH_LIGHT_CHANGE) || (abs(dhtTemp-dhtTempLast) >= THRESH_TEMP_CHANGE) || (abs(dhtHum-dhtHumLast) >= THRESH_HUM_CHANGE))
      broadcastSensorData();
  }
}

#endif
