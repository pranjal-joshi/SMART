import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../models/JsonModel.dart';
import '../models/SmartConstants.dart';

class JsonNodeStatusProvider with ChangeNotifier {
  List<JsonNodeStatus> _deviceList = List<JsonNodeStatus>();

  void addDevice(String rawJson) {
    var json = jsonDecode(rawJson);
    try {
      if (json[JSON_TYPE] == JSON_TYPE_STATUS) {
        final JsonNodeStatus s = JsonNodeStatus.fromJsonString(rawJson);
        _deviceList.removeWhere((element) => element.smartId == s.smartId);
        _deviceList.add(s);
        print('Device Added');
        notifyListeners();
      }
    } catch (_) {}
  }

  List<JsonNodeStatus> get deviceList {
    return [..._deviceList];
  }

  int get totalDeviceCount {
    return _deviceList.length;
  }

  int get onlineDeviceCount {
    return _deviceList
        .where((element) => element.status == JSON_STATUS_ONLINE)
        .toList()
        .length;
  }

  int get offlineDeviceCount {
    return _deviceList
        .where((element) => element.status == JSON_STATUS_OFFLINE)
        .toList()
        .length;
  }

  int get busyDeviceCount {
    return _deviceList
        .where((element) => element.status == JSON_STATUS_BUSY)
        .toList()
        .length;
  }

  Map<String, String> get getActiveMessage {
    if (onlineDeviceCount == 0)
      return {
        'title': 'No Devices',
        'subtitle': 'Add Devices to Get Started',
      };
    else if(onlineDeviceCount == 1)
      return {
        'title': '$onlineDeviceCount Device',
        'subtitle': 'Active and Online',
      };
    else if(onlineDeviceCount > 1)
      return {
        'title': '$onlineDeviceCount Devices',
        'subtitle': 'Active and Online',
      };
  }
}
