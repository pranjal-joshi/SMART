/**
SMART v4 - With Alexa Webhook
Author: Pranjal Joshi
*/

#include <Arduino.h>
#include <ArduinoOTA.h>
#include <EEPROM.h>

#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>

#include <ESP8266HTTPClient.h>
#include "ConfigureWebServer.h"

#include <WiFiClient.h>

#include "creds.h"
#include "Timer.h"

#define DEBUG 1

unsigned long off_timeout = int(1000 * 60 * 2);

ESP8266WiFiMulti WiFiMulti;
Timer timer(MILLIS);
ConfigureWebServer configServer;

//  For NodeMCU
unsigned int sensor_pin = D2;
unsigned int led_pin = LED_BUILTIN;

//  For ESP-01
// unsigned int sensor_pin = 2;

byte state = LOW;
unsigned int eeprom_addr = 10;
bool otaBegan = false;

void sendGetRequest(const String);

void setup() {

  pinMode(sensor_pin, INPUT);
  pinMode(led_pin, OUTPUT);
  digitalWrite(led_pin, HIGH);

  Serial.begin(115200);
  EEPROM.begin(512);
  state = EEPROM.read(eeprom_addr);
  if(state > LOW) {
    state = HIGH;
  }

  Serial.println();
  Serial.println();
  Serial.println();

  for (uint8_t t = 4; t > 0; t--) {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  Serial.printf("[DEVICE] %s\n", device_id);
  Serial.printf("[DEVICE] Initial State: %d\n", state);

  // Disabled for a web server test
  // WiFi.mode(WIFI_STA);
  // WiFiMulti.addAP(ssid1, pass1);
  // WiFiMulti.addAP(ssid2, pass2);
  configServer.setDebug(true);
  configServer.begin(ssid_provision, pass_provision, false);
  configServer.showWifiNetworks();
}

void loop() {
  // wait for WiFi connection
  if ((WiFiMulti.run() == WL_CONNECTED)) {
    #ifdef DEBUG
      if (timer.state() == RUNNING)
        Serial.printf("[TIMER] Elapsed millis = %lu\n", timer.read());
    #endif
    readSensorValue();
    if (timer.state() == RUNNING && timer.read() >= off_timeout) {
      sendGetRequest(invoke_endpoint_no_motion);
      timer.stop();
    }
    beginArduinoOTA();
    ArduinoOTA.handle();
  }
  delay(500);
}

void readSensorValue() {
  byte val = digitalRead(sensor_pin);   // read sensor value
  #ifdef DEBUG
    Serial.printf("[SENSOR] Value = %d\n", val);
  #endif
  if (val == HIGH) {           // check if the sensor is HIGH    
    if (state == LOW) {
      Serial.println("[SENSOR] Motion detected!"); 
      state = HIGH;       // update variable state to HIGH
      digitalWrite(led_pin, !state);
      EEPROM.write(eeprom_addr, state);
      EEPROM.commit();
      sendGetRequest(invoke_endpoint_motion);
      timer.stop();
    }
  } 
  else {      
    if (state == HIGH){
      Serial.println("[SENSOR] Motion stopped!");
      state = LOW;       // update variable state to LOW
      digitalWrite(led_pin, !state);
      EEPROM.write(eeprom_addr, state);
      EEPROM.commit(); 
      timer.start();
    }
  }
}

void sendGetRequest(const String url) {
  WiFiClient client;
  HTTPClient http;

  Serial.print("[HTTP] begin...\n");
  if (http.begin(client, url)) {  // HTTP

    Serial.print("[HTTP] GET...\n");
    // start connection and send HTTP header
    int httpCode = http.GET();

    // httpCode will be negative on error
    if (httpCode > 0) {
      // HTTP header has been send and Server response header has been handled
      Serial.printf("[HTTP] GET... code: %d\n", httpCode);

      // file found at server
      if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
        String payload = http.getString();
        Serial.println(payload);
      }
    } else {
      Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
    }

    http.end();
  } else {
    Serial.printf("[HTTP} Unable to connect\n");
  }
}

void beginArduinoOTA(void) {
  if(!otaBegan) {
    #ifdef DEBUG
      ArduinoOTA.onStart([]() {
        Serial.println("[OTA] Start");
      });
      ArduinoOTA.onEnd([]() {
        Serial.println("\n[OTA] End");
      });
      ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
        Serial.printf("[OTA] Progress: %u%%\r", (progress / (total / 100)));
      });
      ArduinoOTA.onError([](ota_error_t error) {
        Serial.printf("[OTA] Error[%u]: ", error);
        if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
        else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
        else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
        else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
        else if (error == OTA_END_ERROR) Serial.println("End Failed");
      });
    #endif
    ArduinoOTA.setHostname(device_id);
    ArduinoOTA.setPort(device_port);
    ArduinoOTA.begin();
    otaBegan = true;
  }
}