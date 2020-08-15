import 'package:flutter/material.dart';

import '../controllers/SmartMqtt.dart';
import '../controllers/SmartSharedPref.dart';

import '../models/SmartConstants.dart';
import '../models/SmartRoomData.dart';
import '../models/JsonModel.dart';
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

  Map<String, SmartRoomIndicatorState> roomToPowerIndicatorMap = {};
  Map<String, Map<String, List<int>>> roomStateMap = {};

  final List<SmartMqttTopic> subscriptionList = [
    SmartMqttTopic.NodeInfo,
    SmartMqttTopic.SwitchStateNodeToApp,
  ];

  List<SmartRoomData> roomDataList = [];

  @override
  void initState() {
    mqtt.connect();
    mqtt.subscribeMultiple(subscriptionList);
    mqtt.stream.asBroadcastStream().listen((msg) {
      if (msg is String) {
        setState(() => _getRoomDataFromMqtt(msg));
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

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: helper.screenHeight - MediaQuery.of(context).padding.top,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  child: Text(
                    'Add Hello Message here with nice background gradient & elevated card on it\n\nOr even a summary card!',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
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
        /*child: FutureBuilder(
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
                  indicatorState:
                      roomToPowerIndicatorMap[snapshot.data[index].name],
                  onTap: () {
                    print('Clicked on ${snapshot.data[index].name}');
                  },
                );
              },
            );
          },
        ),*/
      ),
    );
  }

  Future<List<SmartRoomData>> loadRooms() async {
    List<SmartRoomData> list = await SmartRoomData.loadFromDisk();
    return list;
  }

  void _getRoomDataFromMqtt(String msg) {
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
      }
    } catch (_) {}
  }
}
