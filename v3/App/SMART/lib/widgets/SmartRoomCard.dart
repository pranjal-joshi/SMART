import 'package:flutter/material.dart';

import '../helpers/SmartHelper.dart';
import '../models/SmartRoomData.dart';

import '../widgets/SmartRoomIndicator.dart';
import '../widgets/SmartGradient.dart';
import '../widgets/SmartCard.dart';

class SmartRoomCard extends StatelessWidget {
  final SmartHelper helper;
  final SmartRoomData roomData;
  final SmartRoomIndicatorState indicatorState;
  final Function onTap;
  final MaterialColor color;

  SmartRoomCard({
    @required this.helper,
    @required this.roomData,
    @required this.color,
    this.onTap,
    this.indicatorState = SmartRoomIndicatorState.indicatorDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      helper: helper,
      cornerRadius: helper.screenWidth * 0.06,
      elevation: 10,
      blurRadius: SmartCardBlurRadius.Subtle,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: helper.screenWidth * 0.13,
              ),
              child: Text(
                roomData.name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: helper.isDarkModeActive ? color[300] : color,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 2,
              ),
            ),
          ),
          Positioned(
            top: helper.screenHeight * 0.02,
            right: helper.screenWidth * 0.05,
            child: SmartRoomIndicator(
              state: indicatorState,
              helper: helper,
            ),
          ),
          Positioned(
            top: helper.screenHeight * 0.05,
            right: helper.screenWidth * 0.05 * -1,
            child: SmartGradient(
              helper: helper,
              child: Icon(
                roomData.icon,
                size: helper.screenWidth / 3.2,
                color: Colors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                highlightColor: Colors.transparent,
                splashColor:
                    Theme.of(context).primaryColorDark.withOpacity(0.25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
