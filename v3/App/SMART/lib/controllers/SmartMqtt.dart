import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../models/SmartConstants.dart';

enum SmartMqttTopic {
  SwitchStateAppToNode,
  SwitchStateNodeToApp,
  NodeInfo,
  AppRoomConfig,
  AppDeviceConfig
}

class SmartMqtt {
  String ip;
  int port;
  bool debug;

  MqttClient client;
  MqttConnectionState connectionState;
  StreamSubscription subscription;
  bool isConnected = false;

  final StreamController _controller = StreamController<dynamic>.broadcast();
  Stream<dynamic> get stream => _controller.stream;

  final StreamController _subscriptionController = StreamController<String>();
  final StreamController _unsubscriptionController = StreamController<String>();

  static final SmartMqtt _instance = SmartMqtt._internal();
  SmartMqtt._internal();

  factory SmartMqtt({
    String ip = BROKER_IP,
    int port = BROKER_PORT,
    bool debug = false,
  }) {
    _instance.ip = ip;
    _instance.port = port;
    _instance.debug = debug;
    return _instance;
  }

  void connect() async {
    if (!isConnected) {
      isConnected = true;
      client = MqttServerClient.withPort(ip, '', port);
      client.logging(on: false);
      client.keepAlivePeriod = 30;
      client.autoReconnect = true;
      client.onConnected = () {
        _subscriptionController.stream.listen((topic) {
          client.subscribe(topic, MqttQos.exactlyOnce);
          if (debug) print('[SmartMqtt] Subscribed -> $topic');
        });
        _unsubscriptionController.stream.listen((topic) {
          client.unsubscribe(topic);
          if (debug) print('[SmartMqtt] Unsubscribed -> $topic');
        });
      };
      client.onDisconnected = () {
        _controller.sink.add(client.connectionStatus.state);
        isConnected = false;
      };
      client.onAutoReconnect =
          () => _controller.sink.add(client.connectionStatus.state);

      // use UniqueID for only 1 connection per device
      // use DateTime as UID  to get multiple connections from same device
      final MqttConnectMessage connectMessage = MqttConnectMessage()
          .keepAliveFor(30)
          .withClientIdentifier(await _getUniqueId())
          //.withClientIdentifier(DateTime.now().toString())
          .withWillQos(MqttQos.atMostOnce);
      if (debug) print("[SmartMqtt] -> MQTT Client connecting...");
      client.connectionMessage = connectMessage;

      try {
        await client.connect();
      } catch (e) {
        print(e);
        disconnect();
      }

      if (client.connectionStatus.state == MqttConnectionState.connected) {
        if (debug) print("[SmartMqtt] -> MQTT Connected!");
        subscription = client.updates.listen((event) {
          final MqttPublishMessage recMessage =
              event[0].payload as MqttPublishMessage;
          final String msg = MqttPublishPayload.bytesToStringAsString(
              recMessage.payload.message);
          _controller.sink.add(msg);
        });
      } else {
        print(
            "[SmartMqtt] -> Failed to Connect. RC -> ${client.connectionStatus.returnCode}");
        disconnect();
      }
    }
  }

  void disconnect() {
    client.disconnect();
    isConnected = false;
    _controller.sink.close();
    _subscriptionController.close();
    _unsubscriptionController.close();
  }

  void subscribe(String topic) {
    _subscriptionController.sink.add(topic);
  }

  void unsubscribe(String topic) {
    _unsubscriptionController.sink.add(topic);
  }

  void publish({
    @required String topic,
    @required String message,
    bool retain = false,
  }) {
    try {
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(
        topic,
        MqttQos.exactlyOnce,
        builder.payload,
        retain: retain,
      );
    } on ConnectionException catch (e) {
      if (debug) print('[SmartMqtt] Exception -> $e');
    }
  }

  /*String getTopic({
    @required String username,
    @required int type,
    String roomName,
    String smartId,
  }) {
    switch (type) {
      case typeSwitchStateAppToNode:
        return 'smart/$username/gateway';
        break;
      case typeSwitchStateNodeToApp:
        return 'smart/$username/+/state';
        break;
      case typeNodeInfo:
        return 'smart/$username/+/info';
        break;
      case typeAppRoomConfig:
        return 'smart/$username/app/$roomName/config';
        break;
      default:
        return 'smart/$username/gateway';
    }
  }*/

  String getTopic({
    @required String username,
    @required SmartMqttTopic type,
    String roomName,
    String smartId,
  }) {
      if(type == SmartMqttTopic.SwitchStateAppToNode)
        return 'smart/$username/gateway';
      if(type == SmartMqttTopic.SwitchStateNodeToApp)
        return 'smart/$username/+/state';
      if(type == SmartMqttTopic.NodeInfo)
        return 'smart/$username/+/info';
      if(type == SmartMqttTopic.AppRoomConfig)
        return 'smart/$username/app/$roomName/config';
      if(type == SmartMqttTopic.AppDeviceConfig)
        return 'smart/$username/app/deviceConfig';
      else
        return 'smart/$username/gateway';
    }

  Future<String> _getUniqueId() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return androidDeviceInfo.androidId;
    } else {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    }
  }

  // Static properties for types of topic for topic generation
  static const int typeSwitchStateAppToNode = 1;
  static const int typeSwitchStateNodeToApp = 2;
  static const int typeNodeInfo = 3;
  static const int typeAppRoomConfig = 4;
}
