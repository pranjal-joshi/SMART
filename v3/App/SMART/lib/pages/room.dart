import 'dart:async';
import 'package:SMART/models/JsonModel.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../models/SmartConstants.dart';
import '../models/SmartProfile.dart';
import '../models/SwitchboardRow.dart';
import '../controllers/SmartMqtt.dart';

import '../widgets/SmartAppBar.dart';
import '../widgets/ProfileCard.dart';
import '../widgets/CreateProfileCard.dart';
import '../widgets/SwitchboardCard.dart';

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  SmartHelper helper;
  SmartMqtt mqtt;

  JsonNodeInfo nodeInfo;

  String _roomName = 'Room Name';

  final List<SmartProfile> profileList = [
    SmartProfile(profileName: "Party", profileIcon: Icons.blur_circular),
    SmartProfile(profileName: "Chill", profileIcon: Icons.music_note),
    SmartProfile(profileName: "Sleep", profileIcon: Icons.brightness_3),
    SmartProfile(profileName: "Movie", profileIcon: Icons.movie),
  ];

  final List<SwitchboardRow> switchList = [
    SwitchboardRow(
      deviceName: "Device 1",
      deviceDescription: "Description for Device 1",
      deviceState: true,
      deviceIcon: Icons.ac_unit,
    ),
    SwitchboardRow(
      deviceName: "Device 2",
      deviceDescription: "Description for Device 2",
      deviceState: false,
      deviceIcon: Icons.lightbulb_outline,
    ),
    SwitchboardRow(
      deviceName: "Device 3",
      deviceDescription: "Description for Device 3",
      deviceState: true,
      deviceIcon: Icons.nature,
    ),
    SwitchboardRow(
      deviceName: "Device 4",
      deviceDescription: "Description for Device 4",
      deviceState: false,
      deviceIcon: Icons.desktop_windows,
    ),
  ];

  @override
  void initState() {
    mqtt = SmartMqtt(
      onDisconnected: onMqttDisconnect,
      onReceive: onMqttReceive,
      onConnected: onMqttConnect,
      onAutoReconnect: onMqttReconnect,
    );
    mqtt.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    return Scaffold(
      appBar: SmartAppBar(
        title: _roomName,
        helper: helper,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 8, 0),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Profiles",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                    getProfileCards(
                      helper: helper,
                      profileList: profileList,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 9,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.only(top: 12),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 8, 8),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Switch Board",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: SwitchboardCard(
                          switchboardList: switchList,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProfileCards({
    List<SmartProfile> profileList,
    SmartHelper helper,
  }) {
    return Expanded(
      child: Container(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: profileList.length + 1,
          itemBuilder: (context, index) {
            try {
              return Padding(
                padding: EdgeInsets.all(6),
                child: ProfileCard(
                  profileIcon: profileList[index].profileIcon,
                  profileName: profileList[index].profileName,
                ),
              );
            } catch (e) {
              return Padding(
                padding: EdgeInsets.fromLTRB(8, 10, 16, 10),
                child: CreateProfileCard(),
              );
            }
          },
        ),
      ),
    );
  }

  void onMqttConnect() {
    mqtt.subscribe(mqtt.getTopic(
      username: TEST_USERNAME,
      smartId: TEST_SMARTID,
      type: SmartMqtt.typeNodeInfo,
    ));
    mqtt.subscribe("smart/test");
    mqtt.subscribe("smart/test2");
    // Implement Switch widgets freez/unfreez here!
  }

  void onMqttReconnect() {
    print("[Room.dart] - MQTT Reconnected!");
  }

  void onMqttDisconnect() {
    print("[Room.dart] - MQTT Disconnected!");
  }

  void onMqttReceive(String msg) {
    nodeInfo = JsonNodeInfo.fromJsonString(msg);
    print(msg);
  }
}
