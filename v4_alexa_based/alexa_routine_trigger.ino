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
#include "ConfigLoader.h"

#include <WiFiClient.h>

#include "creds.h"
#include "Timer.h"

#define DEBUG 1

unsigned long off_timeout = int(1000 * 60 * 2);

ESP8266WiFiMulti WiFiMulti;
Timer timer(MILLIS);
ConfigureWebServer configServer;
ConfigLoader configLoader;

//  For NodeMCU
unsigned int sensor_pin = D2;
unsigned int led_pin = LED_BUILTIN;

//  For ESP-01
// unsigned int sensor_pin = 2;

byte state = LOW;
bool otaBegan = false;

String config_ssid, config_pass, config_location, config_url_on, config_url_off;
int config_timeout;
bool config_fs_err_read = false;
bool config_fs_err_write = false;

void sendGetRequest(const String);

void setup() {

  pinMode(sensor_pin, INPUT);
  pinMode(led_pin, OUTPUT);
  digitalWrite(led_pin, HIGH);

  Serial.begin(115200);

  configLoader.setDebug(true);
  configLoader.begin();
  state = configLoader.getLastMotionState();

  Serial.println();
  Serial.println();
  Serial.println();

  for (uint8_t t = 4; t > 0; t--) {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  // configLoader.getConfig(&deviceConfigData);
  loadConfigData();

  Serial.printf("[DEVICE] ID: %ul\n", ESP.getChipId());
  Serial.printf("[DEVICE] Location: %s\n", config_location);
  Serial.printf("[DEVICE] Initial State: %d\n", state);

  if(config_fs_err_read) {
    configServer.setDebug(true);
    configServer.begin(ssid_provision, pass_provision, "smartmotion", false);
    configServer.showWifiNetworks();
  }
  else {
    WiFi.mode(WIFI_STA);
    WiFiMulti.addAP(config_ssid.c_str(), config_pass.c_str());
  }

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
    configServer.loop();
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
      configLoader.setLastMotionState(state);
      // EEPROM.write(eeprom_addr, state);
      // EEPROM.commit();
      sendGetRequest(invoke_endpoint_motion);
      timer.stop();
    }
  } 
  else {      
    if (state == HIGH){
      Serial.println("[SENSOR] Motion stopped!");
      state = LOW;       // update variable state to LOW
      digitalWrite(led_pin, !state);
      configLoader.setLastMotionState(state);
      // EEPROM.write(eeprom_addr, state);
      // EEPROM.commit(); 
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

void loadConfigData(void) {
  config_ssid = configLoader.getConfig(FILE_SSID);
  config_pass = configLoader.getConfig(FILE_PASS);
  config_location = configLoader.getConfig(FILE_LOCATION);
  config_timeout = String(configLoader.getConfig(FILE_TIMEOUT)).toInt();
  config_url_on = configLoader.getConfig(FILE_URL_ON);
  config_url_off = configLoader.getConfig(FILE_URL_OFF);

  #ifdef DEBUG 
    Serial.printf("[CONFIG] Filename: %s\t\t->\t", FILE_SSID);
    Serial.println(config_ssid);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t", FILE_PASS);
    Serial.println(config_pass);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t", FILE_LOCATION);
    Serial.println(config_location);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t", FILE_TIMEOUT);
    Serial.println(config_timeout);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t", FILE_URL_ON);
    Serial.println(config_url_on);
    Serial.printf("[CONFIG] Filename: %s\t\t->\t", FILE_URL_OFF);
    Serial.println(config_url_off);
  #endif
  
  if (config_ssid == "" || config_pass == "" || config_location == "" || config_timeout < 1 || config_timeout > 60 || config_url_on == "" || config_url_off == "") {
    config_fs_err_read = true;
    // terminate strings with null-char to avoid printf crashing everywhere!
    config_ssid = "";
    config_pass = "";
    config_location = "SmartMotion";
    config_url_on = "";
    config_url_off = "";
    #ifdef DEBUG
      Serial.println("[CONFIG] Validation Error in getConfig!");
    #endif
  }

  #ifdef DEBUG
    Serial.printf("[CONFIG] Filename: %s\t\t->\t%s\n", "fs_error_read", btoa(config_fs_err_read));
    Serial.printf("[CONFIG] Filename: %s\t\t->\t%s\n", "fs_error_write", btoa(config_fs_err_write));
  #endif
}