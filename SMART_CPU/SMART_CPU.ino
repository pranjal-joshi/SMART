// S.M.A.R.T CPU module
// Processor: ATmega328 @ 16MHz
// Author: Pranjal Joshi
// Date: 20/03/2015
// Info: The central system that integrates every module.

#include <Wire.h>
#include <RTClib.h>
#include <SimpleTimer.h>
#include <LiquidCrystal.h>
#include <SoftwareSerial.h>
#include <VirtualWire.h>

#define SSID "WIFI_NAME"
#define PASS "WIFI_PASS"
#define PORT 80
#define AT24C1024_ADDR 0x50
#define ESP_BAUD 38400
#define SERIAL_BAUD 38400
#define RX_PIN 4
#define RX_BAUD 2000

SoftwareSerial esp(6,5);  //Rx,TX
LiquidCrystal lcd(7,8,9,10,11,12); // RS E D4-D7
RTC_DS1307 rtc;
SimpleTimer timer;

boolean rtc_fail = false;

void setup()
{
  Serial.begin(SERIAL_BAUD);
  lcd.begin(16,4);
  lcd.clear();
  lcd.noCursor();
  lcd.setCursor(0,0);
  lcd.print("   S.M.A.R.T");
  lcd.setCursor(0,1);
  lcd.print("Initializing...");
  delay(500);
  lcd.setCursor(0,2);
  lcd.print("Connecting WiFi");
  initEsp();
  lcd.setCursor(0,3);
  lcd.print("Checking modules");
  initRF();
  initRTC();
}

void loop()
{
}

void eepromWrite(byte data, uint16_t addr)
{
  Wire.beginTransmission(AT24C1024_ADDR);
  Wire.write((int)(addr >> 8));
  Wire.write((int)(addr & 0xFF));
  Wire.write(data);
  Wire.endTransmission();
  delay(1);
}

byte eepromRead(uint16_t addr)
{
  byte result;
  Wire.beginTransmission(AT24C1024_ADDR);
  Wire.write((int)(addr >> 8));
  Wire.write((int)(addr & 0xFF));
  Wire.endTransmission();
  Wire.requestFrom(AT24C1024_ADDR,1);
  result = Wire.read();
  return result;
}

String espWrite(String command, uint16_t timeout)
{
  String resp = "";
  char _resp[15];
  esp.println(command);
  unsigned long t = millis();
  while((t+timeout) > millis())
  {
    while(esp.available())
    {
      char c = esp.read();
      resp += c;
    }
    resp.toCharArray(_resp,sizeof(resp));
    if(strstr(_resp,"OK") || strstr(_resp,"ERROR"))
        break;
  }
  return resp;
}

void initEsp()
{
  esp.begin(ESP_BAUD);
  espWrite("AT+RST",5000);
  espWrite("AT+CWMODE=1",4000);
  connectEsp();
  espWrite("AT+CIPMUX=1",2000);
  espWrite("AT+CIPSERVER=1,80",1500);
}

void connectEsp()
{
  esp.print("AT+CWJAP");
  esp.print("\"");
  esp.print(SSID);
  esp.print("\",\"");
  esp.print(PASS);
  esp.println("\"");
  delay(6500);
  if(!esp.find("OK") || !esp.find("ok"))
  {
    espWrite("AT+RST",5000);
    connectEsp();
  }
}

String getIP()
{
  String ip="";
  espWrite("AT+CIFSR",800);
  while(esp.available())
  {
    ip += esp.read();
  }
  return ip;
}

void eepromToEsp(unsigned long addr, byte terminationChar)
{
  // Write code to transfer HTML from eeprom to esp8266.
}

void initRF()
{
  vw_set_rx_pin(RX_PIN);
  vw_setup(RX_BAUD);
  vw_rx_start();
}

void initRTC()
{
  if(!rtc.isrunning())
  {
    rtc_fail = true;
    rtc.adjust(DateTime(__DATE__,__TIME__));
  }
  DateTime now = rtc.now();
}

