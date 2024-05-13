// Code to handle Web server to manage Provisioning and Configuration

#include "ConfigureWebServer.h"
#include "ConfigLoader.h"

AsyncWebServer server(80);
ConfigLoader provisioningConfigLoader;

bool WS_DEBUG = false;
bool mdnsEnabled = false;
unsigned long ota_progress_millis = 0;

String scanned_networks_html = "";
String current_hostname = "SmartMotion-Device";

const char index_html[] PROGMEM = R"(
  <!DOCTYPE HTML>
  <html>
  <head>
    <title>SmartMotion Config</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <style>
      :root {
        --accent-color: #f9256c; /* Your color code here */
      }
      html {
        display: inline-block;
        margin: 0px auto;
        text-align: center;
        font-family: 'Segoe UI', Helvetica, Roboto, sans-serif;
        text-decoration-color: black;
        background-color: white;
      }
      body {
        background: linear-gradient(to top right, #4e6cef, #f9256c);
        margin: 0;
        padding: 0;
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
      }
      .container {
        max-width: 600px;
        margin: 20px auto;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0px 0px 20px rgba(0, 0, 0, 0.1);
        padding: 20px;
      }
      #tHead {
        font-size: 1.2rem;
        font-weight: bold;
        padding-top: 0.7rem; 
        padding-bottom: 0.5rem;
        color: var(--accent-color);
      }
      table {
        color: black;
        border-spacing: 0.4rem;
        font-weight: 600;
        margin-bottom: 10px; /* Added margin bottom to separate tables */
      }
      #submit, #rescan, #factoryReset {
        background-color: var(--accent-color);
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
        color: var(--accent-color);
        border: 2px solid var(--accent-color);
        font-size: 1rem;
      }
      #rescan:hover, #factoryReset:hover {
        background-color: var(--accent-color);
        color: white;
        transition: background-color 0.3s;
      }
      #selectButton {
        background-color: var(--accent-color);
        border: none;
        border-radius: 1rem;
        padding: 0.4rem;
        color: white;
        cursor: pointer;
      }
      @media screen and (max-width: 600px) {
        #submit, #rescan, #factoryReset {
          display: block;
          width: 100%%;
          margin: 5px 0;
        }
        .container {
          max-width: 80%%;
        }
      }
      input[type="text"],
      input[type="password"],
      input[type="number"],
      input[type="url"] {
        color: black;
        font-size: 0.9rem;
        background-color: #F4F4F4;
        border: 1px solid #D1D1D1;
        border-radius: 0.5rem;
        padding: 0.5rem;
        width: calc(100%% - 12px);
        transition: border-color 0.3s, box-shadow 0.3s;
        font-weight: 500;
      }
      input[type="text"]::placeholder,
      input[type="password"]::placeholder,
      input[type="number"]::placeholder,
      input[type="url"]::placeholder {
        color: #A0A0A0;
        opacity: 0.8;
        font-weight: 400;
        font-size: 0.9rem;
      }
      input[type="text"]:focus,
      input[type="password"]:focus,
      input[type="number"]:focus,
      input[type="url"]:focus {
        outline: none; /* Remove default outline */
        border-color: var(--accent-color); /* Change border color on focus */
        box-shadow: 0 0 0 2px rgba(108, 99, 255, 0.2); /* Add a subtle box-shadow on focus */
      }
    </style>
  </head>
  <body>
    <div class="container">
      <br>
      <h3 style="font-weight: bold; font-size: 1.6rem; color: var(--accent-color); margin-top: 0.2rem;">Configure SmartMotion</h3>
      <form action="/get">
        <center>
          <table>
            <tr>
              <td colspan="2" id="tHead">Available Networks (Click to Select)</td>
            </tr>
            <tr>
              <td style="font-size: 1.1rem; text-align: left;">Network SSID</td>
              <td style="font-size: 1.1rem; text-align: center;">Signal Level</td>
              <td style="font-size: 1.1rem; text-align: center;">Use</td>
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
              <td><input type="text" name="ssid" id="ssidBox" maxlength="64" placeholder="Network Name" required></td>
            </tr>
            <tr>
              <td>WiFi Password:</td>
              <td><input type="password" name="pass" id="passBox" maxlength="64" required></td>
            </tr> 
            <tr>
                <td colspan="2" id="tHead">Device Configuration</td>
              </tr>
            <tr>
              <td>Device Location:</td>
              <td><input type="text" name="location" maxlength="64" placeholder="E.g. Living Room" required></td>
            </tr>
            <tr>
              <td>Switch OFF Timeout:
              </td>
              <td><input type="number" name="timeout" min="1" max="60" placeholder="2" style="width: 40%%;"> Minutes</td>
            </tr>
            <tr>
              <td>Switch ON URL:</td>
              <td><input type="url" name="url_on" maxlength="1024" placeholder="http://www.virtualsmarthome.xyz/YOUR-ON-URL" required></td>
            </tr>
            <tr>
              <td>Switch OFF URL:</td>
              <td><input type="url" name="url_off" maxlength="1024" placeholder="http://www.virtualsmarthome.xyz/YOUR-OFF-URL" required></td>
            </tr>
          </table>
          <br>
          <input type="button" name="rescan" id="rescan" value="Re-scan Nearby Networks">
          <input type="button" name="factory_reset" id="factoryReset" value="Factory Reset">
          <input type='submit' name='Submit' id="submit">
        </center>
      </form>
    </div>
  </body>
  <script>
    function copyText(button) {
      var row = button.parentNode.parentNode;
      var text = row.cells[0].innerText;
      document.getElementById("ssidBox").value = text;
      document.getElementById("passBox").focus();
    }
    document.getElementById("factoryReset").addEventListener("click", function() {
      var confirmation = confirm("Are you sure you want to perform a factory reset?");
      if (confirmation) {
          window.location.href = '/reset';
      } else {
          return false;
      }
    });
    document.getElementById("rescan").addEventListener("click", function() {
      window.location.href = '/rescan';
    });
  </script>
  </html>
)";

const char config_saved_html[] PROGMEM = R"(
  <!DOCTYPE HTML>
  <html>
  <head>
    <title>Success</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <style>
      :root {
        --accent-color: #f9256c; /* Your color code here */
      }
      html {
        display: inline-block;
        margin: 0px auto;
        text-align: center;
        font-family: 'Segoe UI', Helvetica, Roboto, sans-serif;
        text-decoration-color: black;
        background-color: white;
      }
      body {
        background: linear-gradient(to top right, #4e6cef, #f9256c);
        margin: 0;
        padding: 0;
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
      }
      .container {
        max-width: 600px;
        margin: 20px auto;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0px 0px 20px rgba(0, 0, 0, 0.1);
        padding: 20px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <br>
      <h3 style="font-weight: bold; font-size: 1.6rem; color: var(--accent-color); margin-top: 0.2rem;">Configuration Saved Successfully</h3>
      <h4 style="font-weight: 600; font-size: 1.2rem;">The device will Restart automatically and Connect to the Configured WiFi Network</h4>
      <h5 style="font-weight: 600; font-size: 1rem;">Visit <a href="#">http://%HOSTNAME%.local</a> to Reconfigure anytime</h5>
    </div>
  </body>
  </html>
)";

const char config_reset_html[] PROGMEM = R"(
  <!DOCTYPE HTML>
  <html>
  <head>
    <title>Reset</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <style>
      :root {
        --accent-color: #f9256c; /* Your color code here */
      }
      html {
        display: inline-block;
        margin: 0px auto;
        text-align: center;
        font-family: 'Segoe UI', Helvetica, Roboto, sans-serif;
        text-decoration-color: black;
        background-color: white;
      }
      body {
        background: linear-gradient(to top right, #4e6cef, #f9256c);
        margin: 0;
        padding: 0;
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
      }
      .container {
        max-width: 600px;
        margin: 20px auto;
        background-color: white;
        border-radius: 10px;
        box-shadow: 0px 0px 20px rgba(0, 0, 0, 0.1);
        padding: 20px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <br>
      <h3 style="font-weight: bold; font-size: 1.6rem; color: var(--accent-color); margin-top: 0.2rem;">Factory Reset Successful</h3>
      <h4 style="font-weight: 600; font-size: 1.2rem;">The device will Reset and should be Configured again for further use</h4>
    </div>
  </body>
  </html>
)";

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
    return String("SmartMotion-") + current_hostname;
  }
  else if(var == "SCANNED_NETWORKS") {
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
    provisioningConfigLoader.addConfig(FILE_SSID, request->getParam("ssid")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_PASS, request->getParam("pass")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_LOCATION, request->getParam("location")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_TIMEOUT, request->getParam("timeout")->value().toInt());
    provisioningConfigLoader.addConfig(FILE_URL_ON, request->getParam("url_on")->value().c_str());
    provisioningConfigLoader.addConfig(FILE_URL_OFF, request->getParam("url_off")->value().c_str());
    request->send_P(200, "text/html", config_saved_html, processor);
    delayMicroseconds(1000*1000);
    ESP.restart();
  });

  server.on("/reset", HTTP_GET, [](AsyncWebServerRequest *request){
    provisioningConfigLoader.erase();
    request->send_P(200, "text/html", config_reset_html, processor);
  });

  server.on("/rescan", HTTP_GET, [](AsyncWebServerRequest *request){
    WiFi.scanDelete();
    WiFi.scanNetworks();
    while(WiFi.scanComplete() < 1) {
      delay(10);
    };
    _showWifiNetworks();
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
  MDNS.update();
}