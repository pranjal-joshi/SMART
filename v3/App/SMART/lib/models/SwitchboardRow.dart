import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';

class SwitchboardRow {
  String deviceName;
  String deviceDescription;
  bool deviceState;
  IconData deviceIcon;
  String smartId;
  String type = "SwitchboardRow";

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
      type = json['type'];
      deviceName = json['name'];
      deviceDescription = json['description'];
      deviceState = json['state'].cast<bool>();
      deviceIcon = IconData(json['iconCode'], fontFamily: 'MaterialIcons');
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': deviceName,
      'description': deviceDescription,
      'state': deviceState,
      'icon': deviceIcon.codePoint,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
