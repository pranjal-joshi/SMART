import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const String TEST_SMARTID = 'SMART_00DCCBB8';
const String TEST_USERNAME = 'joshi.pranjal5@gmail.com';
const String BROKER_IP = "35.222.110.118";
const int BROKER_PORT = 1883;
const String NODE_IP = 'http://192.168.4.1';

const String SMART_SSID_FILTER = "SMART_";
const String SMART_PASSWORD = "12345678";

final color_accent = Colors.red[700].withOpacity(0.8);
final color_accent_dark = Colors.red[400];
final color_white_dark = Colors.grey[200];
final color_material_dark = Colors.grey[900];
// Primary Dark Hex code = #d32f2f

// Page routes
const String route_room = '/room';
const String route_addNewDevice = '/addNewDevice_page';
const String route_configureDevice = '/configureDevice_page';
const String route_login = '/login_page';
const String route_signup = '/signup_page';
const String route_home = '/home_page';

class SmartHelper {
  BuildContext _context;

  SmartHelper({@required context}) {
    _context = context;
  }

  bool get _getDarkThemeState {
    var brightness = MediaQuery.of(_context).platformBrightness;
    if (brightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  bool get _getDarkModeState {
    final ThemeData theme = Theme.of(_context);
    if (theme.brightness == ThemeData.dark().brightness) {
      return true;
    } else {
      return false;
    }
  }

  bool get isDarkModeActive {
    if (_getDarkModeState || _getDarkThemeState) {
      return true;
    }
    return false;
  }

  Color get getAppBarBackgroundColor {
    if (isDarkModeActive) {
      return color_material_dark;
    }
    return color_accent;
  }

  Color get getAppBarTextColor {
    if (isDarkModeActive) {
      return Colors.redAccent;
    }
    return Colors.white;
  }

  Color get getSplashColor {
    if (isDarkModeActive) {
      return color_accent_dark;
    }
    return color_accent;
  }

  double get screenWidth {
    return MediaQuery.of(_context).size.width;
  }

  double get screenHeight {
    return MediaQuery.of(_context).size.height;
  }

  List<Color> get profileCardGradientColors {
    if (!isDarkModeActive) {
      return [Colors.blue[400], Colors.deepOrange[300]];
    }
    return [
      Colors.blue[400].withOpacity(0.8),
      Colors.deepOrange[300].withOpacity(0.8)
    ];
  }

  LinearGradient get textGradient {
    List<Color> col = List();
    if (!isDarkModeActive) {
      col = [Colors.blue[600], Colors.red[500]];
    } else {
      col = [
        Colors.blue[600].withOpacity(0.8),
        Colors.red[500].withOpacity(0.8)
      ];
    }
    return LinearGradient(
      colors: col,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  final ThemeData themeLight = ThemeData(
    primarySwatch: Colors.red,
    fontFamily: 'ProductSans',
    cardColor: Colors.grey[100],
    accentColor: Colors.red[700].withOpacity(0.8),
    scaffoldBackgroundColor: Colors.grey[200],
    canvasColor: Colors.grey[200],
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: color_accent.withOpacity(1),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: Colors.red[700].withOpacity(0.8),
      ),
      headline2: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.red[400],
      ),
      headline3: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      headline4: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      subtitle1: TextStyle(fontSize: 14, color: Colors.grey[600]),
      bodyText2: TextStyle(
        color: Colors.black,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: "ProductSans",
        fontSize: 18,
      ),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      elevation: 8,
      color: color_accent,
    ),
  );

  final ThemeData themeDark = ThemeData(
    primarySwatch: Colors.red,
    fontFamily: 'ProductSans',
    cardColor: color_material_dark,
    accentColor: Colors.red[400],
    scaffoldBackgroundColor: Colors.black,
    canvasColor: Colors.grey[900],
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
      backgroundColor: color_accent.withOpacity(1),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: Colors.red[400],
      ),
      headline2: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.red[400],
      ),
      headline3: TextStyle(
        fontSize: 18,
        color: color_white_dark,
      ),
      headline4: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color_white_dark,
      ),
      subtitle1: TextStyle(fontSize: 14, color: Colors.grey[600]),
      bodyText2: TextStyle(
        color: Colors.grey[200],
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: color_accent_dark,
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: "ProductSans",
        fontSize: 18,
      ),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      elevation: 8,
      color: color_material_dark,
    ),
  );

  void showSnackbarText(
    String text, {
    bool persistent = false,
    bool dismissable = true,
  }) {
    Scaffold.of(_context).hideCurrentSnackBar();
    Scaffold.of(_context)
        .showSnackBar(
          SnackBar(
            duration: persistent ? Duration(days: 1) : Duration(seconds: 4),
            content: Text(text),
          ),
        )
        .closed
        .then((reason) {
      if (reason == SnackBarClosedReason.swipe && !dismissable)
        this.showSnackbarText(
          text,
          persistent: persistent,
          dismissable: dismissable,
        );
    });
  }

  void showSnackbarTextWithGlobalKey(
    GlobalKey<ScaffoldState> key,
    String text, {
    bool persistent = false,
    bool dismissable = true,
  }) {
    key.currentState.hideCurrentSnackBar();
    key.currentState
        .showSnackBar(
          SnackBar(
            duration: persistent ? Duration(days: 1) : Duration(seconds: 4),
            content: Text(text),
          ),
        )
        .closed
        .then((reason) {
      if (reason == SnackBarClosedReason.swipe && !dismissable)
        this.showSnackbarTextWithGlobalKey(
          key,
          text,
          persistent: persistent,
          dismissable: dismissable,
        );
    });
  }
}

// Json Constants
const String JSON_TO = "to";
const String JSON_FROM = "from";
const String JSON_TO_GATEWAY = "gateway";
const String JSON_TO_APP = "app";
const String JSON_TO_NODE = "node";
const String JSON_NODEID = "nodeId";
const String JSON_SMARTID = "smartId";
const String JSON_NODENAME = "nodeName";
const String JSON_VERSION = "version";
const String JSON_DEVICE_TYPE = "deviceType";
const String JSON_DEVICE_SWITCH = "switch";
const String JSON_DEVICE_SENSOR = "sensor";
const String JSON_DEVICE_NO = "no";
const String JSON_TYPE = "type";
const String JSON_TYPE_DATA = "data";
const String JSON_TYPE_BROADCAST = "bcast";
const String JSON_TYPE_STATE = "state";
const String JSON_TYPE_STATE_REQ = "state_req";
const String JSON_TYPE_INFO = "info";
const String JSON_TYPE_FACT_RST = "factory_reset";
const String JSON_TYPE_SOFT_RST = "soft_reset";
const String JSON_TYPE_NTP = "ntp";
const String JSON_TYPE_TIMER = "timer";
const String JSON_TYPE_LINK = "link";
const String JSON_TYPE_OTA = "ota";
const String JSON_TYPE_STATUS = "status";
const String JSON_TYPE_VECTOR_LINK = "vector_link";
const String JSON_NTP_HOUR = "hour";
const String JSON_NTP_MINUTE = "minute";
const String JSON_NTP_SECOND = "second";
const String JSON_NTP_WEEKDAY = "weekday";
const String JSON_NoD = "NoD";
const String JSON_TOPIC = "topic";
const String JSON_ENABLE = "enable";
const String JSON_DISABLE = "disable";
const String JSON_SENSOR_MOTION = "motion";
const String JSON_SENSOR_TIMEOUT = "timeout";
const String JSON_SENSOR_EN_HR = "eh";
const String JSON_SENSOR_EN_MIN = "em";
const String JSON_SENSOR_DS_HR = "dh";
const String JSON_SENSOR_DS_MIN = "dm";
const String JSON_STATUS_ONLINE = "online";
const String JSON_STATUS_OFFLINE = "offline";
const String JSON_STATUS_BUSY = "busy";

// SharedPreferences keys
const String SP_SwitchboardRowList = "sp_SwitchboardRowList";
const String SP_SmartConfigData = "sp_SmartConfigData";
const String SP_SmartMqttPublishBuffer = "sp_SmartMqttPublishBuffer";
const String SP_SmartRoomData = "sp_SmartRoomData";
const String SP_LoginState = "sp_LoginState";
const String SP_LoginCredentials = "sp_LoginCredentials";
