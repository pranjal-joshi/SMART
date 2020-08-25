import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../models/SmartDeviceData.dart';

import '../providers/JsonRoomStateProvider.dart';

import '../helpers/SmartHelper.dart';
import '../widgets/SmartCard.dart';

class SmartDeviceCard extends StatefulWidget {
  final SmartDeviceData deviceData;
  final SmartHelper helper;
  final BoxConstraints constraints;
  final MaterialColor textColor;
  final void Function(bool) onToggle;
  final void Function() onTap;

  SmartDeviceCard({
    @required this.deviceData,
    @required this.helper,
    @required this.constraints,
    @required this.textColor,
    @required this.onTap,
    this.onToggle,
  });

  @override
  _SmartDeviceCardState createState() => _SmartDeviceCardState();
}

class _SmartDeviceCardState extends State<SmartDeviceCard> {
  bool _switchState;
  var _stateProvider;

  @override
  void initState() {
    _switchState = widget.deviceData.switchState;
    _stateProvider = Provider.of<JsonRoomStateProvider>(context, listen: false);
    _stateProvider.addListener(_switchStateChangeListener);
    super.initState();
  }

  @override
  void dispose() {
    _stateProvider.removeListener(_switchStateChangeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      helper: widget.helper,
      cornerRadius: 28,
      elevation: 10,
      blurRadius: SmartCardBlurRadius.Subtle,
      child: Stack(
        children: [
          Positioned(
            top: widget.constraints.maxHeight / 12,
            left: 24,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                widget.deviceData.iconData,
                size: 64,
                color: widget.helper.isDarkModeActive
                    ? Colors.grey.withOpacity(0.7)
                    : Theme.of(context).accentColor.withOpacity(0.75),
              ),
            ),
          ),
          Positioned(
            top: widget.constraints.maxHeight / 2,
            left: 12,
            right: 52,
            child: Text(
              widget.deviceData.deviceName,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    color: widget.helper.isDarkModeActive
                        ? widget.textColor[300]
                        : widget.textColor,
                  ),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            top: widget.constraints.maxHeight / 12,
            right: 8,
            child: Row(
              children: [
                if (widget.deviceData.showTimerIcon)
                  Icon(
                    LineAwesomeIcons.clock_o,
                    color: widget.helper.isDarkModeActive
                        ? Colors.white30
                        : Colors.grey,
                    size: 22,
                  ),
                if (widget.deviceData.showMotionIcon)
                  Icon(
                    Icons.directions_walk,
                    color: widget.helper.isDarkModeActive
                        ? Colors.white30
                        : Colors.grey,
                    size: 22,
                  )
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 16,
            child: Icon(
              LineAwesomeIcons.arrow_right,
              color:
                  widget.helper.isDarkModeActive ? Colors.white30 : Colors.grey,
              size: 28,
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                highlightColor: Colors.transparent,
                splashColor:
                    Theme.of(context).primaryColorDark.withOpacity(0.25),
              ),
            ),
          ),
          // Important to position the switch above the InkWell in the stack
          Align(
            alignment: Alignment.centerRight,
            child: RotatedBox(
              quarterTurns: 3,
              /*child: Consumer<JsonRoomStateProvider>(
                builder: (_, stateProvider, __) {
                  _switchState = stateProvider.getStateBySmartId(
                      widget.deviceData.smartId)[widget.deviceData.id];
                  return Switch.adaptive(
                    inactiveTrackColor:
                        widget.helper.isDarkModeActive ? Colors.white24 : null,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    value: _switchState,
                    onChanged: (val) {
                      setState(() => _switchState = !_switchState);
                      if (widget.onToggle != null) widget.onToggle(val);
                      print(
                          '[SmartDeviceCard] Toggle = $val -> ID: ${widget.deviceData.smartId} - ${widget.deviceData.id}');
                    },
                  );
                },
              ),*/
              child: Switch.adaptive(
                inactiveTrackColor:
                    widget.helper.isDarkModeActive ? Colors.white24 : null,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                value: _switchState,
                onChanged: (val) {
                  setState(() => _switchState = !_switchState);
                  if (widget.onToggle != null) widget.onToggle(val);
                  print(
                      '[SmartDeviceCard] Toggle = $val -> ID: ${widget.deviceData.smartId} - ${widget.deviceData.id}');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _switchStateChangeListener() {
    setState(() => _switchState = _stateProvider
        .getStateBySmartId(widget.deviceData.smartId)[widget.deviceData.id]);
  }
}
