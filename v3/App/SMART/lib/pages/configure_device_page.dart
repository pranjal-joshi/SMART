import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import '../controllers/SmartMqtt.dart';
import '../controllers/SmartSharedPref.dart';
import '../models/SmartConstants.dart';
import '../models/SmartWifiConfig.dart';
import '../models/SmartRoomData.dart';
import '../widgets/SmartAppBar.dart';
import '../widgets/SmartTextFormField.dart';
import '../widgets/SmartDropdown.dart';

class ConfigureDevicePage extends StatefulWidget {
  @override
  _ConfigureDevicePageState createState() => _ConfigureDevicePageState();
}

class _ConfigureDevicePageState extends State<ConfigureDevicePage> {
  SmartHelper helper;
  SmartSharedPreference sp = SmartSharedPreference();
  SmartMqtt mqtt = SmartMqtt(debug: true);
  var connectivitySubscription;
  var _wifiListRaw = List();
  Icon _addRoomIcon;
  bool _onceExecuted = false;

  String argsSsid;
  String argsInfo;

  List<SmartWifiConfig> _wifiList = List();
  List<DropdownMenuItem<SmartWifiConfig>> _dropdownList = List();
  SmartWifiConfig _selectedDropdown;

  List<SmartRoomData> _roomList = [];
  List<DropdownMenuItem<SmartRoomData>> _dropdownRoomList = List();
  SmartRoomData _selectedRoom;

  TextEditingController _passController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _ipController =
      TextEditingController(text: '35.222.110.118');
  TextEditingController _portController = TextEditingController(text: '1883');
  TextEditingController _meshSsidController = TextEditingController();
  TextEditingController _meshPassController = TextEditingController();
  TextEditingController _addRoomController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final SmartAppBar _appBar = SmartAppBar(
    title: 'Configure Device',
    showActions: false,
  );

  @override
  void initState() {
    // Create connectivity stream subscription to monitor WiFi changes and get WiFi list from node accordingly
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      print(result);
      if (result == ConnectivityResult.wifi) {
        // Rebuild on wifi connection
        setState(() {});
      }
    });
    mqtt.connect();
    // Load Details of this node if already found in SP
    Future.delayed(Duration.zero, () async {
      Map<String, dynamic> args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _roomList = await _getSmartRoomData();
      _dropdownRoomList =
          _getRoomDropdownList(roomList: _roomList, context: context);

      List<SmartConfigData> smartConfigList =
          await SmartConfigData.loadFromDisk();
      if (smartConfigList != null) {
        try {
          // If the same device config already exists, load it
          SmartConfigData thisData = smartConfigList
              .firstWhere((element) => element.smartId == args['ssid']);
          _usernameController.text = thisData.username;
          _selectedRoom = _roomList
              .firstWhere((element) => element.name == thisData.nodename);
          _ipController.text = thisData.mqttIp;
          _portController.text = thisData.mqttPort;
          _meshSsidController.text = thisData.meshSsid;
          _meshPassController.text = thisData.meshPass;
        } on StateError {
          // Attempt to load common config things if any device entry exists in SP
          if (smartConfigList.length > 0) {
            _usernameController.text = smartConfigList[0].username;
            _ipController.text = smartConfigList[0].mqttIp;
            _portController.text = smartConfigList[0].mqttPort;
            _meshSsidController.text = smartConfigList[0].meshSsid;
            _meshPassController.text = smartConfigList[0].meshPass;
          }
        }
      }
      // Initialize Icon for add new room
      _addRoomIcon = Icon(
        Icons.touch_app,
        color: Theme.of(context).primaryColorDark,
        size: 32,
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    _passController.dispose();
    _usernameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _meshSsidController.dispose();
    _meshPassController.dispose();
    _addRoomController.dispose();
    super.dispose();
  }

  Future<String> fetchWebpage() async {
    var response = await http.get(NODE_IP);
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    final TextStyle _headingStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColorDark,
    );

    Map<String, dynamic> args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    argsSsid = args['ssid'];
    argsInfo = args['info'];

    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'SAVE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: helper.isDarkModeActive ? Colors.black : color_white_dark,
          ),
        ),
        icon: Icon(Icons.save),
        onPressed: () async {
          if (_selectedRoom == null)
            helper.showSnackbarTextWithGlobalKey(
              _scaffoldKey,
              'Select Device Location to Continue!',
            );
          else if (_selectedDropdown == null)
            helper.showSnackbarTextWithGlobalKey(
              _scaffoldKey,
              'Select WiFi Network to Continue!',
            );
          else if (_formKey.currentState.validate() &&
              _selectedDropdown != null &&
              _selectedRoom != null) {
            SmartConfigData data = SmartConfigData(
              smartId: args['ssid'],
              ssid: _selectedDropdown.ssid,
              pass: _passController.text,
              channel: _selectedDropdown.channel.toString(),
              meshSsid: _meshSsidController.text,
              meshPass: _meshPassController.text,
              username: _usernameController.text,
              nodename: _selectedRoom.name,
              mqttIp: _ipController.text,
              mqttPort: _portController.text,
            );
            List<SmartConfigData> smartConfigList =
                await SmartConfigData.loadFromDisk();
            if (smartConfigList != null) {
              smartConfigList
                  .removeWhere((element) => element.smartId == data.smartId);
            }
            smartConfigList.add(data);
            SmartConfigData.saveToDisk(smartConfigList);
            String uri =
                'http://192.168.4.1/get?ssid=${_selectedDropdown.ssid}&channel=${_selectedDropdown.channel}&pass=${_passController.text}&mesh_ssid=${_meshSsidController.text}&mesh_pass=${_meshPassController.text}&username=${_usernameController.text}&nodename=${_selectedRoom.name}&mqtt_ip=${_ipController.text}&mqtt_port=${_portController.text}&Submit=Submit';
            print('Form validated. Sending a web request now..');
            try {
              var resp = await http.get(Uri.encodeFull(uri));
              if (resp.body.contains('Ok')) {
                var msg = await SmartConfigData.loadFromDiskAsString();
                mqtt.publish(
                  topic: mqtt.getTopic(
                    username: TEST_USERNAME,
                    type: SmartMqttTopic.AppDeviceConfig,
                  ),
                  message: msg,
                  retain: true,
                );
                _showDialog(
                  context: context,
                  title: 'Device Configured Successfully',
                  iconData: Icons.done,
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .popAndPushNamed(route_addNewDevice);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                );
              } else
                _showFailureDialog();
            } catch (e) {
              _showFailureDialog();
              if (smartGlobalDebug) print(e);
            }
          } else
            helper.showSnackbarTextWithGlobalKey(
              _scaffoldKey,
              'Please Fill All Mandetory Fields!',
            );
        },
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Device Information",
                    style: _headingStyle,
                  ),
                  const SizedBox(height: 16),
                  _getTextRow(
                    context: context,
                    title: 'Device ID',
                    data: args['ssid'],
                  ),
                  const SizedBox(height: 8),
                  _getTextRow(
                    context: context,
                    title: 'Device Type',
                    data: args['info'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Network Setup",
                    style: _headingStyle,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder(
                    future: _getWifiListFromNode(),
                    initialData: _wifiList,
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        _dropdownList = _getDropdownList(
                          context: context,
                          wifiList: snapshot.data,
                        );
                        return SmartDropdown(
                          hint: 'Select WiFi Network',
                          prefixIcon: Icons.network_wifi,
                          itemList: _dropdownList,
                          selectedItem: _selectedDropdown,
                          onChanged: (SmartWifiConfig val) {
                            _selectedDropdown = val;
                          },
                        );
                      } else {
                        return SmartDropdown(
                          hint: 'Select WiFi Network',
                          prefixIcon: Icons.network_wifi,
                          itemList: null,
                          selectedItem: null,
                          onChanged: (SmartWifiConfig val) {},
                        );
                      }
                    },
                  ),
                  SmartTextFormField(
                    label: 'Password',
                    iconData: Icons.lock_outline,
                    obscure: true,
                    controller: _passController,
                    validator: (String val) {
                      if (_selectedDropdown != null) {
                        if (val.isEmpty &&
                            _selectedDropdown.ssid != '-- NOT IN LIST --') {
                          return 'Can\'t Connect to the WiFi Without Password!';
                        }
                      }
                      return null;
                    },
                  ),
                  SmartTextFormField(
                    label: 'S.M.A.R.T SSID',
                    hint: 'S.M.A.R.T\'s Own Network Name',
                    helperText:
                        'Hint: The SSID is case-sensitive must be exactly same for all S.M.A.R.T devices in your home!',
                    iconData: Icons.wifi_tethering,
                    controller: _meshSsidController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Can\'t Configure Without S.M.A.R.T SSID.';
                      }
                      return null;
                    },
                  ),
                  SmartTextFormField(
                    label: 'S.M.A.R.T Password',
                    hint: 'S.M.A.R.T\'s Own Network Password',
                    helperText:
                        'Hint: The Password is case-sensitive must be exactly same for all S.M.A.R.T devices in your home!',
                    iconData: Icons.vpn_key,
                    controller: _meshPassController,
                    obscure: true,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Can\'t Configure Without Password!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Device Setup",
                    style: _headingStyle,
                  ),
                  SmartTextFormField(
                    label: 'Username',
                    hint: 'Registered Username',
                    helperText:
                        'Hint: You can share this with your family or roommates.',
                    iconData: Icons.account_circle,
                    controller: _usernameController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Can\'t Configure Without Your Username.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder(
                    future: _getSmartRoomData(),
                    initialData: _roomList,
                    builder:
                        (ctx, AsyncSnapshot<List<SmartRoomData>> snapshot) {
                      _dropdownRoomList = _getRoomDropdownList(
                        roomList: snapshot.data,
                        context: context,
                      );
                      return SmartDropdown(
                        hint: 'Select Device Location',
                        prefixIcon: Icons.room,
                        itemList: _dropdownRoomList,
                        selectedItem: _selectedRoom,
                        onChanged: (SmartRoomData val) {
                          if (val.name == 'Add New Room') {
                            _showAddRoomDialog(context: context);
                          }
                          setState(() => _selectedRoom = val);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Connection Setup",
                    style: _headingStyle,
                  ),
                  SmartTextFormField(
                    label: 'IP Address',
                    hint: 'Where is the S.M.A.R.T Cloud?',
                    iconData: Icons.cloud_circle,
                    keyboardType: TextInputType.url,
                    controller: _ipController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Can\'t Configure Without IP Address.';
                      }
                      return null;
                    },
                  ),
                  SmartTextFormField(
                    label: 'Port',
                    hint: 'On Which Port?',
                    iconData: Icons.settings_input_composite,
                    keyboardType: TextInputType.number,
                    controller: _portController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Can\'t Configure Without Port Number.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFailureDialog() {
    _showDialog(
      context: context,
      title: 'Device Configuration Failed',
      iconData: Icons.error,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'RETRY',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  void _showAddRoomDialog({@required BuildContext context}) {
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
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 2,
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            "Add A New Room",
            textAlign: TextAlign.center,
          ),
          titleTextStyle: Theme.of(context).textTheme.headline1,
          content: TextFormField(
            cursorColor: Theme.of(context).primaryColorDark,
            textInputAction: TextInputAction.done,
            style: Theme.of(context).textTheme.headline3,
            controller: _addRoomController,
            validator: (msg) {
              if (msg == null) {
                return 'Can\'t be left blank!';
              }
              return null;
            },
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Name',
              hintText: 'E.g. Bedroom',
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
                icon: _addRoomIcon,
                onPressed: () async {
                  IconData iconData = await FlutterIconPicker.showIconPicker(
                    context,
                    iconPackMode: IconPack.material,
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
                  _addRoomIcon = Icon(
                    iconData != null ? iconData : Icons.touch_app,
                    color: Theme.of(context).primaryColorDark,
                    size: 32,
                  );
                  setState(() {
                    Navigator.of(context).pop();
                    _showAddRoomDialog(context: context);
                  });
                },
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectedRoom = null;
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
                _addNewRoom(
                  SmartRoomData(
                    name: _addRoomController.text,
                    icon: _addRoomIcon.icon,
                  ),
                );
                _selectedRoom = null;
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

  Future<void> _addNewRoom(SmartRoomData room) async {
    List<SmartRoomData> roomList = await SmartRoomData.loadFromDisk();
    if (roomList != null) {
      roomList.removeWhere((e) => e.name == room.name);
    }
    roomList.add(room);
    SmartRoomData.saveToDisk(roomList);
    final String msg = await SmartRoomData.loadFromDiskAsString();
    mqtt.publish(
      topic: mqtt.getTopic(
        username: TEST_USERNAME,
        type: SmartMqttTopic.AppRoomList,
      ),
      message: msg,
      retain: true,
    );
  }

  void _showDialog({
    @required BuildContext context,
    String title,
    IconData iconData,
    List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 2,
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Icon(
            iconData,
            size: 72,
            color: Theme.of(context).accentColor,
          ),
          content: Text(
            title,
            textAlign: TextAlign.center,
          ),
          contentTextStyle: Theme.of(context).textTheme.headline1,
          actions: actions,
        );
      },
    );
  }

  // Fetch SmartRoomData as a list saved on shared
  Future<List<SmartRoomData>> _getSmartRoomData() async {
    List<SmartRoomData> list = await SmartRoomData.loadFromDisk();
    if (list == null) list = [];
    list.add(
      SmartRoomData(
        name: "Add New Room",
        icon: Icons.add_circle_outline,
      ),
    );
    return list;
  }

  // Send a GET request to Smart Node to get WiFi scan list
  Future<List<SmartWifiConfig>> _getWifiListFromNode() async {
    // This flag only executes GET request once & "Never Clears" the _wifiList
    // Clearing _wifiList gives dropdown error as _selectedDropdown not founds in _dropdownList
    if (!_onceExecuted) {
      final value = await fetchWebpage();
      _wifiListRaw.clear();
      _wifiList.clear();
      _wifiListRaw = jsonDecode(value);
      _wifiListRaw.forEach(
        (element) {
          _wifiList.add(
            SmartWifiConfig(
              ssid: element[0],
              rssi: int.parse(element[1]),
              channel: int.parse(element[2]),
            ),
          );
        },
      );
      _wifiList.add(
        SmartWifiConfig(
          ssid: "-- NOT IN LIST --",
          rssi: 50,
          channel: 1,
        ),
      );
      _onceExecuted = true;
    }
    return _wifiList;
  }

  // Build a list of widgets for 'Select WiFi' Dropdown
  List<DropdownMenuItem<SmartWifiConfig>> _getDropdownList(
      {BuildContext context, List<SmartWifiConfig> wifiList}) {
    List<DropdownMenuItem<SmartWifiConfig>> list = List();
    wifiList.forEach(
      (element) {
        list.add(
          DropdownMenuItem(
            child: Text(
              element.ssid,
              style: Theme.of(context).textTheme.headline3,
            ),
            value: element,
          ),
        );
      },
    );
    return list;
  }

  // Build a list of widgets for 'Select Room' Dropdown
  List<DropdownMenuItem<SmartRoomData>> _getRoomDropdownList(
      {BuildContext context, List<SmartRoomData> roomList}) {
    List<DropdownMenuItem<SmartRoomData>> list = List();
    roomList.forEach(
      (element) {
        list.add(
          DropdownMenuItem(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    element.icon,
                    color: Theme.of(context).textTheme.headline3.color,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    element.name,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ],
            ),
            value: element,
          ),
        );
      },
    );
    return list;
  }

  // Get text row to show info like SmartID and details at the top of page
  Row _getTextRow({
    @required BuildContext context,
    @required String title,
    @required String data,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            "$title :",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            data,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ],
    );
  }
}
