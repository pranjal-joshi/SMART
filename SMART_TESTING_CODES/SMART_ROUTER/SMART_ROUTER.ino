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
#define UID 123

const uint16_t ROUTER = 01;
const uint16_t CHILDREN[] = {011,021,031};
const uint16_t PARENT = 00;


RF24 radio(9,10);
RF24Network network(radio);   

struct payload_t {                  // Structure of our payload
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

payload_t payload;

void setup(void)
{
  Serial.begin(9600);
  printf_begin();
  SPI.begin();
  radio.begin();
  network.begin(UID, ROUTER);
  radio.setPALevel(RF24_PA_MAX);
  radio.setDataRate(RF24_250KBPS);
  radio.setCRCLength(RF24_CRC_8);
  radio.printDetails();
}

void loop()
{
  network.update();
  
  while(network.available())
  {
    RF24NetworkHeader header;
    network.read(header,&payload,sizeof(payload));
    /*
    Serial.println(payload.uniqueID);
    Serial.println(payload.myaddr);
    Serial.println(payload.destaddr);
    Serial.println(payload.device);
    Serial.println(payload.val);
    Serial.println(payload.ack);
    Serial.println(payload.repeate);
    Serial.println(payload.key);
    Serial.println(payload.blaster);
    Serial.println();
    */
    payload.repeate = 1;
    if(payload.ack == 0)
    {
      RF24NetworkHeader retransmit(PARENT);
      bool ok = network.write(retransmit,&payload,sizeof(payload));
    }
    else
    {
      broadcastChildren(CHILDREN);
    }
  }
  delayMicroseconds(500);
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
