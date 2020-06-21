/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   09/06/2020
 * INFO     :   Header for Controlling IO connected to SMART
 * ALL RIGHTS RESERVED.
 */

#ifndef SMARTIO_H
#define SMARTIO_H

#include <ArduinoJson.h>
#include "SmartConstants.h"

class SmartIo {
  public:
    SmartIo(byte l, byte c, byte d, byte oe);
    void begin(void);
    void setDebug(bool);
    bool addInterrupt(byte pin, int mode);
    void setState(const char* buf);
    void setCallback(void (*userDefinedCallback)(void));
    ICACHE_RAM_ATTR void interruptHandler(void);
    String getState(void);
    bool getRawState(uint8_t device_no);
    void setRawState(uint8_t device_no, uint8_t state);
    void enableOutput(bool);
  private:
    void (*localPointerToCallback)(void);
};

#endif
