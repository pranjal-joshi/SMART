import 'dart:convert';

import 'package:flutter/material.dart';

class SmartRoomData {
  String name;
  IconData icon;
  List<dynamic> smartIds = List();
  final String type = 'SmartRoomData';

  SmartRoomData({
    @required this.name,
    @required this.icon,
  });

  SmartRoomData.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      name = json['name'];
      icon = IconData(int.parse(json['icon']));
      smartIds = json['smartIds'];
    } catch (e) {
      print(e);
    }
  }

  void addSmartId(String id) {
    smartIds.add(id);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon.codePoint.toString(),
      'smartIds': smartIds.toList(),
      'type': type,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
