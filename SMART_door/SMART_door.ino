//Self Monitoring Analysing & reporting technology 
//SMART Home automation system.
//Author: Pranjal Joshi.
//copyright 2015. All rights reserved.

#include <NewPing.h>
#include <VirtualWire.h>
#include <SimpleTimer.h>

//---------------- DEBUGGER --------------
#define DEBUG 1
//----------------------------------------
#define ADDR 0x01      // ADDRess of each node
#define DOOR_DIST 70
#define TIMEOUT 300
#define TX_PIN 6
#define LM35 A0
#define RST_PIN 7
#define TEMP_RANGE 2
#define BAUD 2000
#define PAUSE_DELAY 700
void (*autoreset)(void) = 0;    // call this for software reset

NewPing inner(2,3,DOOR_DIST);
NewPing outer(4,5,DOOR_DIST);
SimpleTimer timer;

unsigned int innerRead, outerRead;
unsigned int tym,old_tym;
unsigned char pplCount = 0;
boolean updated = false, exitFlag = false;
unsigned char temp;
unsigned char frame[4];

void setup()
{
  vw_set_tx_pin(TX_PIN);
  vw_setup(BAUD);
  timer.setInterval(60000, sendUnconditionally);
  pinMode(RST_PIN,INPUT);
  #if DEBUG
    Serial.begin(9600);
    Serial.println("S.M.A.R.T Room monitor debugger module.\nCopyright 2015. All rights reserved.");
    Serial.println("Module Specifications: ");
    Serial.print("Wireless network ADDRess: 0x0");
    Serial.println(ADDR,HEX);
    Serial.print("Wireless baudrate: ");
    Serial.println(BAUD);
    Serial.print("SONAR ping timeout: ");
    Serial.println(TIMEOUT);
    Serial.print("SONAR max distance: ");
    Serial.println(DOOR_DIST);
    Serial.println();
  #endif
}

void loop()
{
  /*pingScan();
  if(innerRead < DOOR_DIST && innerRead != 0)
  {
    tym = old_tym = millis();
    while(tym <= old_tym + TIMEOUT)
    {
      pingScan();
      if((innerRead == 0 || innerRead >= DOOR_DIST) && outerRead < DOOR_DIST && outerRead != 0)
      {
        if(pplCount > 0)
          pplCount--;
        updated = true;
        #if DEBUG
          Serial.println("Exit detected!");
          Serial.print ("No of people in room: ");
          Serial.println((int)pplCount);
        #endif
        tym = millis();
        delay(PAUSE_DELAY);
        exitFlag = true;
        break;
      }
    }
  }
  
  if(outerRead < DOOR_DIST && outerRead != 0 && exitFlag == false)
  {
    tym = old_tym = millis();
    while(tym <= old_tym + TIMEOUT)
    {
      pingScan();
      if((outerRead == 0 || outerRead >= DOOR_DIST) && innerRead < DOOR_DIST && innerRead != 0)
      {
        pplCount++;
        updated = true;
        #if DEBUG
          Serial.println("Entry detected!");
          Serial.print ("No of people in room: ");
          Serial.println((int)pplCount);
        #endif
        tym = millis();
        delay(PAUSE_DELAY);
        break;
      }
    }
  }
  //temp = readTemp();
  //if(updated)
  {
    sendFrame();
    updated = false;
  }
  if(digitalRead(RST_PIN) == 1)
    autoreset();
  delay(15);
  exitFlag = false;*/
  
  pingScan();
  //Serial.println(innerRead);
  //Serial.println(outerRead);
  if(outerRead != 0)
  {
    pplCount++;
    Serial.print("Entry detected!  ");
    Serial.println((int)pplCount);
    updated = true;
    delay(1500);
  }
  if(innerRead != 0)
  {
    if(pplCount > 0)
      pplCount--;
    Serial.print("Exit Detected!  ");
    Serial.println((int)pplCount);
    updated = true;
    delay(1500);
  }
    if(digitalRead(RST_PIN) == 1)
    {
      autoreset();
    }
    temp = readTemp();
    if(updated)
    {
      sendFrame();
      updated = false;
    }
    timer.run();
    delay(15);
}

void pingScan()
{
  innerRead = inner.ping();
  innerRead = innerRead / US_ROUNDTRIP_CM;
  delayMicroseconds(500);
  outerRead = outer.ping();
  outerRead = outerRead / US_ROUNDTRIP_CM;
  delayMicroseconds(500);
  #if DEBUG
    /*Serial.print("Inner: ");
    Serial.println(innerRead);
    Serial.print("Outer: ");
    Serial.println(outerRead);
    Serial.flush();*/
  #endif
}

void sendFrame()
{
  frame[0] = ADDR;
  frame[1] = (unsigned char)pplCount;
  frame[2] = (unsigned char)temp;
  frame[3] = '\n';
  vw_send((unsigned char *)frame, sizeof(frame));
  vw_wait_tx();
  delay(4);
  // Retransmitt frame to avoid collision
  vw_send((unsigned char *)frame, sizeof(frame));
  vw_wait_tx();
  #if DEBUG
    Serial.print("Txed Data frame: 0x0");
    Serial.print(frame[0],HEX);
    Serial.print(" ");
    Serial.print(frame[1]);
    Serial.print(" ");
    Serial.print(frame[2]);
    Serial.print(" ");
    Serial.println(frame[3]);
  #endif
}

byte readTemp()
{
  byte temp = analogRead(LM35);
  temp = (5.0*temp*100.0)/1024.0;
  #if DEBUG
    /*Serial.print("Ambient Temperature (in 'C): ");
    Serial.println((int)temp);*/
  #endif
  return temp;
}

void sendUnconditionally()
{
  sendFrame();
}


