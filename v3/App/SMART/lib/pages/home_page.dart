import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/SmartMqtt.dart';
import '../controllers/SmartSharedPref.dart';
import '../controllers/SmartSync.dart';

import '../providers/JsonNodeStatusProvider.dart';
import '../providers/JsonRoomStateProvider.dart';

import '../models/SmartConstants.dart';
import '../models/SmartRoomData.dart';

import '../widgets/SmartWelcomeBanner.dart';
import '../widgets/SmartWelcomeCard.dart';
import '../widgets/SmartRoomCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SmartHelper helper;
  final SmartMqtt mqtt = SmartMqtt(debug: true);
  final SmartSync smartSync = SmartSync(debug: false);
  final SmartSharedPreference sp = SmartSharedPreference();

  final List<SmartMqttTopic> subscriptionList = [
    SmartMqttTopic.NodeStatus,
    SmartMqttTopic.NodeInfo,
    SmartMqttTopic.SwitchStateNodeToApp,
    SmartMqttTopic.AppRoomList,
  ];

  List<SmartRoomData> roomDataList = [];

  @override
  void initState() {
    mqtt.connect();
    mqtt.subscribeMultiple(subscriptionList);
    mqtt.stream.asBroadcastStream().listen((msg) {
      if (msg is String) {
        var decodedJson = jsonDecode(msg);
        smartSync.syncMqttWithSp(msg);
        Provider.of<JsonRoomStateProvider>(context, listen: false)
            .addState(msg, decodedJson);
        Provider.of<JsonNodeStatusProvider>(context, listen: false)
            .addDevice(msg, decodedJson);
      }
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
        top: false,
        child: Container(
          width: double.infinity,
          height: helper.screenHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
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
                                        Colors.indigo[700],
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 12,
                                right: 12,
                                top: 12 + MediaQuery.of(context).padding.top,
                              ),
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
                        Consumer<JsonNodeStatusProvider>(
                          builder: (_, status, __) {
                            return SmartWelcomeCard(
                              helper: helper,
                              constraints: constraints,
                              title: status.getActiveMessage['title'],
                              subtitle: status.getActiveMessage['subtitle'],
                              onActionTap: () => Navigator.of(context)
                                  .pushNamed(route_addNewDevice),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 15,
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
                          return Consumer<JsonRoomStateProvider>(
                            builder: (_, stateData, __) => SmartRoomCard(
                              helper: helper,
                              roomData: snapshot.data[index],
                              indicatorState: stateData.roomPowerIndicatorMap[
                                  snapshot.data[index].name],
                              onTap: () {
                                print(
                                    'Clicked on ${snapshot.data[index].name}');
                                    Navigator.of(context).pushNamed(route_room_page);
                              },
                            ),
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
}
