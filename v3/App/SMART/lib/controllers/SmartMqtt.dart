import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../models/SmartConstants.dart';
import '../controllers/SmartSharedPref.dart';

enum SmartMqttTopic {
  SwitchStateAppToNode,
  SwitchStateNodeToApp,
  NodeInfo,
  NodeStatus,
  AppRoomConfig,
  AppDeviceConfig,
  AppRoomList,
}

class SmartMqtt {
  String ip;
  int port;
  bool debug;

  MqttClient client;
  MqttConnectionState connectionState;
  StreamSubscription subscription;
  bool isConnected = false;

  SmartSharedPreference sp = SmartSharedPreference();
  ConnectivityResult _connectivityResult;
  List<SmartMqttPublishBuffer> _publishBuffer = [];

  List<String> _subscribeToStateList = [];

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

  void connect({
    bool syncPendingBuffer = true,
  }) async {
    if (!isConnected) {
      isConnected = true;
      client = MqttServerClient.withPort(ip, '', port);
      client.logging(on: false);
      client.keepAlivePeriod = 30;
      client.autoReconnect = true;
      client.onConnected = () async {
        try {
          _subscriptionController.stream.listen((topic) {
            if (client.connectionStatus.state == MqttConnectionState.connected)
              client.subscribe(topic, MqttQos.exactlyOnce);
            if (debug) print('[SmartMqtt] Subscribed -> $topic');
          });
          _unsubscriptionController.stream.listen((topic) {
            if (client.connectionStatus.state == MqttConnectionState.connected)
              client.unsubscribe(topic);
            if (debug) print('[SmartMqtt] Unsubscribed -> $topic');
          });
        } catch (_) {}
        List<String> buf =
            await sp.loadStringList(key: SP_SmartMqttPublishBuffer);
        try {
          _publishBuffer =
              buf.map((e) => SmartMqttPublishBuffer.fromJsonString(e)).toList();
        } on NoSuchMethodError catch (_) {}
        if (syncPendingBuffer) publishBuffer();
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
        await client.connect().timeout(Duration(seconds: 10), onTimeout: () {
          print('[SmartMqtt] -> MQTT Connection Timed out!');
          isConnected = false;
          this.connect();
          return;
        });
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
        // disconnect();
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
    if (!_subscriptionController.isClosed)
      _subscriptionController.sink.add(topic);
  }

  void subscribeMultiple(List<SmartMqttTopic> enumList) {
    if (enumList != null && enumList.isNotEmpty)
      enumList.forEach(
        (e) {
          this.subscribe(
            this.getTopic(username: TEST_USERNAME, type: e),
          );
        },
      );
  }

  void subscribeToStateIfNot({@required String smartId}) {
    if (!_subscribeToStateList.contains(smartId)) {
      this.subscribe('smart/$TEST_USERNAME/$smartId/state');
      _subscribeToStateList.add(smartId);
    }
  }

  void unsubscribe(String topic) {
    if (!_unsubscriptionController.isClosed)
      _unsubscriptionController.sink.add(topic);
  }

  void unsubscribeMultiple(List<SmartMqttTopic> enumList) {
    if (enumList != null && enumList.isNotEmpty)
      enumList.forEach(
        (e) {
          this.unsubscribe(
            this.getTopic(username: TEST_USERNAME, type: e),
          );
        },
      );
  }

  void unsubscribeToStateIfNot({@required String smartId}) {
    if (_subscribeToStateList.contains(smartId)) {
      this.unsubscribe('smart/$TEST_USERNAME/$smartId/state');
      _subscribeToStateList.remove(smartId);
    }
  }

  void publish({
    @required String topic,
    @required String message,
    bool retain = false,
  }) async {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (await isInternetAvailable()) {
      try {
        client.publishMessage(
          topic,
          MqttQos.exactlyOnce,
          builder.payload,
          retain: retain,
        );
      } on ConnectionException catch (e) {
        if (debug) print('[SmartMqtt] Exception -> $e');
      }
    } else {
      _publishBuffer.add(
        SmartMqttPublishBuffer(
          topic: topic,
          message: message,
          retain: retain,
        ),
      );
      List<String> buf = _publishBuffer.map((e) => e.toJsonString()).toList();
      sp.saveStringList(
        key: SP_SmartMqttPublishBuffer,
        data: buf,
      );
      if (debug)
        print('[SmartMqtt] No Internet -> PublishBuffer = ${buf.toString()}');
    }
  }

  void publishBuffer() async {
    if (await isInternetAvailable()) {
      List<SmartMqttPublishBuffer> pubBuf =
          await SmartMqttPublishBuffer.loadFromDisk();
      List<String> _deviceConfigBuffer = [];
      List<String> _roomListBuffer = [];
      if (pubBuf.isNotEmpty) {
        if (debug)
          print('[SmartMqtt] Read PublishBuffer -> ${pubBuf.toString()}');
        pubBuf.forEach((element) {
          //Check each msg, add to buffer list if required so that entire list can be published as a single msg which will be retained.
          if (element.topic.contains('deviceConfig')) {
            _deviceConfigBuffer.add(element.message);
          } else if (element.topic.contains('roomList')) {
            _roomListBuffer.add(element.message);
          } else {
            MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
            builder.addString(element.message);
            client.publishMessage(
              element.topic,
              MqttQos.exactlyOnce,
              builder.payload,
              retain: element.retain,
            );
            builder = null;
          }
        });
        // Publish all buffers to MQTT as a list of msgs
        if (_deviceConfigBuffer.isNotEmpty) {
          MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
          builder.addString(_deviceConfigBuffer.toString());
          client.publishMessage(
            this.getTopic(
              username: TEST_USERNAME,
              type: SmartMqttTopic.AppDeviceConfig,
            ),
            MqttQos.exactlyOnce,
            builder.payload,
            retain: true,
          );
          builder = null;
          _deviceConfigBuffer = null;
        }
        if (_roomListBuffer.isNotEmpty) {
          MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
          builder.addString(_roomListBuffer.toString());
          client.publishMessage(
            this.getTopic(
              username: TEST_USERNAME,
              type: SmartMqttTopic.AppRoomList,
            ),
            MqttQos.exactlyOnce,
            builder.payload,
            retain: true,
          );
          builder = null;
          _roomListBuffer = null;
        }
        sp.delete(key: SP_SmartMqttPublishBuffer);
      } else {
        if (debug) print('[SmartMqtt] PublishBuffer Empty!');
      }
    }
  }

  Future<bool> isInternetAvailable() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    if (_connectivityResult != ConnectivityResult.none) {
      try {
        final result = await InternetAddress.lookup('google.co.in');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        return false;
      }
    }
    return false;
  }

  String getTopic({
    @required String username,
    @required SmartMqttTopic type,
    String roomName,
    String smartId,
  }) {
    if (type == SmartMqttTopic.SwitchStateAppToNode)
      return 'smart/$username/gateway';
    if (type == SmartMqttTopic.SwitchStateNodeToApp)
      return 'smart/$username/+/state';
    if (type == SmartMqttTopic.NodeInfo) return 'smart/$username/+/info';
    if (type == SmartMqttTopic.NodeStatus) return 'smart/$username/+/status';
    if (type == SmartMqttTopic.AppRoomConfig)
      return 'smart/$username/app/$roomName/roomConfig';
    if (type == SmartMqttTopic.AppDeviceConfig)
      return 'smart/$username/app/deviceConfig';
    if (type == SmartMqttTopic.AppRoomList)
      return 'smart/$username/app/roomList';
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
}

class SmartMqttPublishBuffer {
  String topic;
  String message;
  bool retain;
  static final String type = 'PublishBuffer';

  SmartMqttPublishBuffer({
    @required this.topic,
    @required this.message,
    @required this.retain,
  });

  SmartMqttPublishBuffer.fromJsonString(String rawJson) {
    try {
      rawJson = rawJson.replaceAll('\'', '\"');
      Map<String, dynamic> json = jsonDecode(rawJson);
      topic = json['topic'];
      message = json['message'];
      retain = json['retain'] == 'true' ? true : false;
    } catch (_) {}
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'message': message,
      'retain': retain.toString(),
      'type': type,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  static Future<void> saveToDisk(List<SmartMqttPublishBuffer> list) async {
    if (list != null) {
      final SmartSharedPreference _sp = SmartSharedPreference();
      final List<String> raw = list.map((e) => e.toJsonString()).toList();
      _sp.saveStringList(key: SP_SmartMqttPublishBuffer, data: raw);
    }
  }

  static Future<List<SmartMqttPublishBuffer>> loadFromDisk() async {
    final SmartSharedPreference _sp = SmartSharedPreference();
    List<String> raw = await _sp.loadStringList(key: SP_SmartMqttPublishBuffer);
    if (raw != null) {
      List<SmartMqttPublishBuffer> list =
          raw.map((e) => SmartMqttPublishBuffer.fromJsonString(e)).toList();
      return list;
    }
    return [];
  }
}
