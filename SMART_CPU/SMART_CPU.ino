// S.M.A.R.T CPU module
// Processor: ATmega328 @ 16MHz
// Author: Pranjal Joshi
// Date: 20/03/2015
// Info: The central system that integrates every module.
//copyright 2015. All rights reserved.


#include <Wire.h>
#include <RTClib.h>
#include <SimpleTimer.h>
#include <LiquidCrystal.h>
#include <SoftwareSerial.h>
#include <VirtualWire.h>
#include "EEPROM_CONFIG.h"

#define PORT 80
#define AT24C1024_ADDR 0x50
#define ESP_BAUD 38400
#define SERIAL_BAUD 38400
#define RX_PIN 4
#define RF_ADDR 0x00
#define RX_BAUD 2000
#define STR_TERM_CHAR 0x7F

#define ROOMS 4
#define DEVICES 4

// 74HC595 I/O expansion pins
#define latchPin A0
#define clkPin A1
#define dataPin A2
#define OEpin 3

SoftwareSerial esp(6,5);  //Rx,TX
LiquidCrystal lcd(7,8,9,10,11,12); // RS E D4-D7
RTC_DS1307 rtc;
SimpleTimer timer;

boolean rtc_fail = false;
byte DateTimeArray[7];
char espConnID = -1;
String SSID;
String PASS;
byte controlArray[ROOMS][DEVICES];
byte controlBits[2];
byte selectRoom, selectDevice,setValue;

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
  initRF();
  initRTC();
  getDateTime();
}

void loop()
{
  httpHandler();
  for(byte i=0;i<256;i++)
  {
    writeReg(i);
    delay(5);
  }
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
  espWrite("AT+CWMODE=3",4000);
  connectEsp();
  espWrite("AT+CIPMUX=1",2000);
  espWrite("AT+CIPSERVER=1,80",1500);
}

void connectEsp()
{
  SSID = eepromToString(E_SSID);
  PASS = eepromToString(E_PASS);
  esp.print("AT+CWJAP=");
  esp.print("\"");
  esp.print(SSID);
  esp.print("\",\"");
  esp.print(PASS);
  esp.println("\"");
  delay(6500);
  if(!esp.find("OK") || !esp.find("ok"))
  {
    byte wifiRetry = eepromRead(E_WIFI_RETRY_COUNT);
    if(wifiRetry > 5)
    {
      authenticationFailed();
    }
    else
    {
      espWrite("AT+RST",5000);
      wifiRetry++;
      eepromWrite(wifiRetry,E_WIFI_RETRY_COUNT);
      connectEsp();
    }
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

void espGetConnID()
{
  if(esp.available())
  {
    if(esp.find("+IPD,"))
    {
      espConnID = esp.read() - 48;
    }
  }
}

void eepromToEsp(unsigned long eeprom_addr, byte terminationChar)
{
  // code to transfer HTML from eeprom to esp8266.
  unsigned long adr_cnt = eeprom_addr;
  unsigned long length = 0;
  byte temp = eepromRead(adr_cnt);
  espGetConnID();
  
  while(temp != STR_TERM_CHAR)
  {
    length++;
    adr_cnt++;
    temp = eepromRead(adr_cnt);
  }
  adr_cnt = eeprom_addr;
  temp = eepromRead(adr_cnt);
  esp.print("AT+CIPSEND=");
  esp.print(espConnID);
  esp.print(",");
  esp.println(length);
  delay(100);
  if(esp.find(">"))
  {
    while(temp != STR_TERM_CHAR && (adr_cnt + length) > eeprom_addr)
    {
      esp.print(temp);
    }
  }
}

String eepromToString(unsigned long eeprom_addr)
{
  String str="";
  unsigned long addr = eeprom_addr;
  byte c = eepromRead(addr);
  while(c != STR_TERM_CHAR)
  {
    str += c;
    addr++;
    c = eepromRead(addr);
  }
  return str;
}

void authenticationFailed()
{
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Cant conect wifi");
  lcd.setCursor(0,1);
  lcd.print("Connect to wifi:");
  lcd.setCursor(0,2);
  lcd.print("ESP_xxxx & visit");
  lcd.setCursor(0,3);
  lcd.print("IP:192.168.4.1");
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

void getDateTime()
{
  DateTime now = rtc.now();
  DateTimeArray[0] = now.day();
  DateTimeArray[1] = now.month();
  DateTimeArray[2] = now.year() - 2000;
  DateTimeArray[3] = now.hour();
  DateTimeArray[4] = now.minute();
  DateTimeArray[5] = now.second();
  if(DateTimeArray[3] > 12)
  {
    DateTimeArray[3] -= 12;
    DateTimeArray[6] = 'P';
  }
  else if(DateTimeArray[3] == 12)
    DateTimeArray[6] = 'P';
  else
    DateTimeArray[6] = 'A';
    
  for(int k=0;k<6;k++)
    Serial.println(DateTimeArray[k]);
  Serial.println((char)DateTimeArray[6]);

}

void httpHandler()
{
  if(esp.available())
  {
    if(esp.find("+IPD,"))
    {
      espConnID = esp.read() - 48;
      if(esp.find("?authenticationFailed"))
      {
        eepromToEsp(E_WIFI_RESET_PAGE ,STR_TERM_CHAR);
      }
      if(esp.find("room="))
        selectRoom = esp.read() - 48;
      if(esp.find("device="))
        selectDevice = esp.read() - 48;
      if(esp.find("state="))
        setValue = esp.read() - 48;
        
      controlArray[selectRoom][selectDevice] = setValue;
      updateControlState(controlArray);
    }
  }
}

void updateControlState(byte a[ROOMS][DEVICES])
{
  byte i,j;
  unsigned long addr = E_CONTROL_STATE;
  for(i=0;i<ROOMS;i++)
  {
    for(j=0;j<DEVICES;j++)
    {
      eepromWrite(a[i][j], addr);
      addr++;
    }
  }
}

void retriveControlState(byte a[ROOMS][DEVICES])
{
  byte i,j;
  unsigned long addr = E_CONTROL_STATE;
  for(i=0;i<ROOMS;i++)
  {
    for(j=0;j<DEVICES;j++)
    {
      a[i][j] = eepromRead(addr);
      addr++;
    }
  }
}

void writeReg(byte data)
{
  // write data to 74HC595 reg for output expansion.
  pinMode(latchPin,OUTPUT);
  pinMode(clkPin,OUTPUT);
  pinMode(dataPin,OUTPUT);
  digitalWrite(latchPin,0);
  shiftOut(dataPin, clkPin, MSBFIRST, data);
  digitalWrite(latchPin,1);
}

byte readReg()
{
  // read data from 74HC595 reg for input expansion.
  pinMode(latchPin,OUTPUT);
  pinMode(clkPin,OUTPUT);
  pinMode(dataPin,INPUT);
  digitalWrite(latchPin,1);
  delayMicroseconds(20);
  digitalWrite(latchPin,0);
  byte data = shiftIn(dataPin, clkPin, MSBFIRST);
  return data;
}
