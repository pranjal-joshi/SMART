#define AT24C1024_ADDR 0x50
#include<Wire.h>

unsigned long addr;
byte data;

void setup()
{
  TWBR = 24;
  Serial.begin(9600);
  pinMode(8,INPUT);
  digitalWrite(8,HIGH);
  Serial.println("I2C EEPROM PROGRAMMER");
}

void loop()
{
  while(Serial.available())
  {
    data = Serial.read();
    if(data == '`')
    {
      Serial.println("Enter addr: ");
      delay(200);
      while(!Serial.available());
      addr = Serial.parseInt();
      Serial.println();
      Serial.print("ADDR: ");
      Serial.println(addr);
      while(!Serial.available());
      data = Serial.read();
    }
    eepromWrite(data,addr);
    Serial.flush();
    addr++;
  }
}

void eepromWrite(byte data, uint16_t addr)
{
  Wire.beginTransmission(AT24C1024_ADDR);
  Wire.write((int)(addr >> 8));
  Wire.write((int)(addr & 0xFF));
  Wire.write(data);
  Wire.endTransmission();
}

byte eepromRead(uint16_t addr)
{
  byte result;
  Wire.beginTransmission(AT24C1024_ADDR);
  Wire.write((int)(addr >> 8));
  Wire.write((int)(addr & 0xFF));
  Wire.endTransmission();
  Wire.requestFrom(AT24C1024_ADDR,1);
  result = Wire.read();
  return result;
}
