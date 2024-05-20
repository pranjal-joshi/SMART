/**
SMART v4 - With Alexa Webhook
Author: Pranjal Joshi
*/

#include <Arduino.h>

#include <ESP8266WiFi.h>
#include <WiFiClient.h>

#include "ConfigureWebServer.h"
#include "ConfigLoader.h"

#include "creds.h"
#include "Timer.h"

//  For NodeMCU
#ifdef NODEMCU
  unsigned int btn_pin = D1;
  unsigned int sensor_pin = D2;
  unsigned int led_pin = LED_BUILTIN;
#endif
#ifdef ESP01
  unsigned int btn_pin = 0;
  unsigned int sensor_pin = 2;
  unsigned int led_pin = LED_BUILTIN;
#endif

unsigned long off_timeout = (unsigned long)(1000 * 60 * 5);
Timer timer(MILLIS);
ezLED led(led_pin, CTRL_CATHODE);
ConfigureWebServer configServer;
ConfigLoader configLoader;

byte state = LOW;
bool isFadedIn = false;

String config_ssid, config_pass, config_location, config_url_on, config_url_off;
String config_sensor_state = "true";
unsigned long config_timeout;
bool config_fs_err_read = false;
bool config_fs_err_write = false;
String hostname = "smartmotion";

void sendGetRequest(const String, bool isEnabled);

void setup() {

  led.turnOFF();
  pinMode(sensor_pin, INPUT);

  #ifdef DEBUG
    Serial.begin(115200);
    configServer.setDebug(true);
    configLoader.setDebug(true);
  #endif

  configLoader.begin();
  state = configLoader.getLastMotionState();

  #ifdef DEBUG
    Serial.println();
    Serial.println();
    Serial.println();

    for (uint8_t t = 4; t > 0; t--) {
      Serial.printf("[SETUP] WAIT %d...\n", t);
      Serial.flush();
      delay(1000);
    }
  #endif

  loadConfigData();

  buttonSetup();

  #ifdef DEBUG
    Serial.printf("[DEVICE] ID: %ul\n", ESP.getChipId());
    Serial.printf("[DEVICE] Location: %s\n", config_location);
    Serial.printf("[DEVICE] Hostname: %s\n", hostname);
    Serial.printf("[DEVICE] Initial State: %d\n", state);
  #endif

  if(config_fs_err_read) {
    #ifdef DEBUG
      Serial.println("[DEVICE] Mode: Provisioning & Configuration");
    #endif
    configServer.begin(ssid_provision, pass_provision, hostname, false, true);
    configServer.showWifiNetworks();
  }
  else {
    #ifdef DEBUG
      Serial.println("[DEVICE] Mode: Motion Sensing");
    #endif
    WiFi.mode(WIFI_STA);
    WiFi.begin(config_ssid.c_str(), config_pass.c_str());
    while(WiFi.status() != WL_CONNECTED) {
      delay(10);
      buttonLoop();
      led.loop();
    };
    #ifdef DEBUG
      Serial.print("[DEVICE] IP address: ");
      Serial.println(WiFi.localIP());
    #endif
    configServer.begin(ssid_provision, pass_provision, hostname, false, false);
    configServer.showWifiNetworks();
  }

}

void loop() {
  // wait for WiFi connection
  if ((WiFi.status() == WL_CONNECTED)) {
    static unsigned long last = millis();
    if (millis() - last > 500) {
        last = millis();
        #ifdef DEBUG
          if (timer.state() == RUNNING)
            Serial.printf("[TIMER] Elapsed millis = %ul\n", timer.read());
        #endif
      if(alexaSensingEnabled) {
        readSensorValue();
      }
      if (timer.state() == RUNNING && timer.read() >= off_timeout) {
        sendGetRequest(config_url_off, alexaSensingEnabled);
        timer.stop();
      }
    }
    configServer.loop();
  }
  else {
    delay(10);
  }
  buttonLoop();
  led.loop();
}

void readSensorValue() {
  byte val = digitalRead(sensor_pin);   // read sensor value
  #ifdef DEBUG
    Serial.printf("[SENSOR] Value = %d\n", val);
  #endif
  if (val == HIGH) {           // check if the sensor is HIGH    
    if (state == LOW) {
      #ifdef DEBUG
        Serial.println("[SENSOR] Motion detected!"); 
      #endif
      state = HIGH;       // update variable state to HIGH
      #ifdef NODEMCU
        led.turnON();
      #endif
      configLoader.setLastMotionState(state);
      sendGetRequest(config_url_on, alexaSensingEnabled);
      timer.stop();
    }
  } 
  else {      
    if (state == HIGH){
      #ifdef DEBUG
        Serial.println("[SENSOR] Motion stopped!");
      #endif
      state = LOW;       // update variable state to LOW
      #ifdef NODEMCU
        led.turnOFF();
      #endif
      configLoader.setLastMotionState(state);
      timer.start();
    }
  }
}

void sendGetRequest(const String url, bool isEnabled) {
  WiFiClient client;
  HTTPClient http;

  if(!isEnabled) {
    #ifdef DEBUG
      Serial.println("[HTTP] GET Call disabled by Alexa!");
    #endif
    return;
  }

  if (http.begin(client, url)) {  // HTTP

    // start connection and send HTTP header
    int httpCode = http.GET();

    #ifdef DEBUG
      // httpCode will be negative on error
      if (httpCode > 0) {
        // HTTP header has been send and Server response header has been handled
        Serial.printf("[HTTP] GET... code: %d\n", httpCode);
        // file found at server
        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
          String payload = http.getString();
          Serial.println(payload);
        }
      }
      else {
        Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
      }
    #endif
    http.end();
  }
  else {
    #ifdef DEBUG
      Serial.printf("[HTTP} Unable to connect\n");
    #endif
  }
}

void loadConfigData(void) {
  config_ssid = configLoader.getConfig(FILE_SSID);
  config_pass = configLoader.getConfig(FILE_PASS);
  config_location = configLoader.getConfig(FILE_LOCATION);
  config_timeout = configLoader.getConfig(FILE_TIMEOUT).toInt();
  config_url_on = configLoader.getConfig(FILE_URL_ON);
  config_url_off = configLoader.getConfig(FILE_URL_OFF);
  config_sensor_state = configLoader.getConfig(FILE_SENSOR_STATE);

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
    Serial.printf("[CONFIG] Filename: %s\t->\t", FILE_SENSOR_STATE);
    Serial.println(config_sensor_state);
  #endif
  
  if (config_ssid == "" || config_pass == "" || config_location == "" || config_timeout < 1 || config_timeout > 60 || config_url_on == "" || config_url_off == "") {
    config_fs_err_read = true;
    // terminate strings with null-char to avoid printf crashing everywhere!
    config_ssid = "";
    config_pass = "";
    config_location = "SmartMotion";
    config_url_on = "";
    config_url_off = "";
    config_sensor_state = "true";
    #ifdef DEBUG
      Serial.println("[CONFIG] Validation Error in getConfig!");
    #endif
  }
  else {
    off_timeout = (unsigned long)(1000 * 60 * config_timeout);
  }

  hostname = config_location;
  hostname.toLowerCase();
  hostname.replace(" ","");
  hostname.replace("-","");
  hostname.replace("_","");

  #ifdef DEBUG
    Serial.printf("[CONFIG] Filename: %s\t->\t%s\n", "fs_error_read", btoa(config_fs_err_read));
    Serial.printf("[CONFIG] Filename: %s\t->\t%s\n", "fs_error_write", btoa(config_fs_err_write));
  #endif
}