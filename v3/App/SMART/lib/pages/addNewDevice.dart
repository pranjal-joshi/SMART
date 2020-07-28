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

  final SmartAppBar _appBar = SmartAppBar(title: 'Add New Device');

  final SvgPicture _imgWidget = SvgPicture.asset(
    'assets/images/buy_house.svg',
    fit: BoxFit.fill,
  );

  Widget getScanningWidget(SmartHelper helper) {
    return Container(
      width: helper.screenWidth * 0.4,
      height: (helper.screenHeight - _appBar.preferredSize.height) * 0.15,
      child: SvgPicture.asset(
        'assets/images/router.svg',
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);
    return Scaffold(
      appBar: _appBar,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("ADD"),
        icon: const Icon(Icons.add),
        onPressed: () {},
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
            Container(
              width: helper.screenWidth * 0.8,
              height:
                  (helper.screenHeight - _appBar.preferredSize.height) * 0.25,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 4,
              ),
              child: _imgWidget,
            ),
            if (!_showScanningLogo)
              Shimmer.fromColors(
                baseColor: Theme.of(context).primaryColorDark.withOpacity(0.75),
                highlightColor: Colors.blue[500],
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                  child: Column(
                    children: <Widget>[
                      getScanningWidget(helper),
                      SizedBox(height: 16,),
                      Text(
                        "Searching for Devices..",
                        style: Theme.of(context).textTheme.headline1,
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
}
