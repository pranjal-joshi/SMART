import 'package:flutter/foundation.dart';

import '../models/JsonModel.dart';
import '../helpers/SmartHelper.dart';

// Provider class - Manage info of all nodes
// Proivdes additional methods to get info of any node
// use 'addInfo' method in MQTT listening stream
/*
Example Data Container
[List of 'JsonNodeInfo' objects]
*/

class JsonNodeInfoProvider with ChangeNotifier {
  final bool debug;
  List<JsonNodeInfo> _deviceList = [];

  JsonNodeInfoProvider({@required this.debug});

  List<JsonNodeInfo> get deviceList {
    return [..._deviceList];
  }

  List<JsonNodeInfo> get deviceListSensorsOnly {
    return _deviceList
        .where((element) => element.deviceType == JSON_DEVICE_SENSOR)
        .toList();
  }

  List<JsonNodeInfo> get deviceListSwitchesOnly {
    return _deviceList
        .where((element) => element.deviceType == JSON_DEVICE_SWITCH)
        .toList();
  }

  void addInfo(String rawJson, var decodedJson) {
    try {
      if (decodedJson is Map) {
        if (decodedJson[JSON_TYPE] == JSON_TYPE_INFO) {
          final JsonNodeInfo i = JsonNodeInfo.fromJsonString(rawJson);
          _deviceList.removeWhere((element) => element.smartId == i.smartId);
          _deviceList.add(i);
          notifyListeners();
        }
      }
    } catch (e) {
      if (debug) print('[JsonNodeInfoProvider] EXCEPTION: $e\nJSON: $rawJson');
    }
  }

  JsonNodeInfo getInfoById(String smartId) {
    return _deviceList.firstWhere((element) => element.smartId == smartId);
  }

  List<JsonNodeInfo> getInfoByRoomName(String roomName) {
    return _deviceList
        .where((element) => element.nodeName == roomName)
        .toList();
  }

  List<JsonNodeInfo> getUpdatableNodeList(String versionToCompare) {
    List<JsonNodeInfo> list = [];
    if (versionToCompare != null) {
      try {
        final double version = double.parse(versionToCompare);
        list = _deviceList
            .where((element) => double.parse(element.version) < version)
            .toList();
      } on FormatException {
        if (debug)
          print(
              '[JsonNodeInfoProvider] -> Error while Parsing double - \'Version\'');
      }
      return list;
    }
    return list;
  }
}
