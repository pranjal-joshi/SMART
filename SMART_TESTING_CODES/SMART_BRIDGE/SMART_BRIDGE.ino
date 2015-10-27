
/*
  SMART_BRIDGE  :  USES RF24 MESH TOPOLOGY FOR SENSOR NETWORK COMMUNICATION.
  AUTHOR      :  PRANJAL JOSHI
  ALL RIGHTS RESERVED.
*/

// import libraries
#include <SPI.h>
#include <RF24.h>
#include <RF24Network.h>
#include <RF24Mesh.h>
#include <EEPROM.h>
#include "printf.h"

// RF24 configuration
RF24 radio(9,10);
RF24Network network(radio);

// Unique ID for each SMART home. MUST BE IN RANGE OF 0-127.
#define UID 123

// Room HALL_ADDRess mapping
// NEED TO CHANGE ON FIELD
const uint16_t CHILDREN[] = {01, 02, 03};
const uint16_t MY_ADDR = 00;

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

payload_struct payload = {UID, MY_ADDR, 0, 0, 0, 0, 0, 0};
byte serialPayload[3];
char serialBuf[5];


void setup()
{
  Serial.begin(9600);
  printf_begin();
  SPI.begin();
  radio.begin();
  network.begin(UID, MY_ADDR);
  radio.setPALevel(RF24_PA_MAX);
  radio.setDataRate(RF24_250KBPS);
  radio.setCRCLength(RF24_CRC_8);
  randomSeed(analogRead(A7));
}

void loop()
{
  network.update();
  
  while(network.available())
  {
    RF24NetworkHeader rxHead;
    network.read(rxHead,&payload,sizeof(payload));
    //payload = networkDecrypt(payload);
    if(payload.destaddr == MY_ADDR && payload.ack == 0 && payload.uniqueID == UID)
    {
      sendPayloadToPi();
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

void sendPayloadToPi()
{
  serialPayload[0] = payload.myaddr;
  serialPayload[1] = payload.device;
  serialPayload[2] = payload.val;
  for(byte k=0;k<sizeof(serialPayload);k++)
    Serial.print(serialPayload[k],DEC);
  Serial.println();
}

void serialEvent()
{
  delayMicroseconds(500);
  if(Serial.available())
  {
    payload.destaddr = Serial.parseInt();
    payload.val = Serial.parseInt();
    payload.ack = 1;
    byte temp = payload.myaddr;
    payload.myaddr = payload.destaddr;
    payload.destaddr = temp;
    //payload = networkEncrypt(payload);
    broadcastChildren(CHILDREN);
  }
}

void broadcastChildren(const uint16_t *c)
{
  for(byte k=0;k<sizeof(c);k++)
  {
    RF24NetworkHeader retransmit(c[k]);
    bool ok = network.write(retransmit,&payload,sizeof(payload));
    delayMicroseconds(500);
  }
}

