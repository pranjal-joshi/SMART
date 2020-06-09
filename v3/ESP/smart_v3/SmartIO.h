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
    void setDebug(bool);
    bool attachInterrupt(byte pin, std::function<void (void)>, int mode);
    void detachInterrupt(byte pin);
    void setState(JsonArray j);
    StaticJsonDocument<NO_OF_DEVICES> getState(void);
    void enableOutput(bool);
};

#endif
