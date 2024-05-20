// Code to handle Web server to manage Provisioning and Configuration

#include "ConfigureWebServer.h"
#include "ConfigLoader.h"

AsyncWebServer server(80);
ConfigLoader provisioningConfigLoader;
fauxmoESP alexaListener;

bool WS_DEBUG = false;
bool mdnsEnabled = false;
bool alexaListenerEnabled = false;
bool task_reset = false;
bool alexaSensingEnabled = true;
unsigned char wifi_channel = 6;

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

      if(WS_DEBUG) {
        Serial.print(F("[PROVISION] SSID ->"));
        Serial.print(WiFi.SSID(i));
        Serial.print(F("\t RSSI-> "));
        Serial.print(String(map(WiFi.RSSI(i),-90,-20,0, 100))+"%\tChannel -> ");
        Serial.println(WiFi.channel());
        Serial.flush();
      }
    }
    //WiFi.scanDelete();
  }
  else {
    if(WS_DEBUG)
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
  else if(var == "FETCH_SSID") {
    return provisioningConfigLoader.getConfig(FILE_SSID);
  }
  else if(var == "FETCH_PASS") {
    return provisioningConfigLoader.getConfig(FILE_PASS);
  }
  else if(var == "FETCH_LOCATION") {
    return provisioningConfigLoader.getConfig(FILE_LOCATION);
  }
  else if(var == "FETCH_TIMEOUT") {
    return provisioningConfigLoader.getConfig(FILE_TIMEOUT);
  }
  else if(var == "FETCH_URL_ON") {
    return provisioningConfigLoader.getConfig(FILE_URL_ON);
  }
  else if(var == "FETCH_URL_OFF") {
    return provisioningConfigLoader.getConfig(FILE_URL_OFF);
  }
  else if(var == "FETCH_SENSOR_STATE") {
    return (String)(alexaSensingEnabled ? "checked" : "");
  }
  return String();
}

void ConfigureWebServer::begin(const char* ssid_provision, const char* pass_provision, String hostname, bool async_scan, bool provision) {
  current_hostname = hostname;
  if (provision) {
    randomSeed(analogRead(A0));
    wifi_channel = random(1,15);
    WiFi.softAP(ssid_provision, pass_provision, wifi_channel);
    led.blink(100, 250);
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
    Serial.print(F("[PROVISION] Channel: "));
    Serial.println(wifi_channel);
  }
  
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html, processor);
  });

  server.on("/state", HTTP_GET, [] (AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", config_saved_html, processor);
    const char* sensor_state = request->getParam("sensor_state")->value().c_str();
    provisioningConfigLoader.addConfig(FILE_SENSOR_STATE, sensor_state);
    if (String(sensor_state) == "true") {
      alexaSensingEnabled = true;
    }
    else {
      alexaSensingEnabled = false;
    }
    alexaListener.setState((current_hostname + " motion sensor").c_str(), alexaSensingEnabled, alexaSensingEnabled? 100 : 0);
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

  // These two callbacks are required for gen1 and gen3 compatibility
  server.onRequestBody([](AsyncWebServerRequest *request, uint8_t *data, size_t len, size_t index, size_t total) {
      if (alexaListener.process(request->client(), request->method() == HTTP_GET, request->url(), String((char *)data))) return;
      // Handle any other body request here...
  });

  server.onNotFound([](AsyncWebServerRequest *request) {
      String body = (request->hasParam("body", true)) ? request->getParam("body", true)->value() : String();
      if (alexaListener.process(request->client(), request->method() == HTTP_GET, request->url(), body)) return;
      // Handle not found request here...
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
  if(!alexaListenerEnabled) {
    alexaListener.createServer(false);
    alexaListener.setPort(80); // This is required for gen3 devices
    alexaListener.enable(true);
    alexaListener.addDevice((current_hostname + " motion sensor").c_str());
    alexaListener.onSetState([](unsigned char device_id, const char * device_name, bool state, unsigned char value) {
        if(WS_DEBUG) {
          Serial.printf("[ALEXA] Device ID: %d\tDevice name: %s\tState: %d\n", device_id, device_name, state);
        }
        alexaSensingEnabled = state;
        if(alexaSensingEnabled) {
          provisioningConfigLoader.addConfig(FILE_SENSOR_STATE, "true");
        }
        else {
          provisioningConfigLoader.addConfig(FILE_SENSOR_STATE, "false");
        }
    });
    alexaListener.setState((current_hostname + " motion sensor").c_str(), alexaSensingEnabled, alexaSensingEnabled? 100 : 0);
    alexaListenerEnabled = true;
  }
  if(task_reset) {
    led.blinkNumberOfTimes(100, 250, 3);
    led.loop();
    while(led.getState() == LED_BLINKING) {
      led.loop();
      delay(1);
    }
    provisioningConfigLoader.erase();
    task_reset = false;
    delay(1000);
    ESP.restart();
  }
  if(!alexaSensingEnabled) {
    if (led.getState() == LED_IDLE) {
      if (isFadedIn == false) {
        led.fade(0, 127, 1000);
        isFadedIn = true;
      } else {
        led.fade(127, 0, 1000);
        isFadedIn = false;
      }
    }
  }
  MDNS.update();
  alexaListener.handle();
}