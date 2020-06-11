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

// System Configs for compile-time setting
#define SWITCHING_NODE          // Enable for main smart node
//#define SENSOR_NODE           // Enable for sensor nodes (this should be work in Mesh Only)
//#define FORCE_MESH            // Enable to force the node in mesh mode
//#define FORCE_ROOT            // Enable to force the node as ROOT
#define NO_OF_DEVICES           4

#define RST_DLY           3000U
#define BOOT_DLY          2000U
#define DEBOUNCE_DLY      200U   // ms

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
#define MESH_SSID                 "SMART-Mesh"
#define MESH_PASS                 "mesh@smart_v3"
#define MESH_PORT                 4321
#define MESH_HIDDEN               1
#define MESH_QUALITY_THRESH       -75   // dBm
#define INTERVAL_ROOT_CHECK       30    // Seconds
#define INTERVAL_TARGET_SEARCH    60    // Seconds

// smartWebServer constants
#define SMART_PASS        "12345678"    // Change later

// JSON constants
#define JSON_BUF_SIZE             512u
#define JSON_TO                   "to"
#define JSON_TO_GATEWAY           "gateway"
#define JSON_TO_APP               "app"
#define JSON_SMARTID              "smartId"
#define JSON_NODENAME             "nodeName"
#define JSON_DEVICE_TYPE          "deviceType"
#define JSON_DEVICE_SWITCH        "switch"
#define JSON_DEVICE_SENSOR        "sensor"
#define JSON_TYPE                 "type"
#define JSON_TYPE_DATA            "data"
#define JSON_TYPE_STATE           "state"
#define JSON_TYPE_INFO            "info"
#define JSON_NoD                  "NoD"

// IO configuration
#if NO_OF_DEVICES == 4      // This Configuration is ONLY for 4 Devices
  #define OE_PIN            D0
  #define CLK_PIN           D3
  #define LATCH_PIN         D4
  #define DATA_PIN          D7
  #define SW1               D1
  #define SW2               D2
  #define SW3               D5
  #define SW4               D6
#endif

#endif
