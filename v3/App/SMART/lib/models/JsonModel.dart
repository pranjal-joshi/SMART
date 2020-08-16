import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/SmartConstants.dart';

class JsonAppToNodeSwitchState {
  final String to = 'gateway';
  final String from = 'app';
  final String type = 'state';
  final String smartId;
  final List<int> dataList;

  JsonAppToNodeSwitchState({
    @required this.smartId,
    @required this.dataList,
  });

  Map<String, dynamic> toJson() {
    return {
      JSON_TO: to,
      JSON_FROM: from,
      JSON_TYPE: type,
      JSON_SMARTID: smartId,
      JSON_TYPE_DATA: dataList
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

class JsonNodeToAppSwitchState {
  String topic;
  String from;
  String type;
  String smartId;
  String nodeName;
  List<int> dataList;

  JsonNodeToAppSwitchState.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      type = json[JSON_TYPE];
      from = json[JSON_FROM];
      topic = json[JSON_TOPIC];
      smartId = json[JSON_SMARTID];
      nodeName = json[JSON_NODENAME];
      dataList = json[JSON_TYPE_DATA].cast<int>();
    } catch (e) {}
  }
}

class JsonNodeInfo {
  String from;
  String type;
  String deviceType;
  String nodeName;
  int nod;
  String version;
  String to;
  String smartId;

  JsonNodeInfo.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      type = json[JSON_TYPE];
      from = json[JSON_FROM];
      deviceType = json[JSON_DEVICE_TYPE];
      nodeName = json[JSON_NODENAME];
      try {
        nod = int.parse(json[JSON_NoD]);
      } catch (_) {
        nod = json[JSON_NoD];
      } finally {
        if (nod == null) nod = 0;
      }
      version = json[JSON_VERSION];
      to = json[JSON_TO];
      smartId = json[JSON_SMARTID];
    } catch (e) {}
  }
}

class JsonNodeStatus extends ChangeNotifier {
  String type;
  String smartId;
  String status;
  static List<JsonNodeStatus> _deviceList = List<JsonNodeStatus>();

  JsonNodeStatus();

  void addDevice(String rawJson) {
    var json = jsonDecode(rawJson);
    if (json[JSON_TYPE] == JSON_TYPE_STATUS) {
      final JsonNodeStatus s = JsonNodeStatus.fromJsonString(rawJson);
      _deviceList.add(s);
      notifyListeners();
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

  JsonNodeStatus.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      type = json[JSON_TYPE];
      smartId = json[JSON_SMARTID];
      status = json[JSON_TYPE_STATUS];
    } catch (e) {}
  }
}
