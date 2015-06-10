/*
	SELF MONITORING ANALYSING AND REPORTING TECHNOLOGY
	ROOM MODULE.
	AUTHOR	:	PRANJAL P JOSHI.
	DATE		:	10/6/2015
	
	READ PIR SENSORS AS ENTRY/EXIT DETECTION AND READ PUSH-BUTTON SWITCHES.
*/

#include <reg52.h>

// PIR hardware pins
sbit PIR1 = P2^0;
sbit PIR2 = P2^1;

// address of node (must be distinct for each room)
#define ADDRESS 0x01

// delay config for timer interrupt
#define PIR_DELAY 5050
#define DBOUNCE_DELAY 300

unsigned char port;
unsigned char radioFrame[3];
volatile unsigned int counter[3];
volatile unsigned char trigger[3];
unsigned char pplCount = 0;
volatile unsigned char isPressed,isPir1,isPir2;
unsigned char radioActive = 0;

void serialInit()
{
	// BAUD: 2400, Crystal: 11.0592Mhz
	TMOD |= 0x20;
	SCON = 0x50;
	TH1 = 0xF4;
	TL1 = 0xF4;
	TR1 =1;
	TI = 1;
}

void timerLoad()
{
	// reload timer
	// approx 1ms @ 11.05MHz
	TH0 = 0xFC;
	TL0 = 0x45;
}

void timerInit()
{
	// init timer 0 interrupt
	TMOD |= 0x01;
	timerLoad();
	ET0 = 1;
	EA = 1;
	TR0 = 1;
}

void serialWrite(unsigned char c)
{
	// write byte to serial
	while(!TI);
	TI = 0;
	SBUF = c;
}

void rfWrite(unsigned char d)
{
	// radio data framming format
	serialWrite('@');
	serialWrite('#');
	serialWrite(d);
	serialWrite(~(d));
	serialWrite('$');
}

void rfPrint()
{
	// transmit radio data frame
	if(radioActive)
	{
		rfWrite(radioFrame[0]);
		rfWrite(radioFrame[1]);
		rfWrite(radioFrame[2]);
		rfWrite('\n');
		rfWrite('\r');
	}
	radioActive = 0;
}

void main()
{
	// initialize
	serialInit();
	timerInit();
	P1 = 0xFF;
	PIR1 = 1;
	PIR2 = 1;
	radioFrame[0] = ADDRESS;
	// keep executing
	while(1)
	{
		// read switches & check for pressed one.
		port = P1;
		if(port != 0xFF && !isPressed)
		{
			isPressed = 1;
			trigger[0] = 1;
			radioFrame[1] = port;
			radioActive = 1;
		}
		// read PIR sensor 1.
		if(PIR1 && !isPir1)
		{
			isPir1 = 1;
			trigger[1] = 1;
			pplCount++;
			radioFrame[2] = pplCount;
			radioActive = 1;
		}
		// read PIR sensor 2.
		if(PIR2 && !isPir2)
		{
			isPir2 = 1;
			trigger[2] = 1;
			if(pplCount > 0)
				pplCount--;
			radioFrame[2] = pplCount;
			radioActive = 1;
		}
		// transmit data if necessary.
		rfPrint();
	}
}

void timerISR(void) interrupt 1
{
	// reload timer
	TR0 = 0;
	timerLoad();
	TR0 = 1;
	
	// timeout decesion making
	if(trigger[0])
	{
		counter[0] = 0;
		trigger[0] = 0;
	}
	if(trigger[1])
	{
		counter[1] = 0;
		trigger[1] = 0;
	}
	if(trigger[2])
	{
		counter[2] = 0;
		trigger[2] = 0;
	}
	
	counter[0]++;
	counter[1]++;
	counter[2]++;
	
	if(counter[0] > DBOUNCE_DELAY)
	{
		isPressed = 0;
	}
	if(counter[1] > PIR_DELAY)
	{
		isPir1 = 0;
	}
	if(counter[2] > PIR_DELAY)
	{
		isPir2 = 0;
	}
	
}