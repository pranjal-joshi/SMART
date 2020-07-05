/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   09/06/2020
 * INFO     :   Source for Controlling IO connected to SMART
 * ALL RIGHTS RESERVED.
 */

#include "SmartIO.h"

uint8_t _latch, _clk, _data, _oe;
uint8_t _snsPinCnt = 0;
bool IO_DEBUG = false;

uint8_t relayArray[8] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};

uint8_t snsPinArray[NO_OF_DEVICES], snsStateArray[NO_OF_DEVICES];

bool setBySensorArray[4] = {false,false,false,false};
bool setByTimerArray[4] = {false,false,false,false};

static uint8_t stateVar=0;

SmartIo *pointerToClass;

ICACHE_RAM_ATTR static void outsideInterruptHandler(void) {
  pointerToClass->interruptHandler();
}

SmartIo::SmartIo(byte l, byte c, byte d, byte oe) {
  _latch = l;
  _clk = c;
  _data = d;
  _oe = oe;
}

void SmartIo::begin(void) {
  #if NO_OF_DEVICES == 4
    pinMode(_oe, OUTPUT);
    digitalWrite(_oe, HIGH);        // Disable OE of latch to avoid flickering
    pinMode(_latch, OUTPUT);
    pinMode(_clk, OUTPUT);
    pinMode(_data, OUTPUT);
    if(IO_DEBUG) {
      Serial.printf("[+] SmartIo: PINS -> Latch: %d, Clk: %d, Data: %d, /OE: %d\n",_latch,_clk,_data,_oe);
    }
  #endif
  #if NO_OF_DEVICES == 2
    pinMode(SW1, INPUT_PULLUP);
    pinMode(SW2, FUNCTION_3);
  #endif
  #if NO_OF_DEVICES == 1
    pinMode(SW1, INPUT_PULLUP);
  #endif
  pointerToClass = this;
}

void SmartIo::setDebug(bool d) {
  IO_DEBUG = d;
}

bool SmartIo::addInterrupt(byte pin, int mode) {
  if(_snsPinCnt < NO_OF_DEVICES) {
    snsPinArray[_snsPinCnt] = pin;
    pinMode(pin, INPUT_PULLUP);
    _snsPinCnt++;
    if(IO_DEBUG)
      Serial.printf("[+] SmartIo: INFO -> Added pin %d to as interrupt.\n",pin);
    attachInterrupt(digitalPinToInterrupt(pin), outsideInterruptHandler, mode);
    return true;
  }
  if(IO_DEBUG)
      Serial.printf("[+] SmartIo: ERROR -> Failed to add pin %d to as interrupt!",pin);
  return false;
}

void SmartIo::setState(const char* buf) {
  byte i=0;
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  deserializeJson(doc, buf);
  JsonArray j = doc.as<JsonArray>();    
  for(JsonVariant v : j) {
    if(v.as<uint8_t>() == 1)
      stateVar |= relayArray[i];
    else
      stateVar &= ~(relayArray[i]);
    i++;
  }
  if(IO_DEBUG) {
    Serial.print(F("[+] SmartIo: INFO -> Setting output state = "));
    Serial.println(stateVar,BIN);
  }
  #if NO_OF_DEVICES == 4
    digitalWrite(_latch, LOW);
    shiftOut(_data, _clk, MSBFIRST, stateVar);
    digitalWrite(_latch, HIGH);
    digitalWrite(_oe, LOW);
  #endif
  #if NO_OF_DEVICES == 2
    digitalWrite(R1, bitRead(~stateVar,0));
    digitalWrite(R2, bitRead(~stateVar,1));
  #endif
  #if NO_OF_DEVICES == 1
    digitalWrite(R1, bitRead(~stateVar,0));
  #endif
}

String SmartIo::getState(void) {
  DynamicJsonDocument doc(JSON_BUF_SIZE);
  char jBuf[JSON_BUF_SIZE];
  JsonArray j = doc.to<JsonArray>();
  for(byte i=0;i<_snsPinCnt;i++) {
    j.add((byte)digitalRead(snsPinArray[i]));
  }
  if(IO_DEBUG) {
    Serial.print(F("[+] SmartIo: INFO -> Read input states: "));
    serializeJson(doc, Serial);
    Serial.println();
  }
  serializeJson(doc, jBuf);
  return String(jBuf);
}

bool SmartIo::getRawState(uint8_t device_no) {
  return digitalRead(snsPinArray[device_no-1]);
}

void SmartIo::setRawState(uint8_t device_no, uint8_t state) {
  if(state) 
    stateVar |= relayArray[device_no-1];
  else
    stateVar &= ~(relayArray[device_no-1]);
  #if NO_OF_DEVICES == 4
    digitalWrite(_latch, LOW);
    shiftOut(_data, _clk, MSBFIRST, stateVar);
    digitalWrite(_latch, HIGH);
    digitalWrite(_oe, LOW);
  #endif
  #if NO_OF_DEVICES == 2
    digitalWrite(R1, bitRead(~stateVar,0));
    digitalWrite(R2, bitRead(~stateVar,1));
  #endif
  #if NO_OF_DEVICES == 1
    digitalWrite(R1, bitRead(~stateVar,0));
  #endif
}

void SmartIo::enableOutput(bool out) {
  out == true ? digitalWrite(_oe, LOW) : digitalWrite(_oe, HIGH); 
}

ICACHE_RAM_ATTR void SmartIo::interruptHandler(void) {
  localPointerToCallback();
}

void SmartIo::setCallback(void (*userDefinedCallback)(void)) {
   localPointerToCallback = userDefinedCallback;
}

void SmartIo::setBySensor(uint8_t device_no, bool state) {
  setBySensorArray[device_no-1] = state;
}

bool SmartIo::getBySensor(uint8_t device_no) {
  return setBySensorArray[device_no-1];
}

void SmartIo::setByTimer(uint8_t device_no, bool state) {
  setByTimerArray[device_no-1] = state;
}

bool SmartIo::getByTimer(uint8_t device_no) {
  return setByTimerArray[device_no-1];
}
