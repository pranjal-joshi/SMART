/*
  SMART_NODE  :  USES RF24 MESH TOPOLOGY FOR SENSOR NETWORK COMMUNICATION.
  AUTHOR      :  PRANJAL JOSHI
  ALL RIGHTS RESERVED.
*/

#define DEBUG 1      // set 0 to stop serial debuging.

// import libraries
#include <SPI.h>
#include <RF24.h>
#include <RF24Network.h>
#include <RF24Mesh.h>
#include <EEPROM.h>
#include <IRremote.h>
#include "printf.h"

// RF24 configuration
RF24 radio(9,10);
RF24Network network(radio);
IRsend blaster;

// Unique ID for each SMART home. MUST BE IN RANGE OF 0-127.
#define UID 123

// Room HALL_ADDRess mapping
// NEED TO CHANGE ON FIELD
const uint16_t MY_MASTER = 00;
const uint16_t MY_ROUTER = 01;
const uint16_t MY_ADDR = 011;

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

payload_struct payload = {UID, MY_ADDR, MY_ROUTER, 0, 0, 0, 0, 0};
byte serialPayload[9];

// register pin config
#define reg_rd 9 //A0
#define clk_rd 7 //A1
#define shld_rd 8 //A2
#define en_rd 10 //A3
#define reg_rw A4
#define clk_rw A5
#define en_rw A3 //A6
#define LDR A7

// global vars
byte readReg,oldReadReg,change;

// superfan codes
unsigned int  toggle[67] = {8950,4500, 600,500, 600,550, 550,550, 600,550, 550,550, 550,550, 600,550, 550,550, 600,1650, 600,1650, 600,1650, 600,1700, 550,1650, 600,550, 550,1700, 550,1700, 550,550, 600,550, 550,550, 600,1650, 550,1700, 600,550, 550,550, 600,1650, 550,1700, 600,1650, 600,1650, 600,550, 550,550, 600,1650, 600,1650, 600,550, 550};
unsigned int  s1[67] = {8850,4500, 550,550, 550,600, 550,550, 550,550, 550,550, 550,550, 600,500, 600,550, 550,1700, 550,1700, 550,1700, 550,1650, 600,1650, 600,550, 550,1700, 550,1700, 550,550, 550,550, 550,1700, 550,550, 550,1700, 600,500, 600,550, 550,1650, 600,1700, 550,1700, 550,550, 550,1700, 550,550, 550,1700, 550,1700, 500,600, 550};
unsigned int  s2[67] = {8850,4500, 550,550, 550,550, 600,550, 550,550, 550,550, 600,550, 550,550, 550,550, 550,1700, 550,1700, 550,1700, 550,1700, 550,1700, 550,550, 550,1700, 550,1700, 550,1700, 550,550, 550,550, 600,1650, 600,1650, 550,550, 600,550, 550,1700, 550,550, 600,1650, 550,1700, 550,550, 550,550, 600,1650, 600,1650, 550,550, 600};
unsigned int  s3[67] = {8850,4500, 550,550, 600,550, 550,550, 550,550, 600,550, 550,550, 550,550, 600,550, 550,1650, 600,1650, 600,1650, 550,1700, 600,1650, 550,550, 600,1650, 550,1700, 550,1700, 600,550, 500,1700, 600,550, 550,1650, 600,550, 550,550, 550,1700, 550,550, 600,1650, 550,550, 600,1700, 550,550, 550,1700, 550,1700, 550,550, 550};
unsigned int  s4[67] = {8850,4500, 550,550, 550,550, 600,550, 550,550, 550,550, 600,550, 550,550, 550,550, 600,1650, 550,1700, 550,1700, 550,1700, 550,1700, 550,550, 550,1700, 550,1700, 550,550, 600,1650, 550,550, 600,1650, 600,1650, 550,550, 600,550, 550,1700, 550,1700, 550,550, 550,1700, 550,550, 550,550, 600,1650, 600,1650, 550,550, 600};
unsigned int  s5[67] = {8800,4500, 600,550, 550,550, 550,550, 550,600, 550,550, 550,550, 550,550, 600,550, 550,1650, 600,1650, 600,1650, 550,1700, 550,1700, 550,550, 600,1650, 550,1700, 550,550, 550,1700, 550,1700, 550,550, 550,1700, 550,600, 500,600, 550,1700, 550,1650, 600,550, 550,550, 550,1700, 550,550, 550,1700, 550,1700, 550,550, 550};


void setup()
{
  Serial.begin(9600);
  Serial.println("test");
  SPI.begin();
  radio.begin();
  network.begin(UID, MY_ADDR);
  radio.setPALevel(RF24_PA_MAX);
  radio.setDataRate(RF24_250KBPS);
  radio.setCRCLength(RF24_CRC_8);
  pinMode(reg_rd,INPUT);
  pinMode(reg_rw,OUTPUT);
  pinMode(clk_rw,OUTPUT);
  pinMode(clk_rd,OUTPUT);
  pinMode(en_rd, OUTPUT);
  pinMode(shld_rd, OUTPUT);
  pinMode(en_rw, OUTPUT);
  shiftOut(reg_rw,clk_rw,MSBFIRST,0x00);
  randomSeed(analogRead(A7));
}

void loop()
{
  network.update();
  readReg = readShiftReg();
  if(readReg != oldReadReg)
  {
    change = readReg ^ oldReadReg;
    payload.device = 1;
    while(1)
    {
      change = change >> 1;
      payload.device++;
      if(change & 0x01 == 0x01)
        break;
    }
    Serial.println(payload.device);
    RF24NetworkHeader txHead(MY_ROUTER);
    //payload = networkEncrypt(payload);
    bool ok = network.write(txHead,&payload,sizeof(payload));
    oldReadReg = readReg;
  }
  
  while(network.available())
  {
    RF24NetworkHeader rxHead;
    network.read(rxHead,&payload,sizeof(payload));
    //payload = networkDecrypt(payload);
    if(rxHead.from_node == MY_ROUTER && payload.ack == 1 && payload.uniqueID == UID)
    // payload.destaddr == MY_ADDR && 
    {
      //////////////
      digitalWrite(en_rw,0);
      shiftOut(reg_rw,clk_rw,MSBFIRST,payload.val);
      digitalWrite(en_rw,1);
      controlFan(payload.blaster);
    }
  }
    
  delayMicroseconds(100);
}

struct payload_struct networkEncrypt(payload_struct p)
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
}

void controlFan(byte x)
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
}

byte readShiftReg()
{
  digitalWrite(shld_rd, LOW);
  delayMicroseconds(200);
  digitalWrite(shld_rd, HIGH);
  delayMicroseconds(200);
  digitalWrite(clk_rd, HIGH);
  digitalWrite(en_rd, LOW);
  readReg = shiftIn(reg_rd,clk_rd,MSBFIRST);
  digitalWrite(en_rd, HIGH);
  return readReg;
}
