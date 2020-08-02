/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   31/05/2020
 * INFO     :   Class for AP web server to acquire config
 * ALL RIGHTS RESERVED.
 */

#include "SmartWebServer.h"
#include "SmartConstants.h"
#include "SmartFileSystem.h"

ESP8266WebServer httpServer(80);
ESP8266HTTPUpdateServer httpUpdater;

AsyncWebServer server(80);
SmartFileSystem sfs;
bool SWS_DEBUG = false;

String paramUsername,paramNodename,paramChannel,paramSsid,paramPass,paramMqttIp,paramMqttPort,paramMeshSsid, paramMeshPass;

String scanned_networks_html = "";

const char saved_ok_html[] PROGMEM = R"rawliteral(
<!DOCTYPE HTML><html>
<title>Config Ok</title>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="0" />
  <style>
    html {
     display: inline-block;
     margin: 0px auto;
     text-align: center;
     font-family: sans-serif;
     text-decoration-color: white;
     background-color: black;
    }
  </style>
</head>
<body>
  <h3 style="font-size: 1.8rem; color: lightblue;">SMART_v3</h3>
  <h3 style="font-size: 1.3rem; color: lightgreen;">Configuration Saved Successfully!</h3>
  <h2 style="font-size: 1.1rem; color: white;">Device will reset now to exit configuration mode.</h2>
</body>
</html>
)rawliteral";

const char saved_error_html[] PROGMEM = R"rawliteral(
<!DOCTYPE HTML><html>
<title>Config Ok</title>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="0" />
  <style>
    html {
     display: inline-block;
     margin: 0px auto;
     text-align: center;
     font-family: sans-serif;
     text-decoration-color: white;
     background-color: black;
    }
  </style>
</head>
<body>
  <h3 style="font-size: 1.8rem; color: lightblue;">SMART_v3</h3>
  <h3 style="font-size: 1.3rem; color: red;">Failed to configure!</h3>
  <h2 style="font-size: 1.1rem; color: white;">Contact us to resolve the issue.</h2>
</body>
</html>
)rawliteral";

const char index_html[] PROGMEM = R"rawliteral(
<!DOCTYPE HTML><html>
<title>SMART Configuration</title>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Expires" content="0" />
  <style>
    html {
     display: inline-block;
     margin: 0px auto;
     text-align: center;
     font-family: sans-serif;
     text-decoration-color: white;
     background-color: black;
    }
    #tHead {
      font-size: 1.2rem;
      font-weight: bold;
      padding-top: 0.7rem; 
      padding-bottom: 0.5rem;
      color: lightgreen;
    }
    table {
      color: white;
      border-spacing: 0.4rem;
      font-weight: bold;
    }
    input {
      color: white;
      font-size: 1.05rem;
      background-color: black;
      border-color: white;
      border-radius: 0.4rem;
      font-weight: bold;
      box-shadow: none;
    }
    ::placeholder{
      color: white;
      opacity: 0.55
    }
    #submit {
      background-color: green;
      border: none;
      border-radius: 1rem;
      padding: 0.6rem;
      font-size: 1.2rem;
    }
  </style>
</head>
<body>
  <br>
  <h3 style="font-weight: bold; font-size: 1.6rem; color: lightblue; margin-top: 0.2rem;">S.M.A.R.T Configuration Portal</h3>
  <form action="/get">
    <center>
      <table>
        <tr>
          <td colspan="2" id="tHead">Available Networks (Click to Select)</td>
        </tr>
        <tr>
          <td style="font-size: 1.2rem; text-align: left;">Network SSID</td>
          <td style="font-size: 1.2rem; text-align: right;">Signal Strength</td>
        </tr>
          %SCANNED_NETWORKS%
      </table>
      <table>
        <tr>
          <td colspan="2" id="tHead">Device Info</td>
        </tr>
        <tr>
          <td>Device ID</td>
          <td>%GET_SMART_SSID%</td>
        </tr>
        <tr>
          <td>Device Type</td>
          <td>%GET_SMART_DEVICE_TYPE%</td>
        </tr>
        <tr>
          <td colspan="2" id="tHead">Wi-Fi Setup</td>
        </tr>
        <tr>
          <td>WiFi SSID:</td>
          <td><input type="text" name="ssid" id="ssidBox" placeholder="Network Name" required></td>
        </tr>
        <tr>
          <td>WiFi Password:</td>
          <td><input type="password" name="pass" id="passBox" required></td>
        </tr> 
        <tr>
          <td>WiFi Channel:</td>
          <td><input type="number" name="channel" id="channelBox" placeholder="1-14"></td>
        </tr>
        <tr>
          <td colspan="2" id="tHead">SMART's Internal Network</td>
        </tr>
        <tr>
          <td colspan="2" style="font-size: 0.7rem; font-weight: normal; color: orange;">*You must use exact same SMART SSID & Password<br> for all of the SMART devices in your home to work properly.</td>
        </tr>
        <tr>
          <td>SMART SSID:</td>
          <td><input type="text" name="mesh_ssid" placeholder="Network name to be created" required></td>
        </tr>
        <tr>
          <td>SMART Password:</td>
          <td><input type="password" name="mesh_pass" required></td>
        </tr>
        <tr>
          <td colspan="2" id="tHead">Device Setup</td>
        </tr>
        <tr>
          <td>Username:</td>
          <td><input type="text" name="username" placeholder="Registered E-mail" required></td>
        </tr>
        <tr>
          <td>Device Name:</td>
          <td><input type="text" name="nodename" placeholder="E.g. Living Room" required></td>
        </tr>
        <tr>
          <td colspan="2" id="tHead">Connection Setup</td>
        </tr>
        <tr>
          <td>Server IP:</td>
          <td><input type="text" name="mqtt_ip" value="35.222.110.118" required></td>
        </tr>
        <tr>
          <td>Server Port:</td>
          <td><input type="number" name="mqtt_port" value="1883" required></td>
        </tr>
      </table>
      <br>
      <input type='submit' name='Submit' id="submit">
    </center>
  </form>
</body>
<script>
  function setSSID(ssid, ch) {
    document.getElementById("ssidBox").value = ssid;
    document.getElementById("channelBox").value = ch;
    document.getElementById("passBox").focus();
  }
</script>
</html>
)rawliteral";

SmartWebServer::SmartWebServer(void){
  
}

String processor(const String& var) {
  if(var == "GET_SMART_SSID") {
    size_t sz = snprintf(NULL, 0, "SMART_%08X", (uint32_t)ESP.getChipId()) + 1;
    char *ssid = (char*)malloc(sz);
    snprintf(ssid, 15, "SMART_%08X", (uint32_t)ESP.getChipId());
    return String(ssid);
  }
  else if(var == "GET_SMART_DEVICE_TYPE") {
    #ifdef SWITCHING_NODE
      return String(String(NO_OF_DEVICES) + " Device SwitchBox");
    #endif
    #ifdef SENSOR_NODE
      return String("SMART Sensor");
    #endif
  }
  else if(var == "SCANNED_NETWORKS") {
    return (String)scanned_networks_html;
  }
  return String();
}

void SmartWebServer::setDebug(bool d) {
  SWS_DEBUG = d;
}

void SmartWebServer::begin(const char* ssid, const char* pass) {
  WiFi.softAP(ssid,pass);
  if(SWS_DEBUG) {
    Serial.println(F("[+] SmartWebServer: INFO: Starting SmartWebServer in AP mode."));
    Serial.print(F("[+] SmartWebServer: SSID: "));
    Serial.println(ssid);
    Serial.print(F("[+] SmartWebServer: IP: "));
    Serial.println(WiFi.softAPIP());
  }

  // start scanning for WiFi's in background
  WiFi.scanNetworks(true);
  
  // Handle responses
  server.onNotFound( [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html, processor);
  });
  
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    // Earlier, was sending a HTML page for Config through Browser
    //request->send_P(200, "text/html", index_html, processor);

    // Later, Now send JSON array (Dart List) to App like [[SSID, RSSI, CH],...]
    DynamicJsonDocument doc(JSON_BUF_SIZE*2);
    DynamicJsonDocument d(JSON_BUF_SIZE);
    char jBuf[JSON_BUF_SIZE*2];
    Serial.println(WiFi.scanComplete());
    for(int i=0;i<WiFi.scanComplete();i++) {
      JsonArray j = doc.createNestedArray();
      j.add(WiFi.SSID(i));
      j.add(String(map(WiFi.RSSI(i),-90,-20,0, 100)));
      j.add(String(WiFi.channel()));
    }
    doc.shrinkToFit();
    serializeJson(doc, jBuf);
    request->send(200, "text/html", jBuf);
    doc.clear();
  });
  
  // Handle response after submit
  server.on("/get", HTTP_GET, [] (AsyncWebServerRequest *request) {
    paramSsid = request->getParam("ssid")->value();
    paramPass = request->getParam("pass")->value();
    paramChannel = request->getParam("channel")->value();
    paramUsername = request->getParam("username")->value();
    paramNodename = request->getParam("nodename")->value();
    paramMqttIp = request->getParam("mqtt_ip")->value();
    paramMqttPort = request->getParam("mqtt_port")->value();
    paramMeshSsid = request->getParam("mesh_ssid")->value();
    paramMeshPass = request->getParam("mesh_pass")->value();
    if(SWS_DEBUG) {
      Serial.print(F("[+] smartWebServer: PARAM: ssid -> "));
      Serial.println(paramSsid);
      Serial.print(F("[+] smartWebServer: PARAM: pass -> "));
      Serial.println(paramPass);
      Serial.print(F("[+] smartWebServer: PARAM: channel -> "));
      Serial.println(paramChannel);
      Serial.print(F("[+] smartWebServer: PARAM: username -> "));
      Serial.println(paramUsername);
      Serial.print(F("[+] smartWebServer: PARAM: nodename -> "));
      Serial.println(paramNodename);
      Serial.print(F("[+] smartWebServer: PARAM: mqtt_ip -> "));
      Serial.println(paramMqttIp);
      Serial.print(F("[+] smartWebServer: PARAM: mqtt_port -> "));
      Serial.println(paramMqttPort);
      Serial.print(F("[+] smartWebServer: PARAM: mesh_ssid -> "));
      Serial.println(paramMeshSsid);
      Serial.print(F("[+] smartWebServer: PARAM: mesh_pass -> "));
      Serial.println(paramMeshPass);
    }
    
    DynamicJsonDocument doc(JSON_BUF_SIZE);
    doc[CONF_SSID]=paramSsid;
    doc[CONF_PASS]=paramPass;
    doc[CONF_WIFI_CH]=paramChannel;
    doc[CONF_USERNAME]=paramUsername;
    doc[CONF_NODENAME]=paramNodename;
    doc[CONF_MQTT_IP]=paramMqttIp;
    doc[CONF_MQTT_PORT]=paramMqttPort;
    doc[CONF_MESH_SSID]=paramMeshSsid;
    doc[CONF_MESH_PASS]=paramMeshPass;
    doc.shrinkToFit();

    // Validation For Blank fields
    if(paramSsid == "" || paramPass == "" || paramChannel == "" || paramUsername == "" || paramNodename == "" || paramMqttIp == "" || 
       paramMqttPort == "" || paramMeshSsid == "" || paramMeshPass == "") {
        request->send(200, "text/html", "Can't accept blank fields! Validation failed!");
        return;
    }
    
    if(SPIFFS.begin()) {
      File f = SPIFFS.open(CONF_FILE,"w");
      serializeJson(doc, f);
      f.flush();
      f.close();
      // WARNING: Reading JSON here gives a memory dump
      request->send_P(200, "text/html", saved_ok_html);
      if(SWS_DEBUG)
        Serial.println(F("[+] SmartWebServer: INFO -> Config stored on SPIFFS. Auto-Resetting..."));
    }
    else {
      request->send_P(200, "text/html", saved_error_html);
      if(SWS_DEBUG)
        Serial.println(F("[+] SmartWebServer: ERROR -> Failed to save Config on SPIFFS. Auto-Resetting..."));
    }
  });
  server.begin();
}

void SmartWebServer::showWifiNetworks(void) {
  if(WiFi.scanComplete() > -1) {
    if(SWS_DEBUG)
      Serial.println(F("[+] SmartWebServer: INFO -> WiFi Scanning completed."));
    for(int i=0;i<WiFi.scanComplete();i++) {
      scanned_networks_html += "<tr onclick='setSSID(this.id, "+String(WiFi.channel(i))+")' id='"+WiFi.SSID(i)+"'><td style='text-align: left;'>";
      scanned_networks_html += String(i+1) + ". " + WiFi.SSID(i) + "</td><td style='text-align: right;'>";
      if(i>-1)      // To fix the bug of % loss due to PROCESSOR_TEMPLATE on alternate iterations.
        scanned_networks_html += String(map(WiFi.RSSI(i),-90,-20,0, 100)) + " %% (Ch: "+WiFi.channel(i)+") </td></tr>";
      else
        scanned_networks_html += String(map(WiFi.RSSI(i),-90,-20,0, 100)) + " % (Ch: "+WiFi.channel(i)+") </td></tr>";
      if(SWS_DEBUG) {
        Serial.print(F("[+] SmartWebServer: SSID ->"));
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
    if(SWS_DEBUG) {
      Serial.println(F("[+] SmartWebServer: INFO -> WiFi Scanning not completed."));
    }
  }
}

void SmartWebServer::beginOta(void) {
  /*size_t sz = snprintf(NULL, 0, "SMART_%08X", (uint32_t)ESP.getChipId()) + 1;
  char *ssid = (char*)malloc(sz);
  snprintf(ssid, 15, "SMART_%08X", (uint32_t)ESP.getChipId());
  AsyncElegantOTA.setID(ssid);
  AsyncElegantOTA.begin(&server);     // begin OTA
  server.begin();*/
  httpUpdater.setup(&httpServer, OTA_PATH, OTA_USER, OTA_PASS);
  httpServer.begin();
}

void SmartWebServer::loop(void) {
  //AsyncElegantOTA.loop();
  httpServer.handleClient();
}
