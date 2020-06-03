/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   03/06/2020
 * INFO     :   Class for handling MQTT with cloud
 * ALL RIGHTS RESERVED.
 */

#include "SmartMQTTClient.h"
#include "SmartConstants.h"
#include "SmartFileSystem.h"

bool SMC_DEBUG = false;

String user,pass;
String mqttUser, mqttPass;

WiFiClient wiCli;
static PubSubClient mqtt(wiCli);

SmartMQTTClient::SmartMQTTClient(void) {
  // Empty constructor
  user = "";
  pass = "";
  mqttUser = "";
  mqttPass = "";
}

void SmartMQTTClient::setDebug(bool d) {
  SMC_DEBUG = d;
}

// whenever additional operations to be performed
PubSubClient SmartMQTTClient::getPubSubObject(void) {
  return mqtt;
}

// Use the callback function from main file so that variable passing is not required
void SmartMQTTClient::begin(const char* ip, unsigned int port, std::function<void (char*, byte*, unsigned int)>callback) {
  Serial.println(F("[+] SmartMQTTClient: INFO -> MQTT Configuration is as follow:"));
  Serial.printf("[+] SmartMQTTClient: MQTT IP -> %s MQTT PORT -> %d",ip,port);
  mqtt.setServer(ip,port);
  mqtt.setCallback(callback);
}

void SmartMQTTClient::login(const char* u, const char* p) {
  user = (String)u;
  pass = (String)p;
}

void SmartMQTTClient::authorize(const char* mu, const char* mp) {
  mqttUser = (String)mu;
  mqttPass = (String)mp;
}

bool SmartMQTTClient::isConnected(void) {
  return mqtt.connected();
}

void SmartMQTTClient::loop(void) {
  mqtt.loop();
}
