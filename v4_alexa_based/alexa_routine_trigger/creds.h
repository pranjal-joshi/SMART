// Creds or Constants

#define DEBUG 0
#define NODEMCU 0

#if NODEMCU == 1
  #undef ESP01
#else
  #define ESP01
  #undef NODEMCU
#endif

#if DEBUG == 0
  #undef DEBUG
#endif

String VERSION = "1.0.0";

String calculate_ssid = "SmartMotion-" + String(ESP.getChipId());
const char* ssid_provision = calculate_ssid.c_str();
const char* pass_provision = "";
// const char* pass_provision = "12345678";

unsigned long button_reset_timeout = 10000;
