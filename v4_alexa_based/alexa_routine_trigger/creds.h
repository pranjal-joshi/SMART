// Creds or Constants

#define DEBUG 0
#define NODEMCU 1
#define ESP01_S 0

#if NODEMCU == 1
  #undef ESP01
#else
  #define ESP01
  #undef NODEMCU
#endif

#if ESP01_S == 0
  #undef ESP01_S
#endif

#if DEBUG == 0
  #undef DEBUG
#endif

#if ESP01_S == 1
  String VERSION = "1.0.1s";
#else
  String VERSION = "1.0.1";
#endif

String calculate_ssid = "SmartMotion-" + String(ESP.getChipId());
const char* ssid_provision = calculate_ssid.c_str();
const char* pass_provision = "";
// const char* pass_provision = "12345678";

unsigned long button_reset_timeout = 10000;
