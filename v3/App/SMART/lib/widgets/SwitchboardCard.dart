import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';
import '../models/SwitchboardRow.dart';
import '../models/JsonModel.dart';
import '../controllers/SmartMqtt.dart';
import '../widgets/SwitchboardTile.dart';

class SwitchboardCard extends StatefulWidget {
  final List<SwitchboardRow> switchboardList;

  SwitchboardCard({@required this.switchboardList});

  @override
  _SwitchboardCardState createState() => _SwitchboardCardState();
}

class _SwitchboardCardState extends State<SwitchboardCard>
    with TickerProviderStateMixin {
  SmartHelper helper;
  SmartMqtt mqtt;

  JsonNodeToAppSwitchState switchStates;

  List<int> switchStatesList = [];

  String _switchStateTopic;

  @override
  void initState() {
    mqtt = SmartMqtt();
    _switchStateTopic = mqtt.getTopic(
      username: TEST_USERNAME,
      smartId: TEST_SMARTID,
      type: SmartMqtt.typeSwitchStateNodeToApp,
    );
    mqtt.connect();
    mqtt.subscribe(_switchStateTopic);
    mqtt.stream.asBroadcastStream().listen((msg) {
      if (msg is String) {
        print("[STREAM-SwitchboardCard] $msg");
        JsonNodeToAppSwitchState statePacket =
            JsonNodeToAppSwitchState.fromJsonString(msg);
        if (statePacket.type == JSON_TYPE_STATE) {
          int i = 0;
          statePacket.dataList.forEach((element) {
            if (element == 1)
              widget.switchboardList[i].deviceState = true;
            else
              widget.switchboardList[i].deviceState = false;
            i++;
          });
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);
    initSwitchStateList();

    var x = widget.switchboardList.map((e) => e.toJsonString()).toList();
    mqtt.publish(topic: 'smart/flutter', message: x.toString());

    if (widget.switchboardList.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              "Just a moment..",
              style: Theme.of(context).textTheme.headline1,
            ),
          )
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: DefaultTabController(
        length: 2,
        child: Container(
          child: Card(
            elevation: 8,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(helper.screenWidth * 0.1),
                topRight: Radius.circular(helper.screenWidth * 0.1),
              ),
            ),
            color: Theme.of(context).cardColor,
            child: Column(
              children: <Widget>[
                TabBar(
                  isScrollable: false,
                  labelColor: Theme.of(context).textTheme.headline2.color,
                  labelStyle: Theme.of(context).textTheme.headline2,
                  tabs: [
                    Tab(text: "Switches"),
                    Tab(text: "Nodes"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: widget.switchboardList.length,
                        itemBuilder: (ctx, index) {
                          return SwitchboardTile(
                            key: ValueKey(widget.switchboardList[index]),
                            row: widget.switchboardList[index],
                            index: index,
                            onSwitchStateChanged: updateSwitchStates,
                          );
                        },
                      ),
                      Text("Add Switch List Here 2"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("[SwitchboardCard] - Disposing..");
    mqtt.unsubscribe(_switchStateTopic);
    super.dispose();
  }

  // Initialize switchState list like [1,0,1,0] for MQTT
  void initSwitchStateList() {
    widget.switchboardList.forEach((element) {
      if (element.deviceState) {
        switchStatesList.add(1);
      } else {
        switchStatesList.add(0);
      }
    });
  }

  // Update when toggled - should be called from the SwitchboardTile -> Switch widget
  void updateSwitchStates(int index, bool val) {
    if (val) {
      switchStatesList[index] = 1;
    } else {
      switchStatesList[index] = 0;
    }
    mqtt.publish(
      topic: mqtt.getTopic(
        username: TEST_USERNAME,
        smartId: TEST_SMARTID,
        type: SmartMqtt.typeSwitchStateAppToNode,
      ),
      message: JsonAppToNodeSwitchState(
        smartId: TEST_SMARTID,
        dataList: switchStatesList,
      ).toJsonString(),
      retain: true,
    );
  }
}
