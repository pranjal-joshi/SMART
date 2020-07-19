import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final color_accent = Colors.purple[600];
final color_accent_dark = Colors.purple[400];

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

}
