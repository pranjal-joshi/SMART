// Code to handle Web server to manage Provisioning and Configuration

#include "ConfigureWebServer.h"
#include "ConfigLoader.h"

AsyncWebServer server(80);

bool WS_DEBUG = false;

String scanned_networks_html = "";

const char index_html[] PROGMEM = R"rawliteral(
  <!DOCTYPE HTML>
  <html>
  <head>
    <title>SmartMotion Config</title>
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
        text-decoration-color: black;
        background-color: white; 
      }
      #tHead {
        font-size: 1.2rem;
        font-weight: bold;
        padding-top: 0.7rem; 
        padding-bottom: 0.5rem;
        color: #f9256c; 
      }
      table {
        color: black;
        border-spacing: 0.4rem;
        font-weight: bold;
      }
      input {
        color: black; 
        font-size: 1.05rem;
        background-color: white; 
        border-color: black; 
        border-radius: 0.4rem;
        font-weight: bold;
        box-shadow: none;
      }
      ::placeholder{
        color: black; 
        opacity: 0.55;
      }
      #submit {
        background-color: #f9256c;
        border: none;
        border-radius: 1rem;
        padding: 0.6rem;
        font-size: 1.2rem;
        color: white;
        cursor: pointer;
      }
      #selectButton {
        background-color: #f9256cd4;
        border: none;
        border-radius: 1rem;
        padding: 0.4rem;
        color: white;
        cursor: pointer;
      }
    </style>
  </head>
  <body>
    <br>
    <h3 style="font-weight: bold; font-size: 1.6rem; color: #f9256c; margin-top: 0.2rem;">SmartMotion Configuration Portal</h3>
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
              <td colspan="2" id="tHead">Device Configuration</td>
            </tr>
          <tr>
            <td>Device Name:</td>
            <td><input type="text" name="nodename" placeholder="E.g. Living Room" required></td>
          </tr>
          <tr>
            <td>Switch OFF Timeout:</td>
            <td><input type="number" name="timeout" min="1" max="60" required>  Minutes</td>
          </tr>
          <tr>
            <td>Switch ON URL:</td>
            <td><input type="url" name="url_on" placeholder="http://www.virtualsmarthome.xyz/YOUR-ON-URL" required></td>
          </tr>
          <tr>
            <td>Switch OFF URL:</td>
            <td><input type="url" name="url_off" placeholder="http://www.virtualsmarthome.xyz/YOUR-OFF-URL" required></td>
          </tr>
        </table>
        <br>
        <input type='submit' name='Submit' id="submit">
      </center>
    </form>
  </body>
  <script>
    function copyText(button) {
      var row = button.parentNode.parentNode;               // Get the parent row
      var text = row.cells[0].innerText;                    // Get the text from the first column
      document.getElementById("ssidBox").value = text;      // Copy the text to the textbox
      document.getElementById("passBox").focus();
    }
  </script>
  </html>
)rawliteral";

ConfigureWebServer::ConfigureWebServer() {
}

void ConfigureWebServer::setDebug(bool flag) {
  WS_DEBUG = flag;
}

void ConfigureWebServer::showWifiNetworks(void) {
  if(WiFi.scanComplete() > -1) {
    if(WS_DEBUG)
      Serial.println(F("[PROVISION] WiFi Scanning completed."));
    for(int i=0;i<WiFi.scanComplete();i++) {
      // scanned_networks_html += "<tr onclick='setSSID(this.id, "+String(WiFi.channel(i))+")' id='"+WiFi.SSID(i)+"'><td style='text-align: left;'>";
      // scanned_networks_html += String(i+1) + ". " + WiFi.SSID(i) + "</td><td style='text-align: right;'>";
      
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

String processor(const String& var) {
  if(var == "GET_SMART_SSID") {
    return String(ssid_provision);
  }
  else if(var == "SCANNED_NETWORKS") {
    return (String)scanned_networks_html;
  }
  return String();
}

void ConfigureWebServer::begin(const char* ssid_provision, const char* pass_provision, bool async_scan) {
  WiFi.softAP(ssid_provision, pass_provision);
  if (async_scan) {
    WiFi.scanNetworks(true);     // for wifi scanning in background
  }
  else {
    WiFi.scanNetworks();
  }

  if(WS_DEBUG) {
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
    ConfigLoader configLoader;
    // TODO - Get these params into config loader and write to SPIFFS
    // ...
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

  server.begin();
}