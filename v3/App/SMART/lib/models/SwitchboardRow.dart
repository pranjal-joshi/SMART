import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';

class SwitchboardRow {
  String deviceName;
  String deviceDescription;
  bool deviceState;
  IconData deviceIcon;
  String smartId;

  SwitchboardRow({
    this.deviceName,
    this.deviceDescription,
    this.deviceState,
    this.deviceIcon,
    this.smartId = TEST_SMARTID,
  });

  SwitchboardRow.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      deviceName = json['name'];
      deviceDescription = json['description'];
      deviceState = json['state'].cast<bool>();
      deviceIcon = json['icon'];
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    return {
      'name': deviceName,
      'description': deviceDescription,
      'state': deviceState,
      // 'icon': deviceIcon,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}