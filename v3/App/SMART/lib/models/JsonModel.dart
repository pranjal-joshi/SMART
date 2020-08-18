import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';

// This file contains classes that acts as a model of data
// This models are serialized and deserialized for communication between Broker & App
// This models should be used to convert raw data into objects of data packets for processing

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

class JsonNodeStatus {
  String type;
  String smartId;
  String status;

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