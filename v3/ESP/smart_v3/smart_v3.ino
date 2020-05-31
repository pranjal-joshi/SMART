/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   29/05/2020
 * ALL RIGHTS RESERVED.
 */

#include "SmartFileSystem.h"
#include "SmartWebServer.h"
#include "SmartConstants.h"
//#include <WiFiManager.h>
#include <PubSubClient.h>
#include <WiFiClient.h>

SmartFileSystem fsys;
SmartFileSystemFlags_t flag;

SmartWebServer configServer;

/*WiFiManagerParameter configUserName(CONF_USERNAME,"Registered username..","",32);
WiFiManagerParameter configNodeName(CONF_NODENAME,"Device name or Room name","",32);
WiFiManagerParameter configMqttServerIp(CONF_MQTT_IP,"IoT Server IP",MQTT_SERVER_IP,15);
WiFiManagerParameter configMqttServerPort(CONF_MQTT_PORT,"IoT Server port",MQTT_SERVER_PORT,4);
WiFiManagerParameter configWifiChannel(CONF_WIFI_CH,"WiFi Channel","6",2);*/


void mqttCallback(char* topic, byte* payload, unsigned int length) {}     //write MQTT callback here
WiFiClient wiCli;
IPAddress mqttIpAddress;
PubSubClient mqtt(wiCli);

void setup() {
  Serial.begin(115200);
  Serial.println();
  fsys.setDebug(true);
  if(fsys.isConfigEmpty()) {
    configServer.setDebug(true);
    configServer.begin(getSmartSSID(),AP_PASS);
  }
  //fsys.addConfig("a","b");
  fsys.format();
  /*
  mesh.setDebugMsgTypes( ERROR | STARTUP | CONNECTION );
  
  initWifiManager();
  //mesh.init(MESH_SSID,MESH_PASS,MESH_PORT,WIFI_AP_STA,WiFi.channel());

  initMqttClient();
  */
}

unsigned long lastMsg=0,value=1; char msg[100];
void loop() {
  //mqtt.loop();
  /*
  unsigned long now = millis();
  if (now - lastMsg > 3000) {
    lastMsg = now;
    ++value;
    snprintf (msg, 100, "hello world #%ld", value);
    Serial.print("Publish message: ");
    Serial.println(msg);
    mqtt.publish("smart", msg);
  }*/
}

String getSmartSSID() {
  char n[] = "";
  //String(String("SMART_")+String(ESP.getChipId(),HEX)).toCharArray(n,12);
  String(String("SMART_")+String(ESP.getChipId(),HEX)).toUpperCase();
  return n;
}

/*void initMqttClient() {
  mqtt.setServer(MQTT_SERVER_IP,String(MQTT_SERVER_PORT).toInt());
  mqtt.setCallback(mqttCallback);
  mqtt.connect(getSmartSSID());
  mqtt.publish("smart","[+] SMART: MQTT Client Ready!");
}*/

/*void initWifiManager() {
  WiFiManager mgr;
  //// REMOVE LATER ////
  //mgr.resetSettings();
  //fsys.format();
  ////
  mgr.setSaveConfigCallback(saveWifiCallback);
  mgr.setMinimumSignalQuality(MIN_SIG);
  mgr.setTimeout(CON_TIMEOUT);
  mgr.addParameter(&configUserName);
  mgr.addParameter(&configNodeName);
  mgr.addParameter(&configMqttServerIp);
  mgr.addParameter(&configMqttServerPort);
  mgr.addParameter(&configWifiChannel);
  if(!mgr.autoConnect(getSmartSSID(), AP_PASS)) {
    if(mDebug)
      Serial.println("[+] INFO: Timeout occured while waiting for WiFi. Rebooting..");
    initWifiManager();
    //ESP.reset(); Rather than resetting, make something recursive here!
    // TODO - switch to mesh mode if WiFi connection is not available
  }
  // TODO - set mesh here so that other nodes can connect, check if network is rooted, if not, make self a root.
}

void saveWifiCallback() {
  fsys.addConfig(CONF_USERNAME, configUserName.getValue());
  fsys.addConfig(CONF_NODENAME, configNodeName.getValue());
  fsys.addConfig(CONF_MQTT_IP, configMqttServerIp.getValue());
  fsys.addConfig(CONF_MQTT_PORT, configMqttServerPort.getValue());
  fsys.addConfig(CONF_WIFI_CH, configWifiChannel.getValue());
  if(mDebug)
    Serial.println("[+] INFO: User parameters are stored on the file system.");
}*/
