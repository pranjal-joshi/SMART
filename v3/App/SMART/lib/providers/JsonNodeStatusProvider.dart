import 'package:flutter/foundation.dart';

import '../models/JsonModel.dart';
import '../helpers/SmartHelper.dart';

// Provider class - Manage status of all nodes along with their parent room
// Proivdes additional methods to get status of rooms
// use 'addDevice' method in MQTT listening stream
/*
Example Data Container
{
  'room a': {
    'smart_1': 'online',
    'smart_2': 'offline',
  }
  'room b': {
    'smart_3': 'busy'
  }
}
*/
class JsonNodeStatusProvider with ChangeNotifier {
  final bool debug;
  List<JsonNodeStatus> _deviceList = List<JsonNodeStatus>();

  JsonNodeStatusProvider({@required this.debug});

  void addDevice(String rawJson, var decodedJson) {
    try {
      if (decodedJson is Map) {
        if (decodedJson[JSON_TYPE] == JSON_TYPE_STATUS) {
          final JsonNodeStatus s = JsonNodeStatus.fromJsonString(rawJson);
          _deviceList.removeWhere((element) => element.smartId == s.smartId);
          _deviceList.add(s);
          notifyListeners();
        }
      }
    } catch (e) {
      if (debug)
        print('[JsonNodeStatusProvider] EXCEPTION: $e\nJSON: $rawJson');
    }
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
    else if (onlineDeviceCount == 1)
      return {
        'title': '$onlineDeviceCount Device',
        'subtitle': 'Active and Online',
      };
    else
      return {
        'title': '$onlineDeviceCount Devices',
        'subtitle': 'Active and Online',
      };
  }
}
