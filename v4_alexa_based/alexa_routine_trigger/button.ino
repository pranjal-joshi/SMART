#include "OneButton.h"

OneButton button(btn_pin, true);

void DuringLongPress(void *oneButton)
{
  if(((OneButton *)oneButton)->getPressedMs() > button_reset_timeout) {
    #ifdef DEBUG
      Serial.println("[BUTTON] Long Press - Reset Sensor");
    #endif
    task_reset = true;
  }
}

void doubleClick()
{
  #ifdef DEBUG
    Serial.println("[BUTTON] Double click - Disable Sensor");
  #endif
  alexaSensingEnabled = false;
  configLoader.addConfig(FILE_SENSOR_STATE, "false");
  alexaListener.setState((hostname + " motion sensor").c_str(), alexaSensingEnabled, alexaSensingEnabled? 100 : 0);
}

void singleClick()
{
  #ifdef DEBUG
    Serial.println("[BUTTON] Single click - Enable Sensor");
  #endif
  alexaSensingEnabled = true;
  configLoader.addConfig(FILE_SENSOR_STATE, "true");
  alexaListener.setState((hostname + " motion sensor").c_str(), alexaSensingEnabled, alexaSensingEnabled? 100 : 0);
}

void buttonSetup(void) {
  button.attachDuringLongPress(DuringLongPress, &button);
  button.attachDoubleClick(doubleClick);
  button.attachClick(singleClick);
  button.setLongPressIntervalMs(250);
}

void buttonLoop(void) {
  button.tick();
}

