/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   09/06/2020
 * INFO     :   Source for Controlling IO connected to SMART
 * ALL RIGHTS RESERVED.
 */

#include "SmartIO.h"

byte _latch, _clk, _data, _oe;
byte _snsPinCnt = 0;
bool IO_DEBUG = false;

byte relayArray[8] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};

byte snsPinArray[NO_OF_DEVICES], snsStateArray[NO_OF_DEVICES];

ICACHE_RAM_ATTR void _isr(void);
volatile bool isInterrupted = false;

SmartIo::SmartIo(byte l, byte c, byte d, byte oe) {
  _latch = l;
  _clk = c;
  _data = d;
  _oe = oe;
  pinMode(_oe, OUTPUT);
  digitalWrite(_oe, HIGH);        // Disable OE of latch to avoid flickering
  pinMode(_latch, OUTPUT);
  pinMode(_clk, OUTPUT);
  pinMode(_data, OUTPUT);
  if(IO_DEBUG) {
    Serial.printf("[+] SmartIo: PINS -> Latch: %d, Clk: %d, Data: %d, /OE: %d\n",_latch,_clk,_data,oe);
  }
}

void SmartIo::setDebug(bool d) {
  IO_DEBUG = d;
}

bool SmartIo::addInterrupt(byte pin, std::function<void (void)>func, int mode) {
  if(_snsPinCnt < NO_OF_DEVICES) {
    snsPinArray[_snsPinCnt] = pin;
    pinMode(pin, INPUT);
    _snsPinCnt++;
    if(IO_DEBUG)
      Serial.printf("[+] SmartIo: INFO -> Added pin %d to as interrupt.",pin);
    //attachInterrupt(digitalPinToInterrupt(pin), func, mode);
    attachInterrupt(digitalPinToInterrupt(pin), _isr, mode);
    return true;
  }
  if(IO_DEBUG)
      Serial.printf("[+] SmartIo: ERROR -> Failed to add pin %d to as interrupt!",pin);
  return false;
}

void SmartIo::setState(JsonArray j) {
  byte i=0;
  byte stateVar=0;
  for(JsonVariant v : j) {
    if(v.as<byte>() == 1)
      stateVar |= relayArray[i];
    else
      stateVar &= ~(relayArray[i]);
    i++;
  }
  digitalWrite(_latch, LOW);
  shiftOut(_data, _clk, MSBFIRST, stateVar);
  digitalWrite(_latch, HIGH);
  digitalWrite(_oe, LOW);
  if(IO_DEBUG) {
    Serial.print(F("[+] SmartIo: INFO -> Setting output state = "));
    Serial.println(stateVar,BIN);
  }
}

StaticJsonDocument<NO_OF_DEVICES> SmartIo::getState(void) {
  DynamicJsonDocument doc(NO_OF_DEVICES);
  JsonArray j = doc.to<JsonArray>();
  for(byte i=0;i<_snsPinCnt;i++)
    j.add((byte)digitalRead(snsPinArray[_snsPinCnt]));
  doc.shrinkToFit();
  if(IO_DEBUG) {
    Serial.print(F("[+] SmartIo: INFO -> Read input states: "));
    serializeJson(doc, Serial);
    Serial.println();
  }
  return doc;
}

void SmartIo::enableOutput(bool out) {
  out == true ? digitalWrite(_oe, LOW) : digitalWrite(_oe, HIGH); 
}

ICACHE_RAM_ATTR void _isr(void) {
  noInterrupts();
  isInterrupted = true;
  interrupts();
}
