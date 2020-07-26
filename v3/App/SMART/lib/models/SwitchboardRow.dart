import 'package:SMART/models/SmartConstants.dart';
import 'package:flutter/material.dart';

class SwitchboardRow {
  String deviceName;
  String deviceDescription;
  bool deviceState;
  IconData deviceIcon;
  String smartId;

  SwitchboardRow({
    this.deviceName,
    this.deviceDescription,
    this.deviceState,
    this.deviceIcon,
    this.smartId = TEST_SMARTID,
  });
}