
/*
  SMART_BRIDGE  :  USES RF24 MESH TOPOLOGY FOR SENSOR NETWORK COMMUNICATION.
  AUTHOR        :  PRANJAL JOSHI
  ORGANISATION  :  S.M.A.R.T
  ALL RIGHTS RESERVED.
*/

// import libraries
#include <SPI.h>
#include <RF24.h>
#include <RF24Network.h>
#include <RF24Mesh.h>
#include <EEPROM.h>
#include "printf.h"

/*
  --------------- BRIDGE CONFIGURATION -------------------
    --> Change UID so it will match with every other node & router in the perimeter.
    --> UID = NRF 2.4GHz comm. channel!!!
    --> MY_ADDR = Address of bridge or base station.
    --> Add number of nodes & router in CHILDREN array which are directly connected to bridge.
    --> Network map of worksite will be available in maintainance manual for further details & troubleshooting.
*/

// Unique ID for each SMART home. MUST BE IN RANGE OF 0-127.
#define UID 123

const uint16_t CHILDREN[] = {01, 02, 03, 0};
const uint16_t MY_ADDR = 00;

// RF24 configuration
RF24 radio(9,10);
RF24Network network(radio);

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


void setup()
{
  Serial.begin(9600);
  Serial.setTimeout(200);
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
    if(payload.ack == 0 && payload.uniqueID == UID)
    {
      sendPayloadToServer();
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

void sendPayloadToServer()
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
    payload.blaster = Serial.parseInt();
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
  byte k=0;
  while(c[k]!=0)
  {
    Serial.println(c[k]);
    RF24NetworkHeader retransmit(c[k]);
    bool ok = network.write(retransmit,&payload,sizeof(payload));
    delayMicroseconds(500);
    k++;
  }
}
