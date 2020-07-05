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
#ifndef SWITCHING_NODE
  #define SENSOR_NODE           // Enable for sensor nodes
#endif
//#define FORCE_MESH            // Enable to force the node in mesh mode
//#define FORCE_ROOT            // Enable to force the node as ROOT
#define NO_OF_DEVICES           4

#define OFFSET_INDIA_GMT        19800

#define RST_DLY                 3000U
#define BOOT_DLY                2000U
#define DEBOUNCE_DLY            100U   // ms

#define MQTT_SERVER_IP          "35.225.15.182"
#define MQTT_SERVER_PORT        "1883"
#define MQTT_DELAY              5000U
#define RETAIN                  true

// PubSub topics and subscriptions
#define TOPIC_TEST              "smart/dev"
#define TOPIC_GATEWAY           "gateway"
#define TOPIC_INFO              "info"
#define TOPIC_SENSOR_VALUE      "sensor/value"
#define TOPIC_USERNAME_WILD     "#"
#define TOPIC_STATUS            "status"

// OTA Update config
#define OTA_USER                "smart_admin"
#define OTA_PASS                "smart_pass"
#define OTA_PATH                "ota"
#define OTA_PORT                80

// SmartFileSystem JSON key names
#define CONF_SSID               "confSSID"
#define CONF_PASS               "confPass"
#define CONF_USERNAME           "confUserName"
#define CONF_NODENAME           "confNodeName"
#define CONF_MQTT_IP            "confMqttIp"
#define CONF_MQTT_PORT          "confMqttPort"
#define CONF_WIFI_CH            "confWifiChannel"
#define CONF_MESH_SSID          "confMeshSSID"
#define CONF_MESH_PASS          "confMeshPass"

// Mesh constants
#define MESH_SSID                 "SMART-Mesh"
#define MESH_PASS                 "mesh@smart_v3"
#define MESH_PORT                 4321
#define MESH_HIDDEN               1
#define MESH_VISIBLE              0
#define MESH_QUALITY_THRESH       -85   // dBm
#define INTERVAL_ROOT_CHECK       30    // Seconds
#define INTERVAL_TARGET_SEARCH    60    // Seconds
#define INTERVAL_NTP_BROADCAST    61    // Seconds
#define INTERVAL_GET_NTP          1     // Seconds
#define INTERVAL_TIMER_SCHED      0.4   // Seconds
#define INTERVAL_SWITCHING_TIME   200   // mS
#define INTERVAL_IGNORE_TIMER     60*1000//mS
#define INTERVAL_GET_SENSOR       10    // Seconds
#define INTERVAL_OTA_WAIT         10*60*1000  // 10 Minutes

// smartWebServer constants
#define SMART_PASS                "12345678"    // Change later

// JSON constants
#define JSON_BUF_SIZE             512u
#define JSON_TO                   "to"
#define JSON_FROM                 "from"
#define JSON_TO_GATEWAY           "gateway"
#define JSON_TO_APP               "app"
#define JSON_TO_NODE              "node"
#define JSON_NODEID               "nodeId"
#define JSON_SMARTID              "smartId"
#define JSON_NODENAME             "nodeName"
#define JSON_DEVICE_TYPE          "deviceType"
#define JSON_DEVICE_SWITCH        "switch"
#define JSON_DEVICE_SENSOR        "sensor"
#define JSON_DEVICE_NO            "no"
#define JSON_TYPE                 "type"
#define JSON_TYPE_DATA            "data"
#define JSON_TYPE_BROADCAST       "bcast"
#define JSON_TYPE_STATE           "state"
#define JSON_TYPE_STATE_REQ       "state_req"
#define JSON_TYPE_INFO            "info"
#define JSON_TYPE_FACT_RST        "factory_reset"
#define JSON_TYPE_SOFT_RST        "soft_reset"
#define JSON_TYPE_NTP             "ntp"
#define JSON_TYPE_TIMER           "timer"
#define JSON_TYPE_LINK            "link"
#define JSON_TYPE_OTA             "ota"
#define JSON_TYPE_STATUS          "status"
#define JSON_TYPE_VECTOR_LINK     "vector_link"
#define JSON_NTP_HOUR             "hour"
#define JSON_NTP_MINUTE           "minute"
#define JSON_NTP_SECOND           "second"
#define JSON_NTP_WEEKDAY          "weekday"
#define JSON_NoD                  "NoD"
#define JSON_TOPIC                "topic"
#define JSON_ENABLE               "enable"
#define JSON_DISABLE              "disable"
#define JSON_SENSOR_MOTION        "motion"
#define JSON_SENSOR_TIMEOUT       "timeout"
#define JSON_SENSOR_EN_HR         "eh"
#define JSON_SENSOR_EN_MIN        "em"
#define JSON_SENSOR_DS_HR         "dh"
#define JSON_SENSOR_DS_MIN        "dm"
#define JSON_STATUS_ONLINE        "online"
#define JSON_STATUS_OFFLINE       "offline"
#define JSON_STATUS_BUSY          "busy"

// Switching IO configuration
#ifdef SWITCHING_NODE
  #if NO_OF_DEVICES == 4      // This Configuration is ONLY for 4 Devices
    #define OE_PIN            D0
    #define CLK_PIN           D3
    #define LATCH_PIN         D4
    #define DATA_PIN          D7
    #define SW1               D1
    #define SW2               D2
    #define SW3               D5
    #define SW4               D6
    #define SNS1              SW1
    #define SNS2              SW2
    #define SNS3              SW3
    #define SNS4              SW4
  #endif
  #if NO_OF_DEVICES == 2
    #define SW1               5       // GPIO - ESP01
    #define SW2               3       // GPIO - ESP01 - FUNCTION_3 (RX)
    #define SNS1              SW1
    #define SNS2              SW2
    #define R1                1       // GPIO - ESP01 - Relay Active Low - LOW = BOOT FAILS - FUNCTION_3 (TX)
    #define R2                2       // GPIO - ESP01 - Relay Active Low - LOW = BOOT FAILS
  #endif
  #if NO_OF_DEVICES == 1
    #define SW1               5       // GPIO - ESP01
    #define SNS1              SW1
    #define R1                2       // GPIO - ESP01 - Relay Active Low - LOW = BOOT FAILS
  #endif
#endif

// Sensor IO configuration
#ifdef SENSOR_NODE
  #define MOTION_PIN          3 // RX of ESP01 as GPIO (FUNCTION_3) - NOT digitalPin
#endif
typedef struct {
  int hour;
  int minute;
  int second;
  int weekday;
} SmartNtpStruct;

typedef struct {
    uint8_t onTimeD1[3] = {0,0,0};      //H,M,S
    uint8_t offTimeD1[3] = {0,0,0};     //H,M,S
    uint8_t weekdaysD1[7] = {0,0,0,0,0,0,0};    //0-6
    uint8_t statusD1 = 0;    //enable/disable
    unsigned long onIgnoreD1 = 0;
    unsigned long offIgnoreD1 = 0;
  
    uint8_t onTimeD2[3] = {0,0,0};      //H,M,S
    uint8_t offTimeD2[3] = {0,0,0};     //H,M,S
    uint8_t weekdaysD2[7] = {0,0,0,0,0,0,0};    //0-6
    uint8_t statusD2 = 0;    //enable/disable
    unsigned long onIgnoreD2 = 0;
    unsigned long offIgnoreD2 = 0;
  
    uint8_t onTimeD3[3] = {0,0,0};      //H,M,S
    uint8_t offTimeD3[3] = {0,0,0};     //H,M,S
    uint8_t weekdaysD3[7] = {0,0,0,0,0,0,0};    //0-6
    uint8_t statusD3 = 0;    //enable/disable
    unsigned long onIgnoreD3 = 0;
    unsigned long offIgnoreD3 = 0;
    
    uint8_t onTimeD4[3] = {0,0,0};      //H,M,S
    uint8_t offTimeD4[3] = {0,0,0};     //H,M,S
    uint8_t weekdaysD4[7] = {0,0,0,0,0,0,0};    //0-6
    uint8_t statusD4 = 0;    //enable/disable
    unsigned long onIgnoreD4 = 0;
    unsigned long offIgnoreD4 = 0;
} SmartTimerStruct;


// TLS certificates - SHA1 Broker Fingerprint
//#define fingerprint_smart = "7D 43 2C 71 10 CF 74 33 7D C3 3F D1 1C C9 65 E8 CF 7E 56 73";


// TLS certificates - SHA1 CA Fingerprint
//#define fingerprint_ca = "69 12 52 58 AF 41 CA 53 64 9F 19 3D 86 B9 96 32 9C 54 E7 D8";

#endif
