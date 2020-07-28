import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../models/SmartConstants.dart';
import '../models/SmartProfile.dart';
import '../models/SwitchboardRow.dart';
import '../models/JsonModel.dart';
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
  SmartMqtt mqtt = SmartMqtt();
  JsonNodeInfo nodeInfo;

  String _roomName = 'Room Name';

  List<String> _nodesInRoomList = [];
  int _devicesInRoom = 0;

  final List<SmartProfile> profileList = [
    SmartProfile(profileName: "Party", profileIcon: Icons.blur_circular),
    SmartProfile(profileName: "Chill", profileIcon: Icons.music_note),
    SmartProfile(profileName: "Sleep", profileIcon: Icons.brightness_3),
    SmartProfile(profileName: "Movie", profileIcon: Icons.movie),
  ];

  /*final List<SwitchboardRow> switchList = [
    SwitchboardRow(
      deviceName: "Device 1",
      deviceDescription: "Description for Device 1",
      deviceState: false,
      deviceIcon: Icons.ac_unit,
    ),
    SwitchboardRow(
      deviceName: "Device 2",
      deviceDescription: "Description for Device 2",
      deviceState: true,
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
  ];*/
  List<SwitchboardRow> switchList = [];

  @override
  void initState() {
    mqtt.connect();
    mqtt.subscribe(
      mqtt.getTopic(
        username: TEST_USERNAME,
        smartId: TEST_SMARTID,
        type: SmartMqtt.typeNodeInfo,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    mqtt.stream.asBroadcastStream().listen((msg) {
      if (msg is MqttConnectionState)
        print("CONNECTION EVEN HAPPENING");
      else {
        print("[STREAM-Room] $msg");
        JsonNodeInfo infoPacket = JsonNodeInfo.fromJsonString(msg);
        if (infoPacket.type == JSON_TYPE_INFO) {
          _roomName = infoPacket.nodeName;
          _devicesInRoom += infoPacket.nod;
          if (!_nodesInRoomList.contains(infoPacket.smartId))
            _nodesInRoomList.add(infoPacket.smartId);
          for (int i = 1; i <= _devicesInRoom; i++) {
            switchList.add(
              SwitchboardRow(
                deviceName: 'Device $i',
                deviceState: false,
                deviceDescription: 'Description for Device $i',
                deviceIcon: Icons.android,
              ),
            );
          }
          setState(() {});
        }
      }
    });

    return Scaffold(
      appBar: SmartAppBar(title: _roomName),
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
                          nodeList: _nodesInRoomList,
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
}
