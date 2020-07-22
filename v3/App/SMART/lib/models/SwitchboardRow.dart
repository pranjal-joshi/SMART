import 'package:flutter/material.dart';

class SwitchboardRow {
  String deviceName;
  String deviceDescription;
  bool deviceState;
  IconData deviceIcon;

  SwitchboardRow({
    this.deviceName,
    this.deviceDescription,
    this.deviceState,
    this.deviceIcon,
  });
}