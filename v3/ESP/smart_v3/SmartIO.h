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
    volatile bool isInterrupted;
    volatile unsigned long lastInterrupted;
    SmartIo(byte l, byte c, byte d, byte oe);
    void begin(void);
    void setDebug(bool);
    bool addInterrupt(byte pin, int mode);
    //void setState(const JsonDocument doc);
    void setState(JsonVariant doc);
    StaticJsonDocument<JSON_BUF_SIZE> getState(void);
    void enableOutput(bool);
};

#endif
