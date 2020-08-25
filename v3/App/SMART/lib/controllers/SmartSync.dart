import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/SmartHelper.dart';

import '../controllers/SmartSharedPref.dart';

import '../models/SmartWifiConfig.dart';
import '../models/SmartRoomData.dart';
import '../models/SmartDeviceData.dart';

import '../providers/JsonNodeStatusProvider.dart';
import '../providers/JsonRoomStateProvider.dart';
import '../providers/JsonNodeInfoProvider.dart';
import '../providers/JsonNodeLabelProvider.dart';

// Utility Class to manage Syncing of MQTT message with local storage
class SmartSync {
  final bool debug;
  SmartSharedPreference _sp;
  List<String> _smartConfigDataList = [];
  List<String> _smartRoomDataList = [];
  List<String> _smartDeviceDataList = [];

  SmartSync({@required this.debug}) {
    _sp = SmartSharedPreference();
  }

  // Sync incoming data with provider classes if possible
  void syncMqttWithProviders(
    BuildContext context,
    String rawJson,
    var decodedJson,
  ) {
    Provider.of<JsonRoomStateProvider>(context, listen: false)
        .addState(rawJson, decodedJson);
    Provider.of<JsonNodeStatusProvider>(context, listen: false)
        .addDevice(rawJson, decodedJson);
    Provider.of<JsonNodeInfoProvider>(context, listen: false)
        .addInfo(rawJson, decodedJson);
    Provider.of<JsonNodeLabelProvider>(context, listen: false)
        .addLabel(rawJson, decodedJson);
  }

  // Sync incomming MQTT messages into their respective storages
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
          // Sync 'SmartConfigData' data from MQTT to Shared Pref
          if (_smartConfigDataList.isNotEmpty) {
            if (debug)
              print(
                  '[SmartSync] Saving \'$SP_SmartConfigData\' -> ${_smartConfigDataList.toString()}');
            _sp.saveStringList(
              key: SP_SmartConfigData,
              data: _smartConfigDataList,
            );
          }
          // Sync 'SmartRoomData' data from MQTT to Shared Pref
          if (_smartRoomDataList.isNotEmpty) {
            if (debug)
              print(
                  '[SmartSync] Saving \'$SP_SmartRoomData\' -> ${_smartRoomDataList.toString()}');
            _sp.saveStringList(
              key: SP_SmartRoomData,
              data: _smartRoomDataList,
            );
          }
          // Sync 'SmartDeviceData' data from MQTT to Shared Pref
          if (_smartDeviceDataList.isNotEmpty) {
            if (debug)
              print(
                  '[SmartSync] Saving \'$SP_SmartDeviceData\' -> ${_smartDeviceDataList.toString()}');
            _sp.saveStringList(
              key: SP_SmartDeviceData,
              data: _smartDeviceDataList,
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
    } else if (jsonElement['type'] == SmartDeviceData.type) {
      _smartDeviceDataList.add(jsonEncode(jsonElement));
    }
  }
}
