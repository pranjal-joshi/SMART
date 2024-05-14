// Code to handle Web server to manage Provisioning and Configuration

#include "ConfigureWebServer.h"
#include "ConfigLoader.h"

AsyncWebServer server(80);
ConfigLoader provisioningConfigLoader;

bool WS_DEBUG = false;
bool mdnsEnabled = false;
bool task_reset = false;
unsigned long ota_progress_millis = 0;

String scanned_networks_html = "";
String current_hostname = "SmartMotion-Device";

ConfigureWebServer::ConfigureWebServer() {
}

void ConfigureWebServer::setDebug(bool flag) {
  WS_DEBUG = flag;
}

void _showWifiNetworks(void) {
  scanned_networks_html = "";
  if(WiFi.scanComplete() > -1) {
    if(WS_DEBUG)
      Serial.println(F("[PROVISION] WiFi Scanning completed."));
    for(int i=0;i<WiFi.scanComplete();i++) {
      
      scanned_networks_html += "<tr><td>" + WiFi.SSID(i) + "</td>";
      
      if(i>-1)      // To fix the bug of % loss due to PROCESSOR_TEMPLATE on alternate iterations.
        scanned_networks_html += "<td><center>" + String(map(WiFi.RSSI(i),-90,-20,0, 100)) + " %%</center></td>";
      else
        scanned_networks_html += "<td><center>" + String(map(WiFi.RSSI(i),-90,-20,0, 100)) + " %</center></td>";

      scanned_networks_html += "<td><input type='button' name='selectButton' id='selectButton' onclick='copyText(this)' value='Select'></td>";

      Serial.print(F("[PROVISION] SSID ->"));
      Serial.print(WiFi.SSID(i));
      Serial.print(F("\t RSSI-> "));
      Serial.print(String(map(WiFi.RSSI(i),-90,-20,0, 100))+"%\tChannel -> ");
      Serial.println(WiFi.channel());
      Serial.flush();
    }
    //WiFi.scanDelete();
  }
  else {
    Serial.println(F("[PROVISION] WiFi Scanning not completed."));
  }
}

void ConfigureWebServer::showWifiNetworks(void) {
  _showWifiNetworks();
}

String processor(const String& var) {
  if(var == "GET_SMART_SSID") {
    return (String)ssid_provision;
  }
  else if(var == "GET_SMART_LOCATION") {
    return (String)current_hostname;
  }
  else if(var == "GET_VERSION") {
    return (String)VERSION;
  }
  else if(var == "SCANNED_NETWORKS") {
    _showWifiNetworks();
    return (String)scanned_networks_html;
  }
  else if(var == "HOSTNAME") {
    String hostname = configLoader.getConfig(FILE_LOCATION);
    hostname.toLowerCase();
    hostname.replace(" ","");
    hostname.replace("-","");
    hostname.replace("_","");
    return (String)hostname;
  }
  return String();
}

void ConfigureWebServer::begin(const char* ssid_provision, const char* pass_provision, String hostname, bool async_scan, bool provision) {
  current_hostname = hostname;
  if (provision) {
    WiFi.softAP(ssid_provision, pass_provision);
  }

  if (async_scan) {
    WiFi.scanNetworks(true);     // for wifi scanning in background
  }
  else {
    WiFi.scanNetworks();
  }

  if(WS_DEBUG && provision) {
    Serial.println(F("[PROVISION] Starting SmartMotion in AP mode."));
    Serial.print(F("[PROVISION] SSID: "));
    Serial.println(ssid_provision);
    Serial.print(F("[PROVISION] IP: "));
    Serial.println(WiFi.softAPIP());
  }

  server.onNotFound( [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html, processor);
  });
  
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html, processor);
  });

  server.on("/get", HTTP_GET, [] (AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", config_saved_html, processor);
    provisioningConfigLoader.addConfig(FILE_SSID, request->getParam("ssid")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_PASS, request->getParam("pass")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_LOCATION, request->getParam("location")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_TIMEOUT, request->getParam("timeout")->value().toInt());
    provisioningConfigLoader.addConfig(FILE_URL_ON, request->getParam("url_on")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_URL_OFF, request->getParam("url_off")->value().c_str());
  });

  server.on("/reset", HTTP_GET, [](AsyncWebServerRequest *request){
    task_reset = true;
    request->send_P(200, "text/html", config_reset_html, processor);
  });

  server.on("/rescan", HTTP_GET, [](AsyncWebServerRequest *request){
    WiFi.scanDelete();
    WiFi.scanNetworks(true);
    request->send_P(200, "text/html", index_html, processor);
  });

  server.begin();
  AsyncElegantOTA.begin(&server);
}

void ConfigureWebServer::loop(void) {
  if(!mdnsEnabled) {
    if(WS_DEBUG) {
      Serial.println("[PROVISION] Starting MDNS Responder");
    }
    if (!MDNS.begin(current_hostname)) {
      if(WS_DEBUG) {
        Serial.println("[PROVISION] Error setting up MDNS responder!");
      }
    }
    MDNS.addService("http", "tcp", 80);
    mdnsEnabled = true;
  }
  if(task_reset) {
    provisioningConfigLoader.erase();
    task_reset = false;
    delay(1000);
    ESP.restart();
  }
  MDNS.update();
}