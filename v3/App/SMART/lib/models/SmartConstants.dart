import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final color_accent = Colors.red[700].withOpacity(0.8);
final color_accent_dark = Colors.red[400];
final color_white_dark = Colors.grey[200];
final color_material_dark = Colors.grey[900];

const String route_room = '/room';

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

  Color get getBackgroundColor {
    if (isDarkModeActive) {
      return Colors.black;
    }
    return Colors.grey[200];
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

  Color get getCardBackgroudColor {
    if (isDarkModeActive) {
      return color_material_dark;
    }
    return Colors.grey[50];
  }

  Color get getCardBorderColor {
    if (!isDarkModeActive) {
      return Colors.black;
    }
    return color_accent_dark;
  }

  Color get getTextHeadingColor {
    if (isDarkModeActive) {
      return color_accent_dark;
    }
    return color_accent;
  }

  Color get getTextBodyColor {
    if (!isDarkModeActive) {
      return Colors.black;
    }
    return Colors.white;
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
      Colors.blue[400].withOpacity(0.7),
      Colors.deepOrange[300].withOpacity(0.7)
    ];
  }

  final ThemeData themeLight = ThemeData(
    primarySwatch: Colors.red,
    fontFamily: 'ProductSans',
    cardColor: Colors.grey[100],
    accentColor: Colors.red[700].withOpacity(0.8),
    scaffoldBackgroundColor: Colors.grey[200],
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
        fontSize: 16,
        color: color_white_dark,
      ),
      bodyText2: TextStyle(
        color: Colors.grey[200],
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: color_accent_dark.withOpacity(0.8),
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

  void showSnackbarText(String text) {
    Scaffold.of(_context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
