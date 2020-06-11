/*
 * SMART Node - v3.0
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   11/06/2020
 * INFO     :   Variables for sense/switch ISR
 * ALL RIGHTS RESERVED.
 */

#ifndef SMARTISR_H
#define SMARTISR_H

// Variables shared for ISR
volatile bool isInterrupted = false;
volatile unsigned long lastInterrupted = 0;

#endif
