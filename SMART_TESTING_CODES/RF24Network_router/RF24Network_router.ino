#include <RF24Network.h>
#include <RF24.h>
#include <SPI.h>

RF24 radio(9,10);
RF24Network network(radio);   

const uint16_t router = 01;

struct payload_t {                  // Structure of our payload
  byte addr;
  byte device;
  byte val;
  byte repeate;
  byte ack;
};

void setup(void)
{
  Serial.begin(9600);
  Serial.println("RF24Network/DataRouter");
 
  SPI.begin();
  radio.begin();
  network.begin(/*channel*/ 90, /*node address*/ router);
  radio.setPALevel(RF24_PA_MAX);
  radio.setDataRate(RF24_250KBPS);
}

void loop()
{
  network.update();
  
  while(network.available())
  {
    RF24NetworkHeader header;
    payload_t payload;
    network.read(header,&payload,sizeof(payload));
    Serial.print("Received: ");
    Serial.print(payload.addr);
    Serial.print("\t");
    Serial.print(payload.device);
    Serial.print("\t");
    Serial.print(payload.val);
    Serial.print("\t");
    Serial.print(payload.repeate);
    Serial.print("\t");
    Serial.println(payload.ack);
    payload.repeate = 1;
    if(payload.ack == 0)
    {
      RF24NetworkHeader retransmit(00);
      bool ok = network.write(retransmit,&payload,sizeof(payload));
    }
    else
    {
      RF24NetworkHeader retransmit(011);
      bool ok = network.write(retransmit,&payload,sizeof(payload));
    }
  }
  delay(1);
}
