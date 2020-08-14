import 'package:SMART/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'models/SmartConstants.dart';

import 'pages/room.dart';
import 'pages/add_new_device_page.dart';
import 'pages/configure_device_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';


void main() => runApp(SmartApp());

class SmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return MaterialApp(
      title: 'SMART',
      routes: {
        route_login: (context) => LoginPage(),
        route_signup: (context) => SignupPage(),
        route_home: (context) => HomePage(),
        route_room: (context) => Room(),
        route_addNewDevice: (context) => AddNewDevicePage(),
        route_configureDevice: (context) => ConfigureDevicePage(),
      },
      locale: Locale('en','IN'),
      initialRoute: route_login,
      // initialRoute: route_addNewDevice,
      themeMode: ThemeMode.system,
      theme: helper.themeLight,
      darkTheme: helper.themeDark,
    );
  }
}
