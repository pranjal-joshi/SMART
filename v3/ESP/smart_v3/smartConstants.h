/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   30/05/2020
 * INFO     :   Header for accessing SPIFFS for save/load JSON configs
 * ALL RIGHTS RESERVED.
 */

#ifndef SMARTCONSTANTS_H
#define SMARTCONSTANTS_H

// Master serial debug control
#define mDebug            true

#define RST_DLY           3000U
#define BOOT_DLY          2000U

#define MQTT_SERVER_IP    "35.225.15.182"
#define MQTT_SERVER_PORT  "1883"
#define MQTT_DELAY        5000U
#define RETAIN            true

// PubSub topics and subscriptions
#define TOPIC_TEST          "smart/dev"

// SmartFileSystem JSON key names
#define CONF_SSID         "confSSID"
#define CONF_PASS         "confPass"
#define CONF_USERNAME     "confUserName"
#define CONF_NODENAME     "confNodeName"
#define CONF_MQTT_IP      "confMqttIp"
#define CONF_MQTT_PORT    "confMqttPort"
#define CONF_WIFI_CH      "confWifiChannel"

// Mesh constants
#define MESH_SSID             "SMART-Mesh"
#define MESH_PASS             "mesh@smart_v3"
#define MESH_PORT             4321
#define MESH_HIDDEN           1
#define MESH_QUALITY_THRESH   -75   // dBm
#define INTERVAL_ROOT_CHECK   30    // Seconds

// smartWebServer constants
#define SMART_PASS        "12345678"    // Change later

// JSON constants
#define JSON_SMARTID      "smartId"
#define JSON_TYPE         "type"
#define JSON_DATA         "data"
#define JSON_STATE        "state"

// System Configs for compile-time setting
#define SWITCHING_NODE          // Enable for main smart node
//#define SENSOR_NODE           // Enable for sensor nodes (this should be work in Mesh Only)
//#define FORCE_MESH            // Enable to force the node in mesh mode
//#define FORCE_ROOT            // Enable to force the node as ROOT
#define NO_OF_DEVICES           4

#endif
