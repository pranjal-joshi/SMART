/*
  SMART_ROUTER  :  RF24 ROUTER FOR RANGE & LoS EXTENSION.
  AUTHOR        :  PRANJAL JOSHI
  ORGANISATION  :  S.M.A.R.T
  ALL RIGHTS RESERVED.
*/

#include <RF24Network.h>
#include <RF24.h>
#include <SPI.h>
#include "printf.h"

/*
  ------------- ROUTER CONFIGURATION -------------
    --> UID should match with bridge UID.
    --> CHILDREN must contain list of all addresses of nodes/routers connected to this one as a child.
    --> PARENT will be the address of parent module.
*/
// 1 for developer debugging. 0 for normal mode.
#define DEBUG 1

#define UID 123

const uint16_t ROUTER = 01;
const uint16_t CHILDREN[] = {011,0};
const uint16_t PARENT = 00;


RF24 radio(9,10);
RF24Network network(radio);   

struct payload_struct {                  // Structure of our payload
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

payload_struct payload;

void setup(void)
{
  SPI.begin();
  radio.begin();
  network.begin(UID, ROUTER);
  radio.setPALevel(RF24_PA_MAX);
  radio.setDataRate(RF24_250KBPS);
  radio.setCRCLength(RF24_CRC_8);
  #if DEBUG
    Serial.begin(9600);
    printf_begin();
    radio.printDetails();
  #endif
}

void loop()
{
  network.update();
  
  while(network.available())
  {
    RF24NetworkHeader header;
    network.read(header,&payload,sizeof(payload));
    //payload = networkDecrypt(payload);
    #if DEBUG
      Serial.println(payload.uniqueID);
      Serial.println(payload.myaddr);
      Serial.println(payload.destaddr);
      Serial.println(payload.device);
      Serial.println(payload.val);
      Serial.println(payload.ack);
      Serial.println(payload.repeate);
      Serial.println(payload.key);
      Serial.println(payload.blaster);
    #endif
    payload.repeate = 1;
    if(payload.ack == 0)
    {
      RF24NetworkHeader retransmit(PARENT);
      bool ok = network.write(retransmit,&payload,sizeof(payload));
      #if DEBUG
        Serial.println("Sent to Higher layer");
      #endif
    }
    else
    {
      payload.ack = 0;
      //payload = networkEncrypt(payload);
      broadcastChildren(CHILDREN);
    }
  }
  delayMicroseconds(500);
}

void broadcastChildren(const uint16_t *c)
{
  #if DEBUG
    Serial.println("broadcasting to [OCTAL address]..");
  #endif
  byte k=0;
  while(c[k]!=0)
  {
    #if DEBUG
      Serial.println(c[k],OCT);
    #endif
    RF24NetworkHeader retransmit(c[k]);
    bool ok = network.write(retransmit,&payload,sizeof(payload));
    delayMicroseconds(500);
    k++;
  }
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
