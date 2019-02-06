/*
 * SMART_2.0 NODE CONFIG FILE
 * AUTHOR   :   PRANJAL JOSHI
 * DATE     :   02/06/2019
 * ALL RIGHTS RESERVED.
 */

// CONTROL DEBUG
#define DEBUG       true
#define BLYNK_PRINT Serial
#define VERSION     "1.0"

// HARDWARE CONFIG
#define AP_MODE_SW  D3

// WIRELESS CONFIG
#define CLI_SSID    "The EVIL GENIUS"
#define CLI_PASS    "samadhan118017"
#define AUTH        "c04b185fe0e74f3ea6d6fabc6708a6dd"
#define AP_SSID     "SMART-Node"
#define AP_PASS     "node@smart"
#define CON_TIMEOUT 8000

// VIRTUAL PINS FOR BLYNK APP
#define V_TERM      100
#define V_STATUS    101
#define V_JSON      200

// RELAY CONTROL PORT: MCP23017-PORT_A
#define MA0         0
#define MA1         1
#define MA2         2
#define MA3         3
#define MA4         4
#define MA5         5
#define MA6         6
#define MA7         7

// AC SENSING PORT: MCP23017-PORT_B
#define MB0         8
#define MB1         9
#define MB2         10
#define MB3         11
#define MB4         12
#define MB5         13
#define MB6         14
#define MB7         15
