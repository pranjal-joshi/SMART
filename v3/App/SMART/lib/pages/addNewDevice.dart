import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wifi/wifi.dart';

import '../models/SmartConstants.dart';
import '../widgets/SmartAppBar.dart';

class AddNewDevice extends StatefulWidget {
  @override
  _AddNewDeviceState createState() => _AddNewDeviceState();
}

class _AddNewDeviceState extends State<AddNewDevice> {
  SmartHelper helper;

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

  void scanWifi() async {
    Wifi.list('').then((value) {
      _showScanningLogo = false;
      _showFab = true;
      _fabLabel = Text("REFRESH");
      _fabIcon = Icon(Icons.refresh);
      _wiList.clear();
      /*value.forEach((element) {
        _wiList.add(element.ssid);
      });*/
      _wiList.add('SMART_00DCB288_4');
      _wiList.add('SMART_00DCB435_2');
      _wiList.add('SMART_00DAC268_1');
      _wiList.add('SMART_00CE379A_S');
      if (_wiList.length == 0)
        _searchFailed = 1;
      else
        _searchFailed = 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);
    return Scaffold(
      appBar: _appBar,
      floatingActionButton: _showFab
          ? FloatingActionButton.extended(
              label: _fabLabel,
              icon: _fabIcon,
              onPressed: () {
                _wiList.clear();
                _searchFailed = -1;
                _showScanningLogo = true;
                _showFab = false;
                Timer.periodic(
                  Duration(seconds: 3),
                  (timer) {
                    timer.cancel();
                    scanWifi();
                  },
                );
                setState(() {});
              },
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              // So that column can get screen width & CrossAxisAlignment will work
              width: helper.screenWidth,
              child: null,
            ),
            if (_showScanningLogo && _searchFailed < 1)
              _getScanningWidget(helper)
            else if (_searchFailed < 1 && _wiList.length == 0)
              _getEmptyWidget(helper),
            if (_searchFailed > 0) _getSearchFailedWidget(helper),
            if (_searchFailed < 1 && _wiList.length > 0)
              _getSearchOkWidget(helper),
          ],
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
          padding: EdgeInsets.symmetric(
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

  Widget _getSearchOkWidget(SmartHelper helper) {
    /*return ListTile(
      leading: Icon(
        Icons.wifi_lock,
        size: 32,
        color: Theme.of(context).primaryColorDark,
      ),
      title: Text(
        _wiList[0],
        style: Theme.of(context).textTheme.headline3,
      ),
      subtitle: const Text("Tap to Add"),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).primaryColorDark.withOpacity(0.7),
      ),
      onTap: () => onWifiSelect(_wiList[0]),
    );*/
    return SizedBox(
      height: helper.screenHeight - _appBar.preferredSize.height,
      child: ListView.builder(
        itemCount: _wiList.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: Icon(
              Icons.wifi_lock,
              size: 32,
              color: Theme.of(context).primaryColorDark,
            ),
            title: Text(
              titleGenerator(_wiList[index]),
              style: Theme.of(context).textTheme.headline3,
            ),
            subtitle: subtitleGenerator(_wiList[index]),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColorDark.withOpacity(0.7),
            ),
            onTap: () => onWifiSelect(_wiList[index]),
          );
        },
      ),
    );
  }

  void onWifiSelect(String ssid) {
    print('${ssid} Selected');
  }

  String titleGenerator(String ssid) {
    List<String> s = ssid.split('_');
    return '${s[0]} ${s[1]}';
  }

  Widget subtitleGenerator(String ssid) {
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
  }
}
