import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

import '../controllers/SmartSharedPref.dart';
import '../models/SmartConstants.dart';
import '../models/SmartWifiConfig.dart';
import '../widgets/SmartAppBar.dart';

class ConfigureDevice extends StatefulWidget {
  @override
  _ConfigureDeviceState createState() => _ConfigureDeviceState();
}

class _ConfigureDeviceState extends State<ConfigureDevice> {
  SmartHelper helper;
  SmartSharedPreference sp = SmartSharedPreference();
  var connectivitySubscription;
  var _wifiListRaw = List();
  List<SmartWifiConfig> _wifiList = List();
  List<DropdownMenuItem<SmartWifiConfig>> _dropdownList = List();
  SmartWifiConfig _selectedDropdown;

  final _passController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nodenameController = TextEditingController();
  final _ipController = TextEditingController(text: '35.222.110.118');
  final _portController = TextEditingController(text: '1883');
  final _meshSsidController = TextEditingController();
  final _meshPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final SmartAppBar _appBar = SmartAppBar(
    title: 'Configure Device',
    showActions: false,
  );

  @override
  void initState() {
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      print(result);
      if (result == ConnectivityResult.wifi) {
        _getWifiListFromNode();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    _passController.dispose();
    _usernameController.dispose();
    _nodenameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _meshSsidController.dispose();
    _meshPassController.dispose();
    super.dispose();
  }

  Future<String> fetchWebpage() async {
    var response = await http.get('http://192.168.4.1');
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

    return Scaffold(
      appBar: _appBar,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.save,
          size: 32,
        ),
        onPressed: () async {
          if (_formKey.currentState.validate() && _selectedDropdown != null) {
            SmartConfigData data = SmartConfigData(
              smartId: args['ssid'],
              ssid: _selectedDropdown.ssid,
              pass: _passController.text,
              channel: _selectedDropdown.channel.toString(),
              meshSsid: _meshSsidController.text,
              meshPass: _meshPassController.text,
              username: _usernameController.text,
              nodename: _nodenameController.text,
              mqttIp: _ipController.text,
              mqttPort: _portController.text,
            );
            List<String> smartConfigDataRaw =
                await sp.loadStringList(key: SP_SmartConfigData);
            List<SmartConfigData> smartConfigList = List();
            smartConfigDataRaw.forEach(
              (element) {
                smartConfigList.add(SmartConfigData.fromJsonString(element));
              },
            );
            //TODO: Save/update the config in SharedPrefs
            String uri =
                'http://192.168.4.1/get?ssid=${_selectedDropdown.ssid}&channel=${_selectedDropdown.channel}&pass=${_passController.text}&mesh_ssid=${_meshSsidController.text}&mesh_pass=${_meshPassController.text}&username=${_usernameController.text}&nodename=${_nodenameController.text}&mqtt_ip=${_ipController.text}&mqtt_port=${_portController.text}&Submit=Submit';
            print('Form validated. Sending a web request now..');
            var resp = await http.get(Uri.encodeFull(uri));
            print(resp.body);
            //TODO: check response to show ok/error
          }
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
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.network_wifi,
                        color: Theme.of(context).primaryColorDark,
                        size: 32,
                      ),
                      Container(
                        width: helper.screenWidth - 32 - 48,
                        margin: EdgeInsets.only(left: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            width: 2,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: Icon(Icons.arrow_drop_down),
                            items: _dropdownList,
                            elevation: 2,
                            iconEnabledColor:
                                Theme.of(context).primaryColorDark,
                            hint: Text(
                              "Select Your WiFi Network",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                            value: _selectedDropdown,
                            onChanged: (SmartWifiConfig val) {
                              setState(() => _selectedDropdown = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _getTextFormField(
                    context: context,
                    label: 'Password',
                    iconData: Icons.lock_outline,
                    obscure: true,
                    controller: _passController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Can\'t Connect to the WiFi Without Password!';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _getTextFormField(
                    context: context,
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
                    },
                  ),
                  const SizedBox(height: 16),
                  _getTextFormField(
                    context: context,
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
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Device Setup",
                    style: _headingStyle,
                  ),
                  const SizedBox(height: 16),
                  _getTextFormField(
                    context: context,
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
                    },
                  ),
                  const SizedBox(height: 16),
                  _getTextFormField(
                    context: context,
                    label: 'Device Name',
                    hint: 'Like "Living Room" or "Garden"',
                    iconData: Icons.memory,
                    controller: _nodenameController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Device name is required!';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Connection Setup",
                    style: _headingStyle,
                  ),
                  const SizedBox(height: 16),
                  _getTextFormField(
                    context: context,
                    label: 'IP Address',
                    hint: 'Where is the S.M.A.R.T Cloud?',
                    iconData: Icons.cloud_circle,
                    keyboardType: TextInputType.url,
                    controller: _ipController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Can\'t Configure Without IP Address.';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _getTextFormField(
                    context: context,
                    label: 'Port',
                    hint: 'On Which Port?',
                    iconData: Icons.settings_input_composite,
                    keyboardType: TextInputType.number,
                    controller: _portController,
                    validator: (String val) {
                      if (val.isEmpty) {
                        return 'Can\'t Configure Without Port Number.';
                      }
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

  void _getWifiListFromNode() {
    fetchWebpage().then(
      (value) {
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
        _dropdownList = _getDropdownList(
          context: context,
          wifiList: _wifiList,
        );
        setState(() {});
      },
    );
  }

  List<DropdownMenuItem<SmartWifiConfig>> _getDropdownList(
      {BuildContext context, List<SmartWifiConfig> wifiList}) {
    List<DropdownMenuItem<SmartWifiConfig>> list = List();
    wifiList.forEach(
      (element) {
        list.add(
          DropdownMenuItem(
            child: Text(
              element.ssid,
              style: Theme.of(context).textTheme.headline2,
            ),
            value: element,
          ),
        );
      },
    );
    return list;
  }

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

  TextFormField _getTextFormField({
    @required BuildContext context,
    String label,
    String hint,
    String helperText,
    String initialVal,
    IconData iconData,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Function validator,
    TextEditingController controller,
  }) {
    final SmartHelper helper = SmartHelper(context: context);
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
    return TextFormField(
      initialValue: initialVal != null ? initialVal : null,
      cursorColor: Theme.of(context).primaryColorDark,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.done,
      style: Theme.of(context).textTheme.headline3,
      obscureText: obscure,
      validator: (str) => validator != null ? validator(str) : null,
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        hintText: hint,
        helperText: helperText,
        helperMaxLines: 4,
        helperStyle: Theme.of(context).textTheme.subtitle1,
        hintMaxLines: 1,
        hintStyle: TextStyle(
          color: Theme.of(context).textTheme.subtitle1.color,
          fontSize: Theme.of(context).textTheme.headline3.fontSize,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        icon: Icon(
          iconData,
          color: Theme.of(context).primaryColorDark,
          size: 32,
        ),
        border: outlineInputBorder_2,
        enabledBorder: outlineInputBorder_2,
        focusedBorder: outlineInputBorder_3,
        errorBorder: outlineInputBorder_2,
        errorMaxLines: 2,
        errorStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: helper.isDarkModeActive ? Colors.blue[400] : Colors.blue[700],
        ),
      ),
    );
  }
}
