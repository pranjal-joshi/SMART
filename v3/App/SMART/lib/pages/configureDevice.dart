import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';

class ConfigureDevice extends StatefulWidget {
  @override
  _ConfigureDeviceState createState() => _ConfigureDeviceState();
}

class _ConfigureDeviceState extends State<ConfigureDevice> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    print(args['ssid']);
    print(args['info']);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text("Implement Connection Details form here..."),
            Text(args['ssid']),
            Text(args['info']),
          ],
        ),
      ),
    );
  }
}
