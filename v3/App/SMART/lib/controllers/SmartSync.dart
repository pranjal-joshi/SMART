import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../controllers/SmartSharedPref.dart';
import '../models/SmartWifiConfig.dart';
import '../models/SmartConstants.dart';

class SmartSync {
  final bool debug;
  SmartSharedPreference _sp;
  List<String> _smartConfigDataList = [];

  SmartSync({@required bool this.debug}) {
    _sp = SmartSharedPreference();
  }

  Future<void> syncMqttWithSp(dynamic msg) async {
    if (msg is String) {
      var json = jsonDecode(msg);
      if (json is List<dynamic>) {
        _smartConfigDataList.clear();
        json.forEach((jsonElement) {
          if (jsonElement['type'] == SmartConfigData.type) {
            _smartConfigDataList.add(jsonElement.toString());
          }
        });
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
      }
    }
  }
}
