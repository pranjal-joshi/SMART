import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmartProfile {
  String profileName;
  IconData profileIcon;
  String roomName;
  String userName;
  List<String> smartId = [];
  List<String> state = [];

  SmartProfile({
    @required this.profileName,
    @required this.profileIcon,
    this.roomName,
    this.userName,
    this.smartId,
    this.state,
  });
}
