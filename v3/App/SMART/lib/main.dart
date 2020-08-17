import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/JsonNodeStatusProvider.dart';

import 'models/SmartConstants.dart';

import 'pages/room.dart';
import 'pages/add_new_device_page.dart';
import 'pages/configure_device_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/home_page.dart';

void main() => runApp(SmartApp());

class SmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => JsonNodeStatusProvider()),
      ],
      child: MaterialApp(
        title: 'SMART',
        routes: {
          route_login: (context) => LoginPage(),
          route_signup: (context) => SignupPage(),
          route_forgot_pass: (context) => ForgotPasswordPage(),
          route_home: (context) => HomePage(),
          route_room: (context) => Room(),
          route_addNewDevice: (context) => AddNewDevicePage(),
          route_configureDevice: (context) => ConfigureDevicePage(),
        },
        locale: Locale('en', 'IN'),
        initialRoute: route_login,
        // initialRoute: route_home,
        themeMode: ThemeMode.system,
        theme: helper.themeLight,
        darkTheme: helper.themeDark,
      ),
    );
  }
}
