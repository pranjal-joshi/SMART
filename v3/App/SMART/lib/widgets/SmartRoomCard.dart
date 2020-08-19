import 'package:flutter/material.dart';

import '../helpers/SmartHelper.dart';
import '../models/SmartRoomData.dart';

import '../widgets/SmartRoomIndicator.dart';
import '../widgets/SmartGradient.dart';

class SmartRoomCard extends StatelessWidget {
  final SmartHelper helper;
  final SmartRoomData roomData;
  final SmartRoomIndicatorState indicatorState;
  final Function onTap;

  SmartRoomCard({
    @required this.helper,
    @required this.roomData,
    this.onTap,
    this.indicatorState = SmartRoomIndicatorState.indicatorDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        highlightColor: Colors.transparent,
        splashColor: Theme.of(context).primaryColorDark.withOpacity(0.25),
        child: Stack(
          clipBehavior: Clip.antiAliasWithSaveLayer,
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
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    // color: Theme.of(context).primaryColorDark,
                    color: helper.isDarkModeActive
                        ? Colors.indigo[300]
                        : Colors.indigo,
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
                  size: helper.screenWidth / 2.9,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Icon(
                Icons.arrow_forward,
                size: 28,
                // color: Theme.of(context).primaryColorDark.withOpacity(0.6),
                color: helper.isDarkModeActive
                    ? Colors.indigo[300].withOpacity(0.6)
                    : Colors.indigo.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
