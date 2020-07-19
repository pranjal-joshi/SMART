import 'package:flutter/material.dart';
import 'models/SmartConstants.dart';
import 'pages/room.dart';

void main() => runApp(SmartApp());

class SmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return MaterialApp(
      title: 'SMART',
      routes: {
        route_room: (context) => Room(),
      },
      locale: Locale("en-IN"),
      initialRoute: route_room,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        accentColor: color_accent,
        fontFamily: 'ProductSans',
      ),
    );
  }
}
