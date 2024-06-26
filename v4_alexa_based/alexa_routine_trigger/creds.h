// Creds or Constants

#define DEBUG 1
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
  String FIRMWARE_VERSION = "1.0.0s";
#elif NODEMCU == 1
  String FIRMWARE_VERSION = "1.0.0n";
#else
  String FIRMWARE_VERSION = "1.0.0";
#endif

String calculate_ssid = "SmartMotion-" + String(ESP.getChipId());
const char* ssid_provision = calculate_ssid.c_str();
const char* pass_provision = "";
// const char* pass_provision = "12345678";

unsigned long button_reset_timeout = 10000;
unsigned long ignore_sensor_timeout = 4000;
