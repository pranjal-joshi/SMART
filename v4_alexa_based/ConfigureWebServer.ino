// Code to handle Web server to manage Provisioning and Configuration

#include "ConfigureWebServer.h"
#include "ConfigLoader.h"

AsyncWebServer server(80);
ConfigLoader provisioningConfigLoader;

bool WS_DEBUG = false;
unsigned long ota_progress_millis = 0;

String scanned_networks_html = "";
String current_hostname = "SmartMotion-Device";

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
      font-family: 'Segoe UI', sans-serif;
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
      margin-bottom: 10px;
    }
    ::placeholder{
      color: black;
      opacity: 0.55;
    }
    #submit, #rescan, #factoryReset {
      background-color: #f9256c;
      border: none;
      border-radius: 1rem;
      padding: 0.6rem;
      font-size: 1.2rem;
      color: white;
      cursor: pointer;
      margin-right: 10px;
    }
    #rescan, #factoryReset {
      background-color: white;
      color: #f9256c;
      border: 2px solid #f9256c;
      font-size: 1rem;
    }
    #rescan:hover, #factoryReset:hover {
      background-color: #f9256c;
      color: white;
      transition: background-color 0.3s;
    }
    #selectButton {
      background-color: #f9256cd4;
      border: none;
      border-radius: 1rem;
      padding: 0.4rem;
      color: white;
      cursor: pointer;
    }
    @media screen and (max-width: 600px) {
      #submit, #rescan, #factoryReset {
        display: block;
        width: 100%;
        margin: 5px 0;
      }
    }
    input[type="text"],
    input[type="password"],
    input[type="number"],
    input[type="url"] {
      color: black;
      font-size: 1.05rem;
      background-color: #F4F4F4;
      border: 1px solid #D1D1D1;
      border-radius: 0.5rem;
      padding: 0.5rem;
      width: calc(100% - 12px);
      transition: border-color 0.3s, box-shadow 0.3s;
      font-weight: bold;
    }
    input[type="text"]::placeholder,
    input[type="password"]::placeholder,
    input[type="number"]::placeholder,
    input[type="url"]::placeholder {
      color: #A0A0A0;
      opacity: 0.8;
    }
    input[type="text"]:focus,
    input[type="password"]:focus,
    input[type="number"]:focus,
    input[type="url"]:focus {
      outline: none;
      border-color: #f9256cd4;
      box-shadow: 0 0 0 2px rgba(108, 99, 255, 0.2);
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
          <td style="font-size: 1.2rem; text-align: center;">Signal Strength</td>
          <td style="font-size: 1.2rem; text-align: center;">Use</td>
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
          <td>Device Location:</td>
          <td><input type="text" name="location" placeholder="E.g. Living Room" required></td>
        </tr>
        <tr>
          <td>Switch OFF Timeout:
          </td>
          <td><input type="number" name="timeout" min="1" max="60" style="width: 65%;"> Minutes</td>
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
      <input type="button" name="rescan" id="rescan" value="Re-scan Nearby Networks">
      <input type="button" name="factory_reset" id="factoryReset" value="Factory Reset">
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
    return String("SmartMotion-") + current_hostname;
  }
  else if(var == "SCANNED_NETWORKS") {
    return (String)scanned_networks_html;
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
    provisioningConfigLoader.addConfig(FILE_SSID, request->getParam("ssid")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_PASS, request->getParam("pass")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_LOCATION, request->getParam("location")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_TIMEOUT, request->getParam("timeout")->value().toInt());
    provisioningConfigLoader.addConfig(FILE_URL_ON, request->getParam("url_on")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_URL_OFF, request->getParam("url_off")->value().c_str());
    request->send_P(200, "text/html", "Configuration Saved!");
  });

  server.begin();
  AsyncElegantOTA.begin(&server);
}

void ConfigureWebServer::loop(void) {
  MDNS.update();
}