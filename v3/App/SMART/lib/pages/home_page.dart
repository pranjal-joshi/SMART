import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../controllers/SmartMqtt.dart';
import '../controllers/SmartSharedPref.dart';
import '../controllers/SmartSync.dart';

import '../providers/JsonNodeStatusProvider.dart';
import '../providers/JsonRoomStateProvider.dart';
import '../providers/ConnectivityProvider.dart';

import '../helpers/SmartHelper.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isConnectivityAlertOpen = false;

  final List<SmartMqttTopic> subscriptionList = [
    SmartMqttTopic.NodeStatus,
    SmartMqttTopic.NodeInfo,
    SmartMqttTopic.SwitchStateNodeToApp,
    SmartMqttTopic.AppRoomList,
    SmartMqttTopic.AppDeviceLabelsSubscribe,
    SmartMqttTopic.AppDeviceDataSubscribe,
  ];

  @override
  void initState() {
    mqtt.connect();
    mqtt.subscribeMultiple(subscriptionList);
    mqtt.stream.asBroadcastStream().listen((msg) {
      if (msg is String) {
        var decodedJson = jsonDecode(msg);
        smartSync.syncMqttWithSp(msg);
        smartSync.syncMqttWithProviders(context, msg, decodedJson);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    mqtt.unsubscribeMultiple(subscriptionList);
    mqtt.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);
    _showConnectivityAlert();

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        top: false,
        child: Container(
          width: helper.screenWidth,
          height: helper.screenHeight,
          child: Stack(
            children: [
              Positioned(
                width: helper.screenWidth,
                height: helper.screenHeight,
                child: Padding(
                  padding: EdgeInsets.only(top: helper.screenHeight / 3.3),
                  child: FutureBuilder(
                    initialData: <SmartRoomData>[],
                    future: SmartRoomData.loadFromDisk(),
                    builder: (_, AsyncSnapshot<List<SmartRoomData>> snapshot) {
                      if (snapshot.data.length == 0) {
                        return _getNoRoomLayout();
                      }
                      return ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              bottom: 16,
                            ),
                            child: Text(
                              'All Rooms',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 24,
                              childAspectRatio: 4 / 3,
                            ),
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              return Consumer<JsonRoomStateProvider>(
                                builder: (_, stateData, __) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  child: SmartRoomCard(
                                    helper: helper,
                                    color: Colors.indigo,
                                    roomData: snapshot.data[index],
                                    indicatorState:
                                        stateData.roomPowerIndicatorMap[
                                            snapshot.data[index].name],
                                    onTap: () {
                                      print(
                                          'Clicked on ${snapshot.data[index].name}');
                                      Navigator.of(context).pushNamed(
                                        route_room_page,
                                        arguments: {
                                          'roomName': snapshot.data[index].name,
                                          'icon': snapshot.data[index].icon,
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    return Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        Positioned(
                          height: constraints.maxHeight / 3.6,
                          width: constraints.maxWidth,
                          child: Container(
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
                        Positioned(
                          top: constraints.maxHeight / 5.25,
                          width: constraints.maxWidth,
                          child: Consumer<JsonNodeStatusProvider>(
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
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getNoRoomLayout() {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(route_addNewDevice),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              'assets/images/next_option.svg',
              fit: BoxFit.contain,
              width: helper.screenWidth * 0.8,
            ),
            const Text(
              "Tap Here to Setup your First S.M.A.R.T Device",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConnectivityAlert() {
    if (Provider.of<ConnectivityProviderResult>(context) ==
        ConnectivityProviderResult.none)
      Future.delayed(Duration.zero, () {
        _isConnectivityAlertOpen = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
            onWillPop: () {},
            child: AlertDialog(
              backgroundColor: Theme.of(context).canvasColor,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 2,
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LineAwesomeIcons.frown_o,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No Network',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
              content: Center(
                child: Text(
                  'Waiting for the Internet..',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: Text(
                    'EXIT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
      else {
        if(_isConnectivityAlertOpen)
          Navigator.of(context).pop();
        _isConnectivityAlertOpen = false;
      }
  }
}
