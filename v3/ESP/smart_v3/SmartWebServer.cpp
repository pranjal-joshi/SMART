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

AsyncWebServer server(80);
SmartFileSystem sfs;
bool SWS_DEBUG = false;

String paramUsername,paramNodename,paramChannel,paramSsid,paramPass,paramMqttIp,paramMqttPort;

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
  <h3 style="font-weight: bold; font-size: 1.8rem; color: lightblue;">SMART_v3</h3>
  <h3 style="font-weight: bold; font-size: 1.3rem; color: white;">Configuration Portal</h3>
  <form action="/get">
    <center>
      <table>
        <tr>
          <td colspan="2" id="tHead">Wi-Fi Setup</td>
        </tr>
        <tr>
          <td>WiFi SSID:</td>
          <td><input type="text" name="ssid" placeholder="Network Name" required></td>
        </tr>
        <tr>
          <td>WiFi Password:</td>
          <td><input type="password" name="pass" required></td>
        </tr> 
        <tr>
          <td>WiFi Channel:</td>
          <td><input type="number" name="channel" placeholder="1-14"></td>
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
          <td><input type="text" name="mqtt_ip" value="35.225.15.182" required></td>
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
</html>
)rawliteral";

SmartWebServer::SmartWebServer(void){
  
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
  
  // Handle responses
  server.onNotFound( [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html);
  });
  
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html);
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
    }
    sfs.addConfig(CONF_SSID,paramSsid);
    sfs.addConfig(CONF_PASS,paramPass);
    sfs.addConfig(CONF_WIFI_CH,paramChannel);
    sfs.addConfig(CONF_USERNAME,paramUsername);
    sfs.addConfig(CONF_NODENAME,paramNodename);
    sfs.addConfig(CONF_MQTT_IP,paramMqttIp);
    sfs.addConfig(CONF_MQTT_PORT,paramMqttPort);
    if(sfs.isConfigEmpty()) {
      request->send_P(200, "text/html", saved_error_html);
      if(SWS_DEBUG) {
        Serial.print(F("[+] smartWebServer: INFO: Attempting to format SPIFFS. "));
        sfs.setDebug(SWS_DEBUG);
        sfs.format();
      }
    }
    else {
      request->send_P(200, "text/html", saved_ok_html);
      delay(200);
      ESP.reset();
    }
  });
  server.begin();
}
