import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';

enum SmartRoomIndicatorState {
  powerOn,
  powerOff,
  indicatorDisabled,
}

class SmartRoomIndicator extends StatelessWidget {
  final double size;
  final SmartRoomIndicatorState state;
  final SmartHelper helper;

  SmartRoomIndicator({
    @required this.state,
    @required this.helper,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (state) {
      case SmartRoomIndicatorState.powerOn:
        color = Colors.green;
        break;
      case SmartRoomIndicatorState.powerOff:
        color = Colors.red[400];
        break;
      case SmartRoomIndicatorState.indicatorDisabled:
        color = helper.isDarkModeActive ? Colors.grey[700] : Colors.grey[400];
        break;
      default:
        color = helper.isDarkModeActive ? Colors.grey[700] : Colors.grey[400];
    }
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            spreadRadius: 3.5,
            color: color.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}
