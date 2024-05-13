// Creds or Constants

#define DEBUG 1

// #define NODEMCU

#ifdef NODEMCU
  #undef ESP01
#else
  #define ESP01
#endif

String VERSION = "1.0.0";

String calculate_ssid = "SmartMotion-" + String(ESP.getChipId());
const char* ssid_provision = calculate_ssid.c_str();
const char* pass_provision = "";
// const char* pass_provision = "12345678";
