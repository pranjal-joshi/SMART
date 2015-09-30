/*
 Copyright (C) 2012 James Coliz, Jr. <maniacbug@ymail.com>

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 version 2 as published by the Free Software Foundation.
 
 Update 2014 - TMRh20
 */

/**
 * Simplest possible example of using RF24Network,
 *
 * RECEIVER NODE
 * Listens for messages from the transmitter and prints them out.
 */

#include <RF24Network.h>
#include <RF24.h>
#include <SPI.h>


RF24 radio(9,10);                // nRF24L01(+) radio attached using Getting Started board 

RF24Network network(radio);      // Network uses that radio
const uint16_t this_node = 00;    // Address of our node
const uint16_t other_node = 011;   // Address of the other node

struct payload_t {                 // Structure of our payload
  byte addr;
  byte device;
  byte val;
  byte repeate;
  byte ack;
};


void setup(void)
{
  Serial.begin(9600);
  Serial.println("RF24Network/examples/helloworld_rx/");
 
  SPI.begin();
  radio.begin();
  network.begin(/*channel*/ 90, /*node address*/ this_node);
  radio.setPALevel(RF24_PA_MAX);
  radio.setDataRate(RF24_250KBPS);
}

void loop(void){
  
  network.update();                  // Check the network regularly

  
  while ( network.available() ) {     // Is there anything ready for us?
    
    RF24NetworkHeader header;        // If so, grab it and print it out
    payload_t payload;
    network.read(header,&payload,sizeof(payload));
    Serial.print("Received from: ");
    Serial.print(header.from_node,OCT);
    Serial.print("\t");
    Serial.print(payload.addr);
    Serial.print("\t");
    Serial.print(payload.device);
    Serial.print("\t");
    Serial.print(payload.val);
    Serial.print("\t");
    Serial.print(payload.repeate);
    Serial.print("\t");
    Serial.println(payload.ack);
    
    RF24NetworkHeader ackHeader(01);//(header.from_node);
    payload.ack = 1;
    bool ok = network.write(ackHeader,&payload,sizeof(payload));
    if(ok)
      Serial.println("ACK sent.");
    else
      Serial.println("ACK failed.");
  }
}

