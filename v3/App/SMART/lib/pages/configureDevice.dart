import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../models/SmartConstants.dart';

class ConfigureDevice extends StatefulWidget {
  @override
  _ConfigureDeviceState createState() => _ConfigureDeviceState();
}

class _ConfigureDeviceState extends State<ConfigureDevice> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> fetchWebpage() async {
    var response = await http.get('http://192.168.4.1');
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    // print(args['ssid']);
    // print(args['info']);
    //fetchWebpage().then((value) => print(value));

    HttpClient client = HttpClient();
    // client.getUrl(Uri.parse('http://192.168.4.1/')).then(
    client.getUrl(Uri.parse('http://192.168.1.14/')).then(
      (req) {
        return req.close();
      },
    ).then(
      (response) {
        response.transform(utf8.decoder).listen(print);
      },
    );

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
