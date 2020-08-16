import 'package:flutter/material.dart';
import 'dart:math';

import '../models/SmartConstants.dart';
import '../controllers/SmartSharedPref.dart';

class SmartWelcomeBanner extends StatefulWidget {
  @override
  _SmartWelcomeBannerState createState() => _SmartWelcomeBannerState();
}

class _SmartWelcomeBannerState extends State<SmartWelcomeBanner> {
  final sp = SmartSharedPreference();
  final randomizer = Random();
  SmartHelper helper;
  String _displayMessage;

  final messages = [
    'Welcome, ',
    'Hello, ',
    'Good to See You,',
    'Glad You Came Back, ',
    'Greetings!',
    'Hi there,',
  ];

  @override
  void initState() {
    _displayMessage = _welcomeMessage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    return FutureBuilder(
      future: _loadCredentials(),
      initialData: ['', '', 'User'],
      builder: (_, snapshot) {
        return RichText(
          text: TextSpan(
            text: _displayMessage,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: helper.isDarkModeActive
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              fontFamily: 'ProductSans',
            ),
            children: [
              TextSpan(
                text: '\n${snapshot.data[2]}',
                style: TextStyle(
                  fontSize: 42,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<String>> _loadCredentials() async {
    List<String> list = await sp.loadLoginCredentials();
    return list;
  }

  String get _welcomeMessage {
    return messages[randomizer.nextInt(messages.length)];
  }
}
