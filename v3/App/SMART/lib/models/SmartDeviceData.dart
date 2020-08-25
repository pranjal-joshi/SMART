import 'package:flutter/material.dart';

class SmartDeviceData {
  String smartId;
  String deviceName;
  int id; // Should be 0-3 as per NoD
  IconData iconData;
  bool switchState;
  bool showTimerIcon;
  bool showMotionIcon;

  SmartDeviceData({
    @required this.smartId,
    @required this.deviceName,
    @required this.id,
    @required this.iconData,
    @required this.switchState,
    this.showTimerIcon = true,
    this.showMotionIcon = true,
  });
}
