import 'dart:convert';
import 'package:flutter/material.dart';

import '../helpers/SmartHelper.dart';
import '../controllers/SmartSharedPref.dart';

class SmartDeviceData {
  String smartId;
  String deviceName;
  int id; // Should be 0-3 as per NoD
  IconData iconData;
  bool switchState;
  bool showTimerIcon;
  bool showMotionIcon;

  SmartDeviceData({
    @required this.smartId,
    @required this.deviceName,
    @required this.id,
    @required this.iconData,
    @required this.switchState,
    this.showTimerIcon = true,
    this.showMotionIcon = true,
  });

  SmartDeviceData.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      smartId = json[JSON_SMARTID];
      deviceName = json[JSON_DEVICENAME];
      id = int.parse(json['id']);
      iconData = IconData(
        int.parse(json['icon']),
        fontFamily: json['iconFamily'],
        fontPackage: json['iconPackage'],
      );
      switchState = json['switchState'] == 'true' ? true : false;
      showTimerIcon = json['showTimerIcon'] == 'true' ? true : false;
      showMotionIcon = json['showMotionIcon'] == 'true' ? true : false;
    } catch (e) {
      assert(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      JSON_SMARTID: smartId,
      JSON_DEVICENAME: deviceName,
      'id': id.toString(),
      'icon': iconData.codePoint.toString(),
      'iconFamily': iconData.fontFamily,
      'iconPackage': iconData.fontPackage,
      'switchState': switchState.toString(),
      'showTimerIcon': showTimerIcon.toString(),
      'showMotionIcon': showMotionIcon.toString(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  static Future<void> saveToDisk(List<SmartDeviceData> list) async {
    if (list != null) {
      final List<String> raw = list.map((e) => e.toJsonString()).toList();
      SmartSharedPreference _sp = SmartSharedPreference();
      _sp.saveStringList(key: SP_SmartDeviceData, data: raw);
    }
    return;
  }

  static Future<List<SmartDeviceData>> loadFromDisk() async {
    SmartSharedPreference _sp = SmartSharedPreference();
    List<String> raw = await _sp.loadStringList(key: SP_SmartDeviceData);
    if (raw != null) {
      final List<SmartDeviceData> list =
          raw.map((e) => SmartDeviceData.fromJsonString(e)).toList();
      return list;
    }
    return [];
  }
}
