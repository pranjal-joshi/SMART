import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/JsonNodeStatusProvider.dart';
import 'providers/JsonRoomStateProvider.dart';
import 'providers/JsonNodeInfoProvider.dart';
import 'providers/JsonNodeLabelProvider.dart';
import 'providers/ConnectivityProvider.dart';

import 'helpers/SmartHelper.dart';

import 'pages/room.dart';
import 'pages/room_page.dart';
import 'pages/device_page.dart';
import 'pages/add_new_device_page.dart';
import 'pages/configure_device_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(SmartApp());
}

class SmartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => JsonNodeStatusProvider(debug: smartGlobalDebug),
        ),
        ChangeNotifierProvider(
          create: (ctx) => JsonRoomStateProvider(debug: smartGlobalDebug),
        ),
        ChangeNotifierProvider(
          create: (ctx) => JsonNodeInfoProvider(debug: smartGlobalDebug),
        ),
        ChangeNotifierProxyProvider<JsonRoomStateProvider,
            JsonNodeLabelProvider>(
          create: (ctx) => JsonNodeLabelProvider(debug: smartGlobalDebug),
          update: (ctx, stateProvider, labelProvider) =>
              labelProvider..roomStateProvider = stateProvider,
        ),
        StreamProvider<ConnectivityProviderResult>(
          create: (ctx) => ConnectivityProvider().connectivityStream,
        ),
      ],
      child: MaterialApp(
        title: 'SMART',
        routes: {
          route_login: (context) => LoginPage(),
          route_signup: (context) => SignupPage(),
          route_forgot_pass: (context) => ForgotPasswordPage(),
          route_home: (context) => HomePage(),
          route_room: (context) => Room(),
          route_room_page: (context) => RoomPage(),
          route_device_page: (context) => DevicePage(),
          route_addNewDevice: (context) => AddNewDevicePage(),
          route_configureDevice: (context) => ConfigureDevicePage(),
        },
        locale: Locale('en', 'IN'),
        // initialRoute: route_login,
        initialRoute: route_home,
        themeMode: ThemeMode.system,
        theme: helper.themeLight,
        darkTheme: helper.themeDark,
      ),
    );
  }
}
