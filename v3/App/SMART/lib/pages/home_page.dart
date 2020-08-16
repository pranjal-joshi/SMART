import 'package:SMART/widgets/SmartWelcomeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/SmartMqtt.dart';
import '../controllers/SmartSharedPref.dart';

import '../models/SmartConstants.dart';
import '../models/SmartRoomData.dart';
import '../models/JsonModel.dart';

import '../widgets/SmartWelcomeBanner.dart';
import '../widgets/SmartRoomIndicator.dart';
import '../widgets/SmartRoomCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SmartHelper helper;
  final SmartMqtt mqtt = SmartMqtt(debug: true);
  final SmartSharedPreference sp = SmartSharedPreference();

  final JsonNodeStatus jsonNodeStatusHandler = JsonNodeStatus();

  Map<String, SmartRoomIndicatorState> roomToPowerIndicatorMap = {};
  Map<String, Map<String, List<int>>> roomStateMap = {};

  final List<SmartMqttTopic> subscriptionList = [
    SmartMqttTopic.NodeInfo,
    SmartMqttTopic.SwitchStateNodeToApp,
  ];

  List<SmartRoomData> roomDataList = [];
  List<String> _credentials = [];

  @override
  void initState() {
    mqtt.connect();
    mqtt.subscribeMultiple(subscriptionList);
    mqtt.stream.asBroadcastStream().listen((msg) {
      if (msg is String) {
        _getRoomDataFromMqtt(msg, rebuildOnPacket: false);
        jsonNodeStatusHandler.addDevice(msg);
      }
    });
    SmartRoomData.loadFromDisk().then((value) {
      if (value != null) roomDataList = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    mqtt.unsubscribeMultiple(subscriptionList);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    // Set Status bar color
    if (!helper.isDarkModeActive)
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColorDark,
        ),
      );
    else
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.black,
        ),
      );

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: helper.screenHeight - MediaQuery.of(context).padding.top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    return Stack(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: double.infinity,
                            height: constraints.maxHeight / 1.2,
                            decoration: helper.isDarkModeActive
                                ? BoxDecoration(
                                    color: Colors.black,
                                  )
                                : BoxDecoration(
                                    gradient: LinearGradient(
                                      tileMode: TileMode.mirror,
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Theme.of(context).primaryColorDark,
                                        Colors.amber[800],
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: SmartWelcomeBanner(),
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).canvasColor,
                                    radius: 28,
                                    child: Text('DP'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SmartWelcomeCard(
                          helper: helper,
                          constraints: constraints,
                          title: '2 Devices',
                          subtitle: 'Active',
                          onActionTap: () => print('Pressed!'),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 16,
                  ),
                  child: FutureBuilder(
                    initialData: roomDataList,
                    future: loadRooms(),
                    builder: (_, AsyncSnapshot<List<SmartRoomData>> snapshot) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 10,
                          childAspectRatio: 5 / 4,
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return SmartRoomCard(
                            helper: helper,
                            roomData: snapshot.data[index],
                            indicatorState: roomToPowerIndicatorMap[
                                snapshot.data[index].name],
                            onTap: () {
                              print('Clicked on ${snapshot.data[index].name}');
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<SmartRoomData>> loadRooms() async {
    List<SmartRoomData> list = await SmartRoomData.loadFromDisk();
    return list;
  }

  void _getRoomDataFromMqtt(String msg, {bool rebuildOnPacket = true}) {
    try {
      JsonNodeToAppSwitchState statePacket =
          JsonNodeToAppSwitchState.fromJsonString(msg);
      if (statePacket.type == JSON_TYPE_STATE) {
        if (!roomStateMap.containsKey(statePacket.nodeName)) {
          roomStateMap.putIfAbsent(
            statePacket.nodeName,
            () => {
              statePacket.smartId: statePacket.dataList,
            },
          );
        } else {
          roomStateMap.update(
            statePacket.nodeName,
            (value) {
              value.update(
                statePacket.smartId,
                (value) => statePacket.dataList,
                ifAbsent: () => statePacket.dataList,
              );
              return value;
            },
          );
        }
        roomToPowerIndicatorMap = {};
        roomStateMap.forEach((key, value) {
          value.forEach((k, v) {
            if (v.any((element) => element == 1)) {
              if (!roomToPowerIndicatorMap.containsKey(key))
                roomToPowerIndicatorMap.putIfAbsent(
                  key,
                  () => SmartRoomIndicatorState.powerOn,
                );
              else
                roomToPowerIndicatorMap.update(
                  key,
                  (value) => SmartRoomIndicatorState.powerOn,
                );
            } else {
              if (!roomToPowerIndicatorMap.containsKey(key))
                roomToPowerIndicatorMap.putIfAbsent(
                  key,
                  () => SmartRoomIndicatorState.powerOff,
                );
              else
                roomToPowerIndicatorMap.update(key, (value) {
                  if (value == SmartRoomIndicatorState.powerOn)
                    return SmartRoomIndicatorState.powerOn;
                  return SmartRoomIndicatorState.powerOff;
                });
            }
          });
        });
        rebuildOnPacket ? setState(() {}) : null;
      }
    } catch (_) {}
  }
}
