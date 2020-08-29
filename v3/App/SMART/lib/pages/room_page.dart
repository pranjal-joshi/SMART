import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../helpers/SmartHelper.dart';

import '../controllers/SmartMqtt.dart';

import '../models/JsonModel.dart';
import '../models/SmartProfile.dart';
import '../models/SmartPopupMenu.dart';
import '../models/SmartDeviceData.dart';

import '../providers/JsonNodeLabelProvider.dart';
import '../providers/JsonNodeInfoProvider.dart';

import '../widgets/SmartDeviceCard.dart';
import '../widgets/ProfileCard.dart';
import '../widgets/CreateProfileCard.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  SmartHelper helper;
  SmartMqtt mqtt = SmartMqtt();
  final _sliverAppBarBorder = const BorderRadius.only(
    bottomLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
  );
  final _menuList = [
    SmartPopupMenu(title: 'Edit', icon: LineIcons.edit),
    SmartPopupMenu(title: 'Reset', icon: LineIcons.sync_solid),
    SmartPopupMenu(title: 'Emergency', icon: LineIcons.power_off_solid),
  ];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> args = {};

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    helper = SmartHelper(context: context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: _sliverAppBarBorder,
              ),
              pinned: false,
              snap: false,
              floating: true,
              forceElevated: true,
              actions: [_getPopupMenuButton()],
              expandedHeight: helper.screenHeight / 2.2 -
                  MediaQuery.of(context).padding.top,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: double.infinity,
                  decoration: helper.isDarkModeActive
                      ? BoxDecoration(
                          color: Color.fromRGBO(25, 25, 25, 1),
                          borderRadius: _sliverAppBarBorder,
                        )
                      : BoxDecoration(
                          gradient: LinearGradient(
                            tileMode: TileMode.mirror,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColorDark,
                              Colors.indigo[500],
                            ],
                          ),
                          borderRadius: _sliverAppBarBorder,
                        ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 16,
                          top: 32,
                          child: Icon(
                            args['icon'],
                            size: 156,
                            color: Colors.white30,
                          ),
                        ),
                        Positioned(
                          top: 48,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  args['roomName'],
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
                              Padding(
                                padding: const EdgeInsets.only(top: 2, left: 4),
                                child: Consumer<JsonNodeLabelProvider>(
                                  builder: (_, labelData, __) => Text(
                                    '${labelData.getDeviceDataListByRoomId(args['roomName']).length} Devices',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          top: MediaQuery.of(context).padding.top * 5.2,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: const Text(
                                  'Profiles',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    height: 0.1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: getProfileCards(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverStickyHeader(
              header: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  bottom: 12,
                ),
                child: Text(
                  'All Devices',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              sliver: Consumer<JsonNodeLabelProvider>(
                builder: (_, labelData, __) {
                  final deviceList =
                      labelData.getDeviceDataListByRoomId(args['roomName']);
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: LayoutBuilder(
                          builder: (_, constraints) => SmartDeviceCard(
                              deviceData: deviceList[i],
                              helper: helper,
                              mqtt: mqtt,
                              constraints: constraints,
                              textColor: Colors.indigo,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  route_device_page,
                                  arguments: {
                                    'roomName': args['roomName'],
                                    'deviceData': deviceList[i],
                                  },
                                );
                              }),
                        ),
                      ),
                      childCount: deviceList.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 0,
                      childAspectRatio: 1 / 1,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPopupMenuButton() {
    return PopupMenuButton(
      itemBuilder: (_) => _menuList
          .map(
            (choice) => PopupMenuItem(
              value: choice,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    choice.title,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Icon(
                    choice.icon,
                    color: helper.isDarkModeActive
                        ? color_white_dark
                        : Colors.black,
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (SmartPopupMenu choice) {
        if (choice.title == 'Reset') _showResetDialog();
      },
    );
  }

  Widget getProfileCards({
    List<SmartProfile> profileList,
    SmartHelper helper,
  }) {
    final List<SmartProfile> profileList = [
      SmartProfile(profileName: "Party", profileIcon: Icons.blur_circular),
      SmartProfile(profileName: "Chill", profileIcon: Icons.music_note),
      SmartProfile(profileName: "Sleep", profileIcon: Icons.brightness_3),
      SmartProfile(profileName: "Movie", profileIcon: Icons.movie),
    ];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: profileList.length + 1,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        try {
          return Padding(
            padding: EdgeInsets.all(10),
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
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 2,
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          'Confirm Reset',
          style: Theme.of(context).textTheme.headline1,
        ),
        content: Text(
          'This will Reset all the device names and turn them off. You need to reconfigure them again.\n\nAre you sure?',
          style: Theme.of(context).textTheme.headline3,
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetAllDevices();
              helper.showSnackbarTextWithGlobalKey(
                _scaffoldKey,
                'Resetting ${args["roomName"]}...',
              );
            },
            child: Text(
              'CONFIRM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetAllDevices() {
    List<SmartDeviceData> deviceList =
        Provider.of<JsonNodeLabelProvider>(context, listen: false)
            .getDeviceDataListByRoomId(args['roomName']);
    List<SmartDeviceData> resetedList = [];
    for (int i = 0; i < deviceList.length; i++) {
      resetedList.add(
        SmartDeviceData(
          deviceName: 'Device Name',
          iconData: LineIcons.adjust_solid,
          id: deviceList[i].id,
          smartId: deviceList[i].smartId,
          switchState: false,
          showMotionIcon: false,
          showTimerIcon: false,
        ),
      );
    }
    SmartDeviceData.saveToDisk(resetedList);
    List<String> publishableList =
        resetedList.map((e) => e.toJsonString()).toList();
    final infoList = Provider.of<JsonNodeInfoProvider>(context, listen: false)
        .getInfoByRoomName(args['roomName']);
    int baseIndex = 0;
    infoList.forEach((e) {
      // Publish labels to ../smartId/labels
      mqtt.publish(
        topic: mqtt.getTopic(
          username: TEST_USERNAME,
          type: SmartMqttTopic.AppDeviceLabelsPublish,
          smartId: e.smartId,
        ),
        message: JsonNodeLabel(
          nodeName: args['roomName'],
          smartId: e.smartId,
          dataList: resetedList
              .getRange(baseIndex, baseIndex + e.nod)
              .toList()
              .map((e) => e.deviceName)
              .toList(),
        ).toJsonString(),
        retain: true,
      );
      // Publish data to ../smartId/deviceData
      mqtt.publish(
        topic: mqtt.getTopic(
          username: TEST_USERNAME,
          type: SmartMqttTopic.AppDeviceDataPublish,
          smartId: e.smartId,
        ),
        message: publishableList
            .getRange(baseIndex, baseIndex + e.nod)
            .toList()
            .toString(),
        retain: true,
      );
      baseIndex = e.nod;
    });
    // TODO: Reset the STATES of all devices, turn them OFF as well
  }
}
