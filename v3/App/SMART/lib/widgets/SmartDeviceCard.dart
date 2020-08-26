import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../controllers/SmartMqtt.dart';

import '../models/SmartDeviceData.dart';
import '../models/JsonModel.dart';

import '../providers/JsonRoomStateProvider.dart';

import '../helpers/SmartHelper.dart';
import '../widgets/SmartCard.dart';

import '../exceptions/SmartException.dart';

class SmartDeviceCard extends StatefulWidget {
  final SmartMqtt mqtt;
  final SmartDeviceData deviceData;
  final SmartHelper helper;
  final BoxConstraints constraints;
  final MaterialColor textColor;
  final void Function(bool) onToggle;
  final void Function() onTap;

  SmartDeviceCard({
    @required this.mqtt,
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
  JsonRoomStateProvider _stateProvider;

  @override
  void initState() {
    // Get switch state sepcified in constructor
    _switchState = widget.deviceData.switchState;

    // Set listener to StateProvider - Handle Real time toggles from MQTT
    _stateProvider = Provider.of<JsonRoomStateProvider>(context, listen: false);
    _stateProvider.addListener(_switchStateChangeListener);
    super.initState();
  }

  @override
  void dispose() {
    // Clear provider listener
    _stateProvider.removeListener(_switchStateChangeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      helper: widget.helper,
      cornerRadius: widget.helper.screenWidth * 0.07,
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
              child: Switch.adaptive(
                inactiveTrackColor:
                    widget.helper.isDarkModeActive ? Colors.white24 : null,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                value: _switchState,
                onChanged: (val) {
                  setState(() => _switchState = !_switchState);
                  // Publish state packet to gateway node 
                  if (widget.mqtt != null) {
                    List<int> _dataList = Provider.of<JsonRoomStateProvider>(
                            context,
                            listen: false)
                        .getPublishableStateBySmartId(
                            widget.deviceData.smartId);
                    try {
                      val
                          ? _dataList[widget.deviceData.id] = 1
                          : _dataList[widget.deviceData.id] = 0;
                      widget.mqtt.publish(
                        topic: widget.mqtt.getTopic(
                          username: TEST_USERNAME,
                          type: SmartMqttTopic.SwitchStateAppToNode,
                        ),
                        message: JsonAppToNodeSwitchState(
                          smartId: widget.deviceData.smartId,
                          dataList: _dataList,
                        ).toJsonString(),
                      );
                    } on RangeError {
                      throw SmartException(
                        SmartException.appToNodeSwitchStateUpdateException,
                        errorCausedBy: 'SmartDeviceCard',
                      );
                    }
                  }
                  if (widget.onToggle != null) widget.onToggle(val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handler to reflect toggle changes in real time
  void _switchStateChangeListener() {
    setState(() => _switchState = _stateProvider
        .getStateBySmartId(widget.deviceData.smartId)[widget.deviceData.id]);
  }
}
