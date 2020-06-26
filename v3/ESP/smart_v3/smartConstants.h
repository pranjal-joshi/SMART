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

// smartWebServer constants
#define SMART_PASS                "12345678"    // Change later

// JSON constants
#define JSON_BUF_SIZE             512u
#define JSON_TO                   "to"
#define JSON_FROM                 "from"
#define JSON_TO_GATEWAY           "gateway"
#define JSON_TO_APP               "app"
#define JSON_TO_NODE              "node"
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
#endif

// Sensor IO configuration
#ifdef SENSOR_NODE
  #define MOTION_PIN                D1
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


// TLS certificates

/*
Raw:
MIIDrDCCApQCFCpvNrAfoVnLkZNl3dfEnKrTlZTOMA0GCSqGSIb3DQEBCwUAMIGR
MQswCQYDVQQGEwJJTjEUMBIGA1UECAwLTWFoYXJhc2h0cmExDTALBgNVBAcMBFB1
bmUxDjAMBgNVBAoMBVNNQVJUMRQwEgYDVQQLDAtEZXZlbG9wbWVudDEOMAwGA1UE
AwwFU01BUlQxJzAlBgkqhkiG9w0BCQEWGGpvc2hpLnByYW5qYWw1QGdtYWlsLmNv
bTAgFw0yMDA2MjYwNjU0NTZaGA8yMTIwMDYwMjA2NTQ1NlowgZAxCzAJBgNVBAYT
AklOMRQwEgYDVQQIDAtNYWhhcmFzaHRyYTENMAsGA1UEBwwEUHVuZTEOMAwGA1UE
CgwFU01BUlQxDDAKBgNVBAsMA0RldjEVMBMGA1UEAwwMU01BUlQtQ2xpZW50MScw
JQYJKoZIhvcNAQkBFhhqb3NoaS5wcmFuamFsNUBnbWFpbC5jb20wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQCyRZac+p5bZFEHarVPikrCAFX46DouW9WS
roY+OljKvAgefgHOu3oF7CVRoMoQBAoublWdTprX4ONZVj2VXZ2Jhq0XGNpETSOb
PpeRkSncsmltRrRIbFDsigs6SV3aPPqJxzjvTjEeeIOYQl1lpIPbLqYjdqsdqZKc
mTtxvF+ZL0E2MTnhDZDGpTQGv+FzEG1DeyWOszLO/3XRzy3BgNSV/+vBZIDlUx0C
jlsVGwrNnZYjhDVp30hJ9dIYYwAiXuQR7BF79L+ZgvWT7BY8x3vFYDzuWQQFfglc
V9NnO/iehVFG6GxlEzHHpM/q/vxY8HiNWYzZb5QL43ua+xC0/JBtAgMBAAEwDQYJ
KoZIhvcNAQELBQADggEBAEMatf0kJB1CU1DozIx2TrG+H/rLVt6uELUM7hlIANxT
UUQxn1Vtnn6xoGck6DJDdbMjs3JAIc010zBEatPhCCSYTnUmzkL3AOPzte5ydd0z
GAqHRDt2V2sN99qr5RGlQNxUHygUPKiFsysitdB2E14m1JwCHXcUrwP7EdyC5y99
FWIMjyme3KjOiNMl/0gGj9WKs8y1tj+gC+OjrsvaB91d7UfIfk5fhdGMgv9VulNd
8kcVRk0VZbQy41XfEVv7XOCGXBnzgOho6dz4ZPRES3VqO0uU4V5GXdrKLjsa/P89
cM9sVoOdTsWNy3vrtDelExe2RH64AxiOBtIWAdF7glE=
*/

 /*
SHA1 Client Fingerprint
69:32:F0:4A:E8:54:42:B6:E2:76:D4:D1:EC:ED:DC:D6:02:F3:BF:29
 */

/*
SHA1 Broker Fingerprint
CD:20:E9:EF:3F:17:0C:AC:43:50:02:70:58:08:F6:13:CE:45:09:B5
*/

/*
SHA1 CA
44:94:E6:93:F6:50:9D:1B:D7:EA:8E:FE:A6:32:D0:72:9E:7B:C3:7E
*/

#endif
