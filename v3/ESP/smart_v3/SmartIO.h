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
    SmartIo(byte l, byte c, byte d, byte oe);
    void setDebug(bool);
    bool addInterrupt(byte pin, std::function<void (void)>, int mode);
    void setState(JsonDocument doc);
    StaticJsonDocument<NO_OF_DEVICES> getState(void);
    void enableOutput(bool);
};

#endif
