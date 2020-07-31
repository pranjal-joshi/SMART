import 'package:flutter/material.dart';

import 'models/SmartConstants.dart';

import 'pages/room.dart';
import 'pages/addNewDevice.dart';
import 'pages/configureDevice.dart';


void main() => runApp(SmartApp());

class SmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return MaterialApp(
      title: 'SMART',
      routes: {
        route_room: (context) => Room(),
        route_addNewDevice: (context) => AddNewDevice(),
        route_configureDevice: (context) => ConfigureDevice(),
      },
      locale: Locale("en-IN"),
      // initialRoute: route_room,
      // initialRoute: route_addNewDevice,
      initialRoute: route_configureDevice,
      themeMode: ThemeMode.system,
      theme: helper.themeLight,
      darkTheme: helper.themeDark,
    );
  }
}
