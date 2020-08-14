import 'package:flutter/material.dart';

import '../controllers/SmartMqtt.dart';
import '../controllers/SmartSharedPref.dart';
import '../controllers/SmartSync.dart';

import '../models/SmartConstants.dart';
import '../models/SmartRoomData.dart';

import '../widgets/SmartRoomIndicator.dart';
import '../widgets/SmartRoomCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SmartHelper helper;
  SmartMqtt mqtt = SmartMqtt(debug: true);

  final List<SmartMqttTopic> subscriptionList = [
    SmartMqttTopic.NodeInfo,
  ];

  final dummyString =
      '{"to": "gateway","from": "app","smartId": "SMART_00DCCFC8","type": "state","data": "[1, 0, 0, 1]"}';

  @override
  void initState() {
    mqtt.connect();
    mqtt.subscribeMultiple(subscriptionList);
    mqtt.stream.asBroadcastStream().listen((msg) {
      print('EVENT => $msg');
      //TODO - Test receving uname/+/info from Cloud & map them into room layout
      /*
      Algorithm for TODO
      - get data from all nodes @ +/info
      - get 'nodeName' from each node, Add it to the 'roomName' list
      - get 'data' from each node, append it to data of 'roomName'
      - if any is 1, show green else red
      - use futurebuilder - show grey on init
      */
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    List<SmartRoomData> dataList = [
      SmartRoomData(
        name: 'Room 1',
        icon: Icons.filter_1,
      ),
      SmartRoomData(
        name: 'Room 2',
        icon: Icons.filter_2,
      ),
      SmartRoomData(
        name: 'Room 3',
        icon: Icons.filter_3,
      ),
      SmartRoomData(
        name: 'Room 4',
        icon: Icons.filter_4,
      ),
      SmartRoomData(
        name: 'Room 5',
        icon: Icons.filter_5,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
            childAspectRatio: 5 / 3.5,
          ),
          itemCount: dataList.length,
          itemBuilder: (_, index) {
            return SmartRoomCard(
              helper: helper,
              roomData: dataList[index],
              indicatorState: SmartRoomIndicatorState.powerOn,
              onTap: () {
                print('Clicked on ${dataList[index].name}');
              },
            );
          },
        ),
      ),
    );
  }
}
