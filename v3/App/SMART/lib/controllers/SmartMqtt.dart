import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SmartMqtt {
  final String ip;
  final int port;
  MqttClient client;
  MqttConnectionState connectionState;
  StreamSubscription subscription;
  Function onDisconnected;
  Function onReceive;
  Function onSubscribed;
  Function onConnected;
  Function onAutoReconnect;

  SmartMqtt({
    this.ip = "35.222.110.118",
    this.port = 1883,
    @required this.onDisconnected,
    @required this.onReceive,
    @required this.onConnected,
    this.onSubscribed,
    this.onAutoReconnect,
  });

  void connect() async {
    client = MqttServerClient.withPort(ip, '', port);
    client.logging(on: false);
    client.keepAlivePeriod = 30;
    client.autoReconnect = true;
    client.onAutoReconnect = this.onAutoReconnect;
    client.onConnected = this.onConnected;
    client.onDisconnected = this.onDisconnected;
    client.onSubscribed = this.onSubscribed;

    // use UniqueID for only 1 connection per device
    // use DateTime as UID  to get multiple connections from same device
    final MqttConnectMessage connectMessage = MqttConnectMessage()
        .keepAliveFor(30)
        // .withClientIdentifier(await _getUniqueId())
        .withClientIdentifier(DateTime.now().toString())
        .withWillQos(MqttQos.atMostOnce);
    print("[+] SmartMqtt -> MQTT Client connecting...");
    client.connectionMessage = connectMessage;

    try {
      await client.connect();
    } catch (e) {
      print(e);
      disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print("[+] SmartMqtt -> MQTT Connected!");
      subscription = client.updates.listen((event) {
        final MqttPublishMessage recMessage =
            event[0].payload as MqttPublishMessage;
        final String msg = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);
        onReceive(msg);
      });
    } else {
      print(
          "[+] SmartMqtt -> Failed to Connect. RC = ${client.connectionStatus.returnCode}");
      disconnect();
    }
  }

  void disconnect() {
    client.disconnect();
    onDisconnected();
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.exactlyOnce);
  }
  
  void unsubscribe(String topic) {
    client.unsubscribe(topic);
  }

  void publish({@required String topic, @required String message, bool retain = false}) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload, retain: retain);
  }

  String getTopic({
    @required String username,
    @required String smartId,
    @required int type,
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
      default:
        return 'smart/$username/gateway';
    }
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
}
