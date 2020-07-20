import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final color_accent = Colors.red[700].withOpacity(0.8);
final color_accent_dark = Colors.red[400];

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
      return Colors.grey[900];
    }
    return Colors.grey[200];
  }

  Color get getAppBarBackgroundColor {
    if (isDarkModeActive) {
      return Colors.black87;
    }
    return color_accent;
  }

  Color get getAppBarTextColor {
    if (isDarkModeActive) {
      return color_accent_dark;
    }
    return Colors.white;
  }

  Color get getCardBackgroudColor {
    if (isDarkModeActive) {
      return Colors.black;
    }
    return Colors.white;
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
    return [Colors.blue[400].withOpacity(0.85), Colors.deepOrange[300].withOpacity(0.85)];
  }

  void showSnackbarText(String text) {
    Scaffold.of(_context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
