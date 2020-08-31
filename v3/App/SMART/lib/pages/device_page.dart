import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'dart:io' show Platform;

import '../helpers/SmartHelper.dart';

import '../controllers/SmartMqtt.dart';

import '../models/SmartDeviceData.dart';

import '../widgets/SmartCard.dart';

class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  SmartHelper helper;
  SmartMqtt mqtt = SmartMqtt();
  Map<String, dynamic> args = {};
  SmartDeviceData deviceData;
  bool _switchState = false;
  bool _scheduleEnabled = false;
  bool _motionEnabled = false;
  bool _firstTime = true;
  Icon _editDeviceIcon;
  IconData _iconToDisplay;
  TimeOfDay _pickedOnTime;
  TimeOfDay _pickedOffTime;
  String _pickedOnLabel;
  String _pickedOffLabel;
  List<bool> _weekdayList = List.filled(7, true, growable: false);
  final _editingController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_firstTime) {
      _firstTime = false;
      args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      deviceData = args['deviceData'];
      _switchState = deviceData.switchState;
      _scheduleEnabled = deviceData.showTimerIcon;
      _motionEnabled = deviceData.showMotionIcon;
      _editingController.text = deviceData.deviceName;
      _iconToDisplay = deviceData.iconData;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                _getControlArea(constraints),
                Align(
                  alignment: Alignment.topCenter,
                  child: SmartCard(
                    helper: helper,
                    elevation: 24,
                    shadowColor: Colors.indigo[300],
                    blurRadius: SmartCardBlurRadius.Spread22,
                    cornerRadius: 10,
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight / 3 -
                          MediaQuery.of(context).padding.top,
                      decoration: helper.isDarkModeActive
                          ? BoxDecoration(
                              color: Color.fromRGBO(25, 25, 25, 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            )
                          : BoxDecoration(
                              gradient: LinearGradient(
                                tileMode: TileMode.mirror,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(context).primaryColorDark,
                                  Colors.indigo[700],
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 6,
                              left: 6,
                              child: IconButton(
                                icon: Icon(
                                  Platform.isAndroid
                                      ? Icons.arrow_back
                                      : Icons.arrow_back_ios,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                                onPressed: () => ModalRoute.of(context).canPop
                                    ? Navigator.of(context).pop()
                                    : null,
                                tooltip: 'Back',
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  _iconToDisplay,
                                  size: constraints.maxWidth / 2.5,
                                  color: Colors.white30,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: IconButton(
                                tooltip: 'Edit Device',
                                iconSize: 26,
                                icon: Icon(
                                  LineIcons.edit,
                                  color:
                                      Theme.of(context).primaryIconTheme.color,
                                ),
                                onPressed: () =>
                                    _editDeviceDialog(context: context),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: constraints.maxWidth / 2,
                                  left: 16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        deviceData.deviceName,
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: helper.isDarkModeActive
                                              ? Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.9)
                                              : Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Row(
                                children: [
                                  if (_scheduleEnabled)
                                    Icon(
                                      LineIcons.clock,
                                      color: Colors.white54,
                                      size: 28,
                                    ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  if (_motionEnabled)
                                    Icon(
                                      LineIcons.walking_solid,
                                      color: Colors.white54,
                                      size: 28,
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: SmartCard(
                      helper: helper,
                      blurRadius: SmartCardBlurRadius.Spread14,
                      shadowColor: Colors.indigo[300],
                      elevation: 12,
                      cornerRadius: 0,
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: Container(
                          height: 56,
                          width: double.infinity,
                          decoration: helper.isDarkModeActive
                              ? BoxDecoration(
                                  color: Color.fromRGBO(25, 25, 25, 1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                )
                              : BoxDecoration(
                                  gradient: LinearGradient(
                                    tileMode: TileMode.mirror,
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.indigo[800],
                                      Colors.indigo[400],
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              highlightColor: Colors.transparent,
                              splashColor: helper.isDarkModeActive
                                  ? Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.25)
                                  : Colors.white24,
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LineIcons.cloud_upload_alt_solid,
                                      size: 30,
                                      color: helper.isDarkModeActive
                                          ? Theme.of(context).accentColor
                                          : Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'SAVE',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                            letterSpacing: 1.5,
                                            fontSize: 20,
                                            color: helper.isDarkModeActive
                                                ? Theme.of(context).accentColor
                                                : Colors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _getSwitchTile({
    @required final Icon icon,
    @required final String title,
    final String subtitle,
    @required final bool value,
    @required final void Function(bool) onChanged,
  }) {
    return SwitchListTile(
      dense: true,
      inactiveTrackColor: helper.isDarkModeActive ? Colors.white24 : null,
      secondary: icon,
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline3.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: Theme.of(context).textTheme.subtitle1,
            )
          : null,
      value: value,
      onChanged: (val) => onChanged(val),
    );
  }

  Widget _getAnimatedExpander({
    final int millliseconds = 300,
    @required final bool controller,
    @required final Widget child,
  }) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: millliseconds),
      opacity: controller ? 1 : 0,
      curve: Curves.easeIn,
      child: AnimatedContainer(
        duration: Duration(milliseconds: millliseconds),
        width: double.infinity,
        // TODO - Fix this null error
        height: controller ? null : 0,
        curve: Curves.easeIn,
        child: SingleChildScrollView(child: child),
      ),
    );
  }

  Widget _getDivider() {
    return Divider(
      color: Colors.grey.withOpacity(0.7),
      indent: 8,
      endIndent: 8,
    );
  }

  Widget _getControlArea(final BoxConstraints constraints) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: constraints.maxHeight / 4,
          bottom: 52,
        ),
        child: ListView(
          children: [
            // Power Switch Tile
            const SizedBox(height: 24),
            _getSwitchTile(
              icon: Icon(
                LineIcons.power_off_solid,
                color: _getColorForIcon(_switchState),
                size: 28,
              ),
              title: 'Control Power',
              subtitle: _switchState ? 'Switched ON' : 'Switched OFF',
              value: _switchState,
              onChanged: (val) {
                setState(() => _switchState = val);
                mqtt.toggleNodeSwitchState(
                  context: context,
                  value: val,
                  deviceData: deviceData,
                  erroCausedBy: 'DevicePage',
                );
              },
            ),
            _getDivider(),
            // Schedule control switch tile
            _getSwitchTile(
              icon: Icon(
                LineIcons.clock,
                color: _getColorForIcon(_scheduleEnabled),
                size: 28,
              ),
              title: 'Schedule',
              subtitle: _scheduleEnabled ? 'Manage Schedule Time' : 'Disabled',
              value: _scheduleEnabled,
              onChanged: (val) {
                setState(() => _scheduleEnabled = val);
              },
            ),
            _getAnimatedExpander(
              controller: _scheduleEnabled,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Switch ON Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getBodyTextColor,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: FlatButton(
                          onPressed: () async {
                            _pickedOnTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              helpText: 'Select Time to Switch ON',
                            );
                            if (_pickedOnTime != null) {
                              setState(() => _pickedOnLabel =
                                  _pickedOnTime.format(context));
                            }
                          },
                          child: Text(
                            _pickedOnLabel == null ? 'SELECT' : _pickedOnLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textColor: helper.indigoColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(
                              color: helper.indigoColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Switch OFF Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getBodyTextColor,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: FlatButton(
                          onPressed: () async {
                            _pickedOffTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                helpText: 'Select Time to Switch OFF');
                            if (_pickedOffTime != null) {
                              setState(() => _pickedOffLabel =
                                  _pickedOffTime.format(context));
                            }
                          },
                          child: Text(
                            _pickedOffLabel == null
                                ? 'SELECT'
                                : _pickedOffLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textColor: helper.indigoColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(
                              color: helper.indigoColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 16,
                      top: 12,
                      bottom: 8,
                    ),
                    child: Text(
                      'Select Weekdays',
                      style: Theme.of(context).textTheme.headline3.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _getBodyTextColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: WeekdaySelector(
                      values: _weekdayList,
                      onChanged: (dayIndex) {
                        final index = dayIndex % 7;
                        _weekdayList[index] = !_weekdayList[index];
                        setState(() {});
                      },
                      fillColor: helper.isDarkModeActive == true
                          ? Colors.grey[850]
                          : null,
                      selectedFillColor: helper.indigoColor,
                      selectedTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: helper.isDarkModeActive
                            ? Colors.black
                            : Colors.white,
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: helper.isDarkModeActive
                            ? _getBodyTextColor
                            : helper.indigoColor,
                        fontSize: 16,
                      ),
                      firstDayOfWeek: 7,
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),
            _getDivider(),
            _getSwitchTile(
              icon: Icon(
                LineIcons.walking_solid,
                color: _getColorForIcon(_motionEnabled),
                size: 28,
              ),
              title: 'MotionSense',
              subtitle: _motionEnabled ? 'Active' : 'Disabled',
              value: _motionEnabled,
              onChanged: (val) {
                setState(() => _motionEnabled = val);
              },
            ),
            _getAnimatedExpander(
              controller: _motionEnabled,
              child: Placeholder(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _editDeviceDialog({@required BuildContext context}) {
    final OutlineInputBorder outlineInputBorder_2 = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColorDark,
        width: 2,
      ),
    );
    final OutlineInputBorder outlineInputBorder_3 = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColorDark,
        width: 3,
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            "Edit Device",
            textAlign: TextAlign.start,
          ),
          titleTextStyle: Theme.of(context).textTheme.headline1,
          content: TextFormField(
            cursorColor: Theme.of(context).primaryColorDark,
            textInputAction: TextInputAction.done,
            style: Theme.of(context).textTheme.headline3,
            controller: _editingController,
            validator: (msg) {
              if (msg == null) {
                return 'Can\'t be left blank!';
              }
              return null;
            },
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Device Name',
              hintText: 'E.g. Lamp or TV',
              hintMaxLines: 2,
              hintStyle: TextStyle(
                color: Theme.of(context).textTheme.subtitle1.color,
                fontSize: Theme.of(context).textTheme.headline3.fontSize,
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              border: outlineInputBorder_2,
              enabledBorder: outlineInputBorder_2,
              focusedBorder: outlineInputBorder_3,
              errorBorder: outlineInputBorder_2,
              errorMaxLines: 2,
              errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: helper.isDarkModeActive
                    ? Colors.blue[400]
                    : Colors.blue[700],
              ),
              prefixIcon: IconButton(
                icon: _editDeviceIcon == null
                    ? Icon(
                        LineIcons.lightbulb,
                        color: Theme.of(context).primaryColorDark,
                        size: 32,
                      )
                    : _editDeviceIcon,
                onPressed: () async {
                  IconData iconData = await FlutterIconPicker.showIconPicker(
                    context,
                    iconPackMode: IconPack.lineAwesomeIcons,
                    backgroundColor: Theme.of(context).canvasColor,
                    iconColor: Theme.of(context).accentColor,
                    iconPickerShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      'Select Icon',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  );
                  if (iconData != null) _iconToDisplay = iconData;
                  _editDeviceIcon = Icon(
                    iconData != null ? iconData : LineIcons.lightbulb,
                    color: Theme.of(context).primaryColorDark,
                    size: 32,
                  );
                  setState(() {
                    Navigator.of(context).pop();
                    _editDeviceDialog(context: context);
                  });
                },
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FlatButton(
              onPressed: () async {
                //TODO - Implement Rename Device Logic
                setState(() => Navigator.of(context).pop());
              },
              child: Text(
                'SAVE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getColorForIcon(bool isActive) {
    if (isActive) return Theme.of(context).primaryColor;
    return Colors.grey;
  }

  Color get _getBodyTextColor {
    if (helper.isDarkModeActive) return Colors.white60;
    return Colors.black87;
  }
}
