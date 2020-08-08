import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../controllers/SmartSharedPref.dart';
import '../models/SmartWifiConfig.dart';
import '../models/SmartConstants.dart';
import '../models/SmartRoomData.dart';

class SmartSync {
  final bool debug;
  SmartSharedPreference _sp;
  List<String> _smartConfigDataList = [];
  List<String> _smartRoomDataList = [];

  SmartSync({@required this.debug}) {
    _sp = SmartSharedPreference();
  }

  Future<void> syncMqttWithSp(dynamic msg) async {
    if (msg is String) {
      var json = jsonDecode(msg);
      if (json is List<dynamic>) {
        // Clear Buffers
        _smartConfigDataList.clear();
        _smartRoomDataList.clear();
        // Check Types of all received messages and them into appropriate lists
        try {
          // For Lists
          json.forEach((jsonElement) {
            _runSmartSyncLogic(jsonElement);
          });
        } catch (_) {
          // For Nested Lists
          json.forEach((j) {
            j.forEach((jsonElement) {
              _runSmartSyncLogic(jsonElement);
            });
          });
        } finally {
          // Add 'SmartConfigData' data from MQTT to Shared Pref
          if (_smartConfigDataList.isNotEmpty) {
            if (debug)
              print(
                  '[SmartSync] Saving \'$SP_SmartConfigData\' -> ${_smartConfigDataList.toString()}');
            _sp.saveStringList(
              key: SP_SmartConfigData,
              data: _smartConfigDataList,
            );
          }
          if (_smartRoomDataList.isNotEmpty) {
            if (debug)
              print(
                  '[SmartSync] Saving \'$SP_SmartRoomData\' -> ${_smartRoomDataList.toString()}');
            _sp.saveStringList(
              key: SP_SmartRoomData,
              data: _smartRoomDataList,
            );
          }
        }
      }
    }
  }

  // Add conditional checks in this method to avoid code repeating
  void _runSmartSyncLogic(dynamic jsonElement) {
    if (jsonElement['type'] == SmartConfigData.type) {
      _smartConfigDataList.add(jsonEncode(jsonElement));
    } else if (jsonElement['type'] == SmartRoomData.type) {
      _smartRoomDataList.add(jsonEncode(jsonElement));
    }
  }
}
