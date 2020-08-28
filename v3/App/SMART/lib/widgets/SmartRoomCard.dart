import 'package:flutter/material.dart';

import '../helpers/SmartHelper.dart';
import '../models/SmartRoomData.dart';

import '../widgets/SmartRoomIndicator.dart';
import '../widgets/SmartGradient.dart';
import '../widgets/SmartCard.dart';

class SmartRoomCard extends StatefulWidget {
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
  _SmartRoomCardState createState() => _SmartRoomCardState();
}

class _SmartRoomCardState extends State<SmartRoomCard> {
  double _elevation = 10;

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      helper: widget.helper,
      cornerRadius: widget.helper.screenWidth * 0.06,
      elevation: _elevation,
      blurRadius: _elevation > 0
          ? SmartCardBlurRadius.Subtle
          : SmartCardBlurRadius.Flat,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: widget.helper.screenWidth * 0.13,
              ),
              child: Text(
                widget.roomData.name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: widget.helper.isDarkModeActive
                      ? widget.color[300]
                      : widget.color,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 2,
              ),
            ),
          ),
          Positioned(
            top: widget.helper.screenHeight * 0.02,
            right: widget.helper.screenWidth * 0.05,
            child: SmartRoomIndicator(
              state: widget.indicatorState,
              helper: widget.helper,
            ),
          ),
          Positioned(
            top: widget.helper.screenHeight * 0.05,
            right: widget.helper.screenWidth * 0.05 * -1,
            child: SmartGradient(
              helper: widget.helper,
              child: Icon(
                widget.roomData.icon,
                size: widget.helper.screenWidth / 3.2,
                color: Colors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onHighlightChanged: (val) {
                  val
                      ? setState(() => _elevation = 0)
                      : setState(() => _elevation = 10);
                },
                highlightColor: Colors.transparent,
                splashColor:
                    Theme.of(context).primaryColorDark.withOpacity(0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
