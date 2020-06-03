/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   30/05/2020
 * INFO     :   Header for accessing SPIFFS for save/load JSON configs
 * ALL RIGHTS RESERVED.
 */

#ifndef SMARTCONSTANTS_H
#define SMARTCONSTANTS_H

#define RST_DLY           3000U

#define MQTT_SERVER_IP    "35.225.15.182"
#define MQTT_SERVER_PORT  "1883"
#define MQTT_DELAY        5000U

// WiFi Manager constants
#define AP_PASS           "12345678"
#define MIN_SIG           10
#define CON_TIMEOUT       30 //10*60

#define CONF_SSID         "confSSID"
#define CONF_PASS         "confPass"
#define CONF_USERNAME     "confUserName"
#define CONF_NODENAME     "confNodeName"
#define CONF_MQTT_IP      "confMqttIp"
#define CONF_MQTT_PORT    "confMqttPort"
#define CONF_WIFI_CH      "confWifiChannel"

// Mesh constants
#define MESH_SSID         "SMART-Mesh"
#define MESH_PASS         "mesh@smart_v3"
#define MESH_PORT         4321

// smartWebServer constants
#define SMART_PASS        AP_PASS

#endif
