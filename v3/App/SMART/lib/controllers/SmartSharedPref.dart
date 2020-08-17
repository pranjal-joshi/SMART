import 'dart:convert';

import 'package:SMART/models/SmartConstants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartSharedPreference {
  SmartSharedPreference();

  Future<bool> saveString({@required String key, @required String data}) async {
    final _sp = await SharedPreferences.getInstance();
    return await _sp.setString(key, data);
  }

  Future<bool> saveStringList(
      {@required String key, @required List<String> data}) async {
    final _sp = await SharedPreferences.getInstance();
    return await _sp.setStringList(key, data);
  }

  Future<String> loadString({@required String key}) async {
    final _sp = await SharedPreferences.getInstance();
    return _sp.getString(key);
  }

  Future<List<String>> loadStringList({@required String key}) async {
    final _sp = await SharedPreferences.getInstance();
    return _sp.getStringList(key);
  }

  Future<bool> delete({@required String key}) async {
    final _sp = await SharedPreferences.getInstance();
    return _sp.remove(key);
  }

  Future<void> loadDebug({@required String key}) async {
    final _sp = await SharedPreferences.getInstance();
    print(
        '[SmartSharedPreference] loadDebug (key: $key) -> ${_sp.getStringList(key)}');
  }

  Future<void> saveLoginState(bool state) async {
    final _sp = await SharedPreferences.getInstance();
    _sp.setBool(SP_LoginState, state);
  }

  Future<bool> loadLoginState() async {
    final _sp = await SharedPreferences.getInstance();
    return _sp.getBool(SP_LoginState);
  }

  Future<void> saveLoginCredentials(List<String> unamePass) async {
    final _sp = await SharedPreferences.getInstance();
    List<String> secured =
        unamePass.map((e) => base64Encode(utf8.encode(e))).toList();
    _sp.setStringList(SP_LoginCredentials, secured);
  }

  Future<List<String>> loadLoginCredentials() async {
    final _sp = await SharedPreferences.getInstance();
    List<String> secured = _sp.getStringList(SP_LoginCredentials);
    if(secured != null)
      return secured.map((e) => utf8.decode(base64Decode(e))).toList();
    return [];
  }
}
