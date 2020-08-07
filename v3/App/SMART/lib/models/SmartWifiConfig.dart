import 'dart:convert';
import 'package:SMART/models/SmartConstants.dart';
import 'package:flutter/foundation.dart';

import '../controllers/SmartSharedPref.dart';

class SmartConfigData {
  String smartId;
  String ssid;
  String pass;
  String channel;
  String meshSsid;
  String meshPass;
  String username;
  String nodename;
  String mqttIp;
  String mqttPort;
  static final String type = 'SmartConfigData';

  SmartConfigData({
    @required this.smartId,
    @required this.ssid,
    @required this.pass,
    @required this.channel,
    @required this.meshSsid,
    @required this.meshPass,
    @required this.username,
    @required this.nodename,
    @required this.mqttIp,
    @required this.mqttPort,
  });

  Map<String, dynamic> toJson() {
    return {
      'smartId': smartId,
      'ssid': ssid,
      'pass': pass,
      'channel': channel,
      'meshSsid': meshSsid,
      'meshPass': meshPass,
      'username': username,
      'nodename': nodename,
      'mqttIp': mqttIp,
      'mqttPort': mqttPort,
      'type': type,
    };
  }

  SmartConfigData.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      smartId = json['smartId'];
      ssid = json['ssid'];
      pass = json['pass'];
      channel = json['channel'];
      meshSsid = json['meshSsid'];
      meshPass = json['meshPass'];
      username = json['username'];
      nodename = json['nodename'];
      mqttIp = json['mqttIp'];
      mqttPort = json['mqttPort'];
    } catch (_) {}
  }

  static Future<List<SmartConfigData>> loadFromDisk() async {
    SmartSharedPreference _sp = SmartSharedPreference();
    List<String> raw = await _sp.loadStringList(key: SP_SmartConfigData);
    if (raw != null) {
      final List<SmartConfigData> list =
          raw.map((e) => SmartConfigData.fromJsonString(e)).toList();
      return list;
    }
    return null;
  }

  static Future<void> saveToDisk(List<SmartConfigData> list) async {
    if (list != null) {
      final List<String> raw = list.map((e) => jsonEncode(e.toJson())).toList();
      SmartSharedPreference _sp = SmartSharedPreference();
      _sp.saveStringList(key: SP_SmartConfigData, data: raw);
    }
    return;
  }
}

class SmartWifiConfig {
  String ssid;
  int rssi;
  int channel;

  SmartWifiConfig({
    @required this.ssid,
    @required this.rssi,
    @required this.channel,
  });

  SmartWifiConfig.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      ssid = json[0];
      rssi = int.parse(json[1]);
      channel = int.parse(json[2]);
    } catch (_) {}
  }
}
