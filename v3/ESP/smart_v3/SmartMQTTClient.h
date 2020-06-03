/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   03/06/2020
 * INFO     :   Header for handling MQTT with cloud
 * ALL RIGHTS RESERVED.
 */

#ifndef SMARTMQTTCLIENT_H
#define SMARTMQTTCLIENT_H

#include <PubSubClient.h>
#include <WiFiClient.h>

class SmartMQTTClient {
  public:
    SmartMQTTClient(void);
    void setDebug(bool d);
    PubSubClient getPubSubObject(void);
    void begin(const char* ip, unsigned int port, std::function<void (char*, byte*, unsigned int)>callback);
    void login(const char* u, const char* p);
    void authorize(const char* mu, const char* mp);
    bool isConnected(void);
    void loop(void);
  private:
};

#endif
