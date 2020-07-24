import 'dart:convert';
import 'SmartConstants.dart';
import 'package:flutter/material.dart';

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
      JSON_TO : to,
      JSON_FROM : from,
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
  final String from = JSON_TO_NODE;
  final String type = JSON_TYPE_STATE;
  String smartId;
  List<int> dataList;

  JsonNodeToAppSwitchState.fromJsonString(String rawJson) {
    rawJson = rawJson.replaceAll('\'', '\"');
    Map<String, dynamic> json = jsonDecode(rawJson);
    topic = json[JSON_TOPIC];
    smartId = json[JSON_SMARTID];
    dataList = json[JSON_TYPE_DATA].cast<int>();
  }
}
