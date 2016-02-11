/*
  SMART_NODE    :  RF24 BASED ROOM CONTROLLING NODE.
  AUTHOR        :  PRANJAL JOSHI
  ORGANISATION  :  S.M.A.R.T
  ALL RIGHTS RESERVED.
*/

#include <SPI.h>
#include <RF24.h>
#include <RF24Network.h>
#include <EEPROM.h>
#include <IRremote.h>
#include "printf.h"

/*
  ------------ NODE CONFIGURATION ---------------
    --> UID must match with router & bridge.
    --> MY_MASTER will be the address of bridge.
    --> MY_ROUTER is the parent router address. Will be same as MY_MASTER if directly connected to bridge.
    --> MY_ADDR is the physical address of node for radio communication.
    --> LOGICAL_ADDR is the decimal room number assigned in Server's database.
*/
#define DEBUG 1

#define UID 123
#define LOGICAL_ADDR 1
const uint16_t MY_MASTER = 00;
const uint16_t MY_ROUTER = 01;
const uint16_t MY_ADDR = 011;

// RF24 configuration
RF24 radio(9,10);
RF24Network network(radio);
IRsend blaster;

struct payload_struct
{
  byte uniqueID;
  byte myaddr;
  byte destaddr;
  byte device;
  byte val;
  byte ack;
  byte repeate;
  byte key;
  byte blaster;
};

payload_struct payload = {UID, LOGICAL_ADDR, MY_ROUTER, 0, 0, 0, 0, 0};

// register pin config
#define reg_rd 2 //A0
#define clk_rd 4 //A1
#define shld_rd 5 //A2
#define en_rd 6 //A3
#define reg_rw A0
#define clk_rw A1
#define en_rw A2 //A6

// global vars
byte readReg,oldReadReg,change,oldFan;
unsigned long newMillis, oldMillis;

// superfan codes
unsigned int  toggle[67] = {8950,4500, 600,500, 600,550, 550,550, 600,550, 550,550, 550,550, 600,550, 550,550, 600,1650, 600,1650, 600,1650, 600,1700, 550,1650, 600,550, 550,1700, 550,1700, 550,550, 600,550, 550,550, 600,1650, 550,1700, 600,550, 550,550, 600,1650, 550,1700, 600,1650, 600,1650, 600,550, 550,550, 600,1650, 600,1650, 600,550, 550};
unsigned int  s1[67] = {8850,4500, 550,550, 550,600, 550,550, 550,550, 550,550, 550,550, 600,500, 600,550, 550,1700, 550,1700, 550,1700, 550,1650, 600,1650, 600,550, 550,1700, 550,1700, 550,550, 550,550, 550,1700, 550,550, 550,1700, 600,500, 600,550, 550,1650, 600,1700, 550,1700, 550,550, 550,1700, 550,550, 550,1700, 550,1700, 500,600, 550};
unsigned int  s2[67] = {8850,4500, 550,550, 550,550, 600,550, 550,550, 550,550, 600,550, 550,550, 550,550, 550,1700, 550,1700, 550,1700, 550,1700, 550,1700, 550,550, 550,1700, 550,1700, 550,1700, 550,550, 550,550, 600,1650, 600,1650, 550,550, 600,550, 550,1700, 550,550, 600,1650, 550,1700, 550,550, 550,550, 600,1650, 600,1650, 550,550, 600};
unsigned int  s3[67] = {8850,4500, 550,550, 600,550, 550,550, 550,550, 600,550, 550,550, 550,550, 600,550, 550,1650, 600,1650, 600,1650, 550,1700, 600,1650, 550,550, 600,1650, 550,1700, 550,1700, 600,550, 500,1700, 600,550, 550,1650, 600,550, 550,550, 550,1700, 550,550, 600,1650, 550,550, 600,1700, 550,550, 550,1700, 550,1700, 550,550, 550};
unsigned int  s4[67] = {8850,4500, 550,550, 550,550, 600,550, 550,550, 550,550, 600,550, 550,550, 550,550, 600,1650, 550,1700, 550,1700, 550,1700, 550,1700, 550,550, 550,1700, 550,1700, 550,550, 600,1650, 550,550, 600,1650, 600,1650, 550,550, 600,550, 550,1700, 550,1700, 550,550, 550,1700, 550,550, 550,550, 600,1650, 600,1650, 550,550, 600};
unsigned int  s5[67] = {8800,4500, 600,550, 550,550, 550,550, 550,600, 550,550, 550,550, 550,550, 600,550, 550,1650, 600,1650, 600,1650, 550,1700, 550,1700, 550,550, 600,1650, 550,1700, 550,550, 550,1700, 550,1700, 550,550, 550,1700, 550,600, 500,600, 550,1700, 550,1650, 600,550, 550,550, 550,1700, 550,550, 550,1700, 550,1700, 550,550, 550};


void setup()
{
  SPI.begin();
  radio.begin();
  network.begin(UID, MY_ADDR);
  radio.setPALevel(RF24_PA_MAX);
  radio.setDataRate(RF24_250KBPS);
  radio.setCRCLength(RF24_CRC_8);
  #if DEBUG
    Serial.begin(9600);
    Serial.println("SMART_NODE DEBUG MODE");
    printf_begin();
    radio.printDetails();
  #endif
  pinMode(reg_rd,INPUT);
  pinMode(reg_rw,OUTPUT);
  pinMode(clk_rw,OUTPUT);
  pinMode(clk_rd,OUTPUT);
  pinMode(en_rd, OUTPUT);
  pinMode(shld_rd, OUTPUT);
  pinMode(en_rw, OUTPUT);
  digitalWrite(en_rw,0);
  shiftOut(reg_rw,clk_rw,MSBFIRST,0x00);
  oldShiftout = 0x00;
  digitalWrite(en_rw,0);
  randomSeed(analogRead(A7));
}

void loop()
{
  network.update();
  readShiftReg(50);
  if(readReg != oldReadReg)
  {
    change = readReg ^ oldReadReg;
    payload.device = 1;
    for(byte x=0;x<8;x++)
    {
      change = change >> 1;
      #if DEBUG
        Serial.println(change,BIN);
      #endif
      if(change & 0x01 == 0x01)
        break;
      payload.device++;
    }
    #if DEBUG
      Serial.print("device toggled: ");
      Serial.println(payload.device);
    #endif
    RF24NetworkHeader txHead(MY_ROUTER);
    //payload = networkEncrypt(payload);
    bool ok = network.write(txHead,&payload,sizeof(payload));
    oldReadReg = readReg;
    oldShiftout = payload.device;
  }
  
  while(network.available())
  {
    RF24NetworkHeader rxHead;
    network.read(rxHead,&payload,sizeof(payload));
    //payload = networkDecrypt(payload);
    if(payload.destaddr == LOGICAL_ADDR && payload.uniqueID == UID && payload.ack == 1) 
    {
      digitalWrite(en_rw,0);
      shiftOut(reg_rw,clk_rw,LSBFIRST,payload.val);
      digitalWrite(en_rw,1);
      controlFan(payload.blaster);
      #if DEBUG
        Serial.print("Got from Pi: ");
        Serial.println(payload.val);
      #endif
    }
  }
  
  delayMicroseconds(100);
}

/*struct payload_struct networkEncrypt(payload_struct p)
{
  payload.key = random(0,0xFF);
  payload.myaddr ^= payload.key;
  payload.destaddr ^= payload.key;
  payload.device ^= payload.key;
  payload.val ^= payload.key;
  payload.ack ^= payload.key;
  payload.uniqueID ^= payload.key;
  payload.repeate ^= payload.key;
  payload.blaster ^= payload.key;
  
  return payload;
}

struct payload_struct networkDecrypt(payload_struct p)
{
    payload.myaddr ^= payload.key;
    payload.destaddr ^= payload.key;
    payload.device ^= payload.key;
    payload.val ^= payload.key;
    payload.ack ^= payload.key;
    payload.uniqueID ^= payload.key;
    payload.repeate ^= payload.key;
    payload.blaster ^= payload.key;
    return payload;
}*/

void controlFan(byte x)
{
  if(oldFan != x)
  {
  switch(x)
  {
    case 0:
      blaster.sendRaw(toggle, sizeof(toggle) / sizeof(toggle[0]), 38);
      break;
    case 1:
      blaster.sendRaw(s1, sizeof(s1) / sizeof(s1[0]), 38);
      break;
    case 2:
      blaster.sendRaw(s2, sizeof(s2) / sizeof(s2[0]), 38);
      break;
    case 3:
      blaster.sendRaw(s3, sizeof(s3) / sizeof(s3[0]), 38);
      break;
    case 4:
      blaster.sendRaw(s4, sizeof(s4) / sizeof(s4[0]), 38);
      break;
    case 5:
      blaster.sendRaw(s5, sizeof(s5) / sizeof(s5[0]), 38);
      break;
    default:
      break;
  }
  oldFan = x;
  }
}

void readShiftReg(unsigned int interval_ms)
{
  newMillis = millis();
  if(newMillis - oldMillis > interval_ms)
  {
  digitalWrite(shld_rd, LOW);
  delayMicroseconds(200);
  digitalWrite(shld_rd, HIGH);
  delayMicroseconds(200);
  digitalWrite(clk_rd, HIGH);
  digitalWrite(en_rd, LOW);
  delayMicroseconds(100);
  readReg = shiftIn(reg_rd,clk_rd,MSBFIRST);
  delayMicroseconds(100);
  digitalWrite(en_rd, HIGH);
  #if DEBUG
    /*Serial.print("switches: ");
    Serial.println(readReg, BIN);*/
  #endif
  oldMillis = newMillis;
  }
}

int freeRam () {
  extern int __heap_start, *__brkval; 
  int v; 
  return (int) &v - (__brkval == 0 ? (int) &__heap_start : (int) __brkval); 
}
