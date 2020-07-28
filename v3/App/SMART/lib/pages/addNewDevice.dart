import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../models/SmartConstants.dart';
import '../widgets/SmartAppBar.dart';

class AddNewDevice extends StatefulWidget {
  @override
  _AddNewDeviceState createState() => _AddNewDeviceState();
}

class _AddNewDeviceState extends State<AddNewDevice> {
  SmartHelper helper;

  bool _showScanningLogo = false;

  final SmartAppBar _appBar = SmartAppBar(
    title: 'Add New Device',
    showActions: false,
  );

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);
    return Scaffold(
      appBar: _appBar,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("ADD"),
        icon: const Icon(Icons.add),
        onPressed: () {
          setState(() => _showScanningLogo = !_showScanningLogo);
        },
      ),
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
            if (_showScanningLogo)
              _getScanningWidget(helper)
            else
              _getEmptyWidget(helper),
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
      baseColor: Theme.of(context).primaryColorDark.withOpacity(0.75),
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
}
