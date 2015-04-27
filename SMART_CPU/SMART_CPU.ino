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
#include <EEPROM.h>
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

// Serial port is renamed to 'esp' for programmer's convinience.
// You can use Serial.anyFunction(); instead of esp.anyFunction();
#define esp Serial

// 74HC595 I/O expansion pins
#define latchPin A0
#define clkPin A1
#define dataPin A2
#define OEpin 3

SoftwareSerial dbg(6,5);  //Rx,TX
LiquidCrystal lcd(7,8,9,10,11,12); // RS E D4-D7
RTC_DS1307 rtc;
SimpleTimer timer;

boolean rtc_fail = false;
byte DateTimeArray[7];
char espConnID = -1;
String SSID;
String PASS;
byte outputArray[ROOMS+1];
byte inputArray[ROOMS+1];
byte radioFrame[4];
byte pplCount[ROOMS+1];
byte temperature[ROOMS+1];
byte selectRoom, selectDevice,setValue;
byte globalCnt;

void setup()
{
  dbg.begin(SERIAL_BAUD);
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
  inputHandler();
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
    if(strstr(_resp,"OK") || strstr(_resp,"ERROR") || strstr(_resp,"ok") || strstr(_resp,"error"))
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
  lcd.setCursor(0,4);
  lcd.print("IP:");
  lcd.print(getIP());
}

void connectEsp()
{
  //SSID = eepromToString(E_SSID);
  //PASS = eepromToString(E_PASS);
  SSID = "WIFI_NAME";
  PASS = "WIFI_PASS";
  String cmd,conStatus;
  cmd = "AT+CWJAP=";
  cmd += "\"";
  cmd += SSID;
  cmd += "\",\"";
  cmd += PASS;
  cmd += "\"";
  conStatus = espWrite(cmd,6500);
  byte len = conStatus.length()+1;
  char _conStatus[len];
  conStatus.toCharArray(_conStatus,sizeof(_conStatus));
  dbg.println(_conStatus);
  if((strstr(_conStatus,"ERROR")) || (strstr(_conStatus,"error")))
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
  while(!esp.available());
  delay(200);
  while(esp.available())
  {
    ip += (char)esp.read();
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
      temp = eepromRead(adr_cnt);
      esp.print(temp);
      adr_cnt++;
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
    dbg.println(DateTimeArray[k]);
  dbg.println((char)DateTimeArray[6]);

}

void httpResponse(int connectionID, String content)
{
  String httpHeader, httpResp;
  
  httpHeader = "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=UTF-8\r\n";
  httpHeader += "Content-Length: ";
  httpHeader += content.length();
  httpHeader += "\r\n";
  httpHeader += "Connection: close\r\n\r\n";
  httpResp = httpHeader + content;
  espCIPsend(connectionID, httpResp);
}

void espCIPsend(int connectionID, String data)
{
  String cipSend = "AT+CIPSEND=";
  cipSend += connectionID;
  cipSend += ",";
  cipSend += data.length();
  espWrite(cipSend, 1000);
  delay(10);
  esp.print(data);
}

void httpHandler()
{
  if(esp.available())
  {
    if(esp.find("+IPD,"))
    {
      
      espConnID = esp.read() - 48;
 
      if(esp.find("toggle="))
      {
        selectRoom = esp.parseInt();
        esp.read();
        selectDevice = esp.parseInt();
        esp.read();
        setValue = esp.parseInt();
        updateOutputArray();
      }
      if(esp.find("clk="))
      {
        DateTimeArray[2] = esp.parseInt();
        esp.read();
        DateTimeArray[1] = esp.parseInt();
        esp.read();
        DateTimeArray[0] = esp.parseInt();
        esp.read();
        DateTimeArray[3] = esp.parseInt();
        esp.read();
        DateTimeArray[4] = esp.parseInt();
        esp.read();
        DateTimeArray[5] = esp.parseInt();
        rtc.adjust(DateTime(DateTimeArray[2],DateTimeArray[1],DateTimeArray[0],DateTimeArray[3],DateTimeArray[4],DateTimeArray[5]));
      }
    }
  }
}

void writeReg(byte data)
{
  // write data to 74HC595 reg for output expansion.
  pinMode(latchPin,OUTPUT);
  pinMode(clkPin,OUTPUT);
  pinMode(dataPin,OUTPUT);
  shiftOut(dataPin, clkPin, MSBFIRST, data);
  digitalWrite(latchPin,0);
  delayMicroseconds(10);
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

void updateOutputArray()
{
  bitWrite(outputArray[selectRoom],(selectDevice-1),setValue);
  for(globalCnt=0;globalCnt<ROOMS;globalCnt++)
  {
    writeReg(outputArray[globalCnt]);
    EEPROM.write((I_STATE + globalCnt),outputArray[globalCnt]);
  }
}

void inputHandler()
{
  for(globalCnt=0;globalCnt<ROOMS;globalCnt++)
  {
    inputArray[globalCnt] = readReg();
  }
}

void decodeRadioData()
{
  byte radioFrameLen = 4;
  if(vw_get_message(radioFrame, &radioFrameLen))
  {
    if(radioFrame[3] == '\n')
    {
      selectRoom = radioFrame[0];
      pplCount[selectRoom] = radioFrame[1];
      temperature[selectRoom] = radioFrame[2];
    }
  }
}
