import 'dart:convert';
import 'package:SMART/models/SmartConstants.dart';
import 'package:flutter/material.dart';

import '../controllers/SmartSharedPref.dart';

// Model class for Room related data
class SmartRoomData {
  String name;
  IconData icon;
  List<dynamic> smartIds = List();
  static final String type = 'SmartRoomData';

  SmartRoomData({
    @required this.name,
    @required this.icon,
  });

  // Overload this == operator to avoid error with dropdown
  // This may cause some other bugs in future! Keep an eye on it!
  bool operator ==(o) => o is SmartRoomData && o.name == name && o.icon == icon;

  SmartRoomData.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      name = json['name'];
      icon = IconData(int.parse(json['icon']), fontFamily: json['fontFamily']);
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
      'fontFamily': icon.fontFamily,
      'smartIds': smartIds.toList(),
      'type': type,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  static Future<void> saveToDisk(List<SmartRoomData> list) async {
    if (list != null) {
      final List<String> raw = list.map((e) => e.toJsonString()).toList();
      SmartSharedPreference _sp = SmartSharedPreference();
      _sp.saveStringList(key: SP_SmartRoomData, data: raw);
    }
    return;
  }

  static Future<List<SmartRoomData>> loadFromDisk() async {
    SmartSharedPreference _sp = SmartSharedPreference();
    List<String> raw = await _sp.loadStringList(key: SP_SmartRoomData);
    if (raw != null) {
      final List<SmartRoomData> list =
          raw.map((e) => SmartRoomData.fromJsonString(e)).toList();
      return list;
    }
    return [];
  }

  static Future<String> loadFromDiskAsString() async {
    SmartSharedPreference _sp = SmartSharedPreference();
    List<String> raw = await _sp.loadStringList(key: SP_SmartRoomData);
    if (raw != null) return raw.toString();
    return '';
  }
}
