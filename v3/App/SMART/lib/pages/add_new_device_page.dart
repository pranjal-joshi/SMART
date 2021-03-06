import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wifi/wifi.dart';
import 'package:location/location.dart';

import '../controllers/SmartSync.dart';
import '../controllers/SmartMqtt.dart';
import '../helpers/SmartHelper.dart';

import '../widgets/SmartAppBar.dart';
import '../widgets/SmartCard.dart';

class AddNewDevicePage extends StatefulWidget {
  @override
  _AddNewDevicePageState createState() => _AddNewDevicePageState();
}

class _AddNewDevicePageState extends State<AddNewDevicePage> {
  SmartHelper helper;
  Location location = Location();
  bool _locServiceEnabled = false;
  PermissionStatus _permissionStatus = PermissionStatus.granted;

  bool _showScanningLogo = false;
  bool _showFab = true;
  Widget _fabLabel = Text("ADD");
  Icon _fabIcon = Icon(Icons.add);
  int _searchFailed = -1;
  List<String> _wiList = [];

  final SmartAppBar _appBar = SmartAppBar(
    title: 'Add New Device',
    showActions: false,
  );

  final List<SmartMqttTopic> _subscriptionList = [
    SmartMqttTopic.AppDeviceConfig,
    SmartMqttTopic.AppRoomList,
  ];

  void scanWifi() async {
    Wifi.list(SMART_SSID_FILTER).then((value) {
      _showScanningLogo = false;
      _showFab = true;
      _fabLabel = Text("REFRESH");
      _fabIcon = Icon(Icons.refresh);
      _wiList.clear();
      value.forEach((element) {
        _wiList.add(element.ssid);
      });
      /*_wiList.add('SMART_00DCB288_4');
      _wiList.add('SMART_00DCB435_2');
      _wiList.add('SMART_00DAC268_1');
      _wiList.add('SMART_00CE379A_S');*/
      if (_wiList.length == 0)
        _searchFailed = 1;
      else
        _searchFailed = 0;
      setState(() {});
    });
  }

  Future<PermissionStatus> getPermissions() async {
    _locServiceEnabled = await location.serviceEnabled();
    if (!_locServiceEnabled) {
      _locServiceEnabled = await location.requestService();
      if (!_locServiceEnabled) return PermissionStatus.denied;
    }
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted)
        return PermissionStatus.denied;
      else
        return PermissionStatus.granted;
    } else
      return PermissionStatus.granted;
  }

  @override
  void initState() {
    // Init MQTT connection - TODO implement connectivity check with this later!
    SmartMqtt mqtt = SmartMqtt(debug: true);
    mqtt.connect();
    mqtt.subscribeMultiple(_subscriptionList);
    mqtt.stream.asBroadcastStream().listen((msg) async {
      SmartSync smartSync = SmartSync(debug: true);
      smartSync.syncMqttWithSp(msg);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    return Scaffold(
      appBar: _appBar,
      floatingActionButton: _showFab
          ? SmartCard(
              helper: helper,
              cornerRadius: 48,
              elevation: 12,
              blurRadius: SmartCardBlurRadius.Subtle,
              shadowColor: Theme.of(context).accentColor,
              child: FloatingActionButton.extended(
                label: _fabLabel,
                icon: _fabIcon,
                onPressed: () async {
                  _wiList.clear();
                  _searchFailed = -1;
                  _showScanningLogo = true;
                  _showFab = false;
                  _permissionStatus = await getPermissions();
                  if (_permissionStatus == PermissionStatus.granted) {
                    Timer.periodic(
                      Duration(seconds: 3),
                      (timer) {
                        timer.cancel();
                        scanWifi();
                      },
                    );
                  } else {
                    _fabLabel = Text("RETRY");
                    _fabIcon = Icon(Icons.refresh);
                    _searchFailed = -1;
                    _showScanningLogo = false;
                    _showFab = true;
                  }
                  setState(() {});
                },
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                // So that column can get screen width & CrossAxisAlignment will work
                width: helper.screenWidth,
                child: null,
              ),
              if (_permissionStatus != PermissionStatus.granted)
                _getPermissionFailedWidget(helper)
              else if (_showScanningLogo && _searchFailed < 1)
                _getScanningWidget(helper)
              else if (_searchFailed < 1 && _wiList.length == 0)
                _getEmptyWidget(helper),
              if (_searchFailed > 0 && _wiList.length == 0)
                _getSearchFailedWidget(helper),
              if (_searchFailed < 1 && _wiList.length > 0)
                _getSearchOkWidget(helper),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getEmptyWidget(SmartHelper helper) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: (helper.screenHeight - _appBar.preferredSize.height) / 6,
        ),
        Container(
          width: helper.screenWidth * 0.8,
          height: (helper.screenHeight - _appBar.preferredSize.height) * 0.25,
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 4,
          ),
          child: SvgPicture.asset(
            'assets/images/buy_house.svg',
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          child: const Text(
            "Let's Get Started By Adding New Devices",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getScanningWidget(SmartHelper helper) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColorDark,
      highlightColor: Colors.indigo,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 4,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: (helper.screenHeight - _appBar.preferredSize.height) / 6,
            ),
            Container(
              width: helper.screenWidth * 0.3,
              height:
                  (helper.screenHeight - _appBar.preferredSize.height) * 0.15,
              child: SvgPicture.asset(
                'assets/images/router.svg',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              child: Text(
                "Searching\nNearby Devices",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSearchFailedWidget(SmartHelper helper) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: (helper.screenHeight - _appBar.preferredSize.height) / 6,
        ),
        Container(
          width: helper.screenWidth * 0.8,
          height: (helper.screenHeight - _appBar.preferredSize.height) * 0.25,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 4,
          ),
          child: SvgPicture.asset(
            'assets/images/not_found.svg',
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          child: const Text(
            "No S.M.A.R.T Devices Nearby!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getPermissionFailedWidget(SmartHelper helper) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: (helper.screenHeight - _appBar.preferredSize.height) / 6,
        ),
        Container(
          width: helper.screenWidth * 0.8,
          height: (helper.screenHeight - _appBar.preferredSize.height) * 0.25,
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 4,
          ),
          child: SvgPicture.asset(
            'assets/images/location_review.svg',
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 16,
          ),
          child: const Text(
            "Can't Search Without Your Location!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getSearchOkWidget(SmartHelper helper) {
    return SizedBox(
      height: helper.screenHeight - _appBar.preferredSize.height,
      child: ListView.builder(
        itemCount: _wiList.length,
        itemBuilder: (ctx, index) {
          if (_titleGenerator(_wiList[index]) != null)
            return ListTile(
              leading: Icon(
                Icons.wifi_lock,
                size: 32,
                color: Theme.of(context).primaryColorDark,
              ),
              title: Text(
                _titleGenerator(_wiList[index]),
                style: Theme.of(context).textTheme.headline3,
              ),
              subtitle: _subtitleWidgetGenerator(_wiList[index]),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColorDark.withOpacity(0.7),
              ),
              onTap: () {
                Wifi.connection(_wiList[index], SMART_PASSWORD).then(
                  (state) {
                    if (state == WifiState.success) {
                      Navigator.of(context).pushNamed(
                        route_configureDevice,
                        arguments: {
                          'ssid': _titleGenerator(_wiList[index]),
                          'info': _subtitleGenerator(_wiList[index]),
                        },
                      );
                    } else {
                      print('Failed to connect Selected WiFi network!');
                    }
                  },
                );
              },
            );
          else
            return null;
        },
      ),
    );
  }

  String _titleGenerator(String ssid) {
    try {
      List<String> s = ssid.split('_');
      return '${s[0]} ${s[1]}';
    } on RangeError catch (_) {
      return null;
    }
  }

  Widget _subtitleWidgetGenerator(String ssid) {
    try {
      List<String> s = ssid.split('_');
      String sub;
      switch (s[2]) {
        case 'S':
          sub = 'Sensor Node';
          break;
        case '1':
          sub = 'SwitchBox - ${s[2]} Device';
          break;
        default:
          sub = 'SwitchBox - ${s[2]} Devices';
      }
      return Text(
        sub,
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    } on RangeError catch (_) {
      return null;
    }
  }

  String _subtitleGenerator(String ssid) {
    try {
      List<String> s = ssid.split('_');
      String sub;
      switch (s[2]) {
        case 'S':
          sub = 'Sensor Node';
          break;
        case '1':
          sub = 'SwitchBox - ${s[2]} Device';
          break;
        default:
          sub = 'SwitchBox - ${s[2]} Devices';
      }
      return sub;
    } on RangeError catch (_) {
      return '';
    }
  }
}
