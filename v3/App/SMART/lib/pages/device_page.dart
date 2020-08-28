import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import '../helpers/SmartHelper.dart';
import '../exceptions/SmartException.dart';

import '../controllers/SmartMqtt.dart';

import '../models/SmartDeviceData.dart';
import '../models/JsonModel.dart';

import '../providers/JsonRoomStateProvider.dart';

import '../widgets/SmartCard.dart';

class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  SmartHelper helper;
  SmartMqtt mqtt = SmartMqtt();
  bool _switchState;

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);
    final Map<String, dynamic> args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final SmartDeviceData deviceData = args['deviceData'];
    _switchState = deviceData.switchState;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SmartCard(
                    helper: helper,
                    elevation: 24,
                    shadowColor: Colors.indigo[300],
                    blurRadius: SmartCardBlurRadius.Spread22,
                    cornerRadius: 10,
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight / 2.7 -
                          MediaQuery.of(context).padding.top,
                      decoration: helper.isDarkModeActive
                          ? BoxDecoration(
                              color: Color.fromRGBO(25, 25, 25, 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
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
                          top: MediaQuery.of(context).padding.top,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 6,
                              left: 6,
                              child: IconButton(
                                icon: Icon(
                                  Platform.isAndroid
                                      ? Icons.arrow_back
                                      : Icons.arrow_back_ios,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                                onPressed: () => ModalRoute.of(context).canPop
                                    ? Navigator.of(context).pop()
                                    : null,
                                tooltip: 'Go Back',
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: IconButton(
                                tooltip: 'Edit Device Name',
                                icon: Icon(
                                  LineAwesomeIcons.edit,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                                onPressed: () => print('Edit Device Name'),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              top: 32,
                              child: Icon(
                                deviceData.iconData,
                                size: 156,
                                color: Colors.white30,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: constraints.maxWidth/2,
                                  left: 16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        deviceData.deviceName,
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Switched ON/OFF',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white70,
                                        height: 1.7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Row(
                                children: [
                                  if (deviceData.showTimerIcon)
                                    Icon(
                                      LineAwesomeIcons.clock_o,
                                      color: Colors.white30,
                                      size: 28,
                                    ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  if (deviceData.showMotionIcon)
                                    Icon(
                                      Icons.directions_walk,
                                      color: Colors.white30,
                                      size: 28,
                                    )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: SizedBox(
                                child: Switch.adaptive(
                                  inactiveTrackColor: helper.isDarkModeActive
                                      ? Colors.white24
                                      : null,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                  value: _switchState,
                                  onChanged: (val) {
                                    setState(
                                        () => _switchState = !_switchState);
                                    // Publish state packet to gateway node
                                    List<int> _dataList =
                                        Provider.of<JsonRoomStateProvider>(
                                                context,
                                                listen: false)
                                            .getPublishableStateBySmartId(
                                                deviceData.smartId);
                                    try {
                                      val
                                          ? _dataList[deviceData.id] = 1
                                          : _dataList[deviceData.id] = 0;
                                      mqtt.publish(
                                        topic: mqtt.getTopic(
                                          username: TEST_USERNAME,
                                          type: SmartMqttTopic
                                              .SwitchStateAppToNode,
                                        ),
                                        message: JsonAppToNodeSwitchState(
                                          smartId: deviceData.smartId,
                                          dataList: _dataList,
                                        ).toJsonString(),
                                      );
                                    } on RangeError {
                                      throw SmartException(
                                        SmartException
                                            .appToNodeSwitchStateUpdateException,
                                        errorCausedBy: 'SmartDevicePage',
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: SmartCard(
                      helper: helper,
                      blurRadius: SmartCardBlurRadius.Spread14,
                      shadowColor: Colors.indigo[300],
                      elevation: 12,
                      cornerRadius: 0,
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: Container(
                          height: 48,
                          width: double.infinity,
                          decoration: helper.isDarkModeActive
                              ? BoxDecoration(
                                  color: Color.fromRGBO(25, 25, 25, 1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                )
                              : BoxDecoration(
                                  gradient: LinearGradient(
                                    tileMode: TileMode.mirror,
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.indigo[800],
                                      Colors.indigo[400],
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              highlightColor: Colors.transparent,
                              splashColor: helper.isDarkModeActive
                                  ? Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.25)
                                  : Colors.white24,
                              child: Center(
                                child: Text(
                                  'SAVE',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
