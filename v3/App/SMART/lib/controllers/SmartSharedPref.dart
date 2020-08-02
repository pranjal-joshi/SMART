import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartSharedPreference {
  
  SharedPreferences _sp;

  SmartSharedPreference();

  Future<bool> saveString({@required String key, @required String data}) async {
    _sp = await SharedPreferences.getInstance();
    return await _sp.setString(key, data);
  }

  Future<bool> saveStringList({@required String key, @required List<String> data}) async {
    _sp = await SharedPreferences.getInstance();
    return await _sp.setStringList(key, data);
  }

  Future<String> loadString({@required String key}) async {
     _sp = await SharedPreferences.getInstance();
     return _sp.getString(key);
  }

  Future<List<String>> loadStringList({@required String key}) async {
     _sp = await SharedPreferences.getInstance();
     return _sp.getStringList(key);
  }

  Future<void> loadDebug({@required String key}) async {
    _sp = await SharedPreferences.getInstance();
    print('[SmartSharedPreference] loadDebug (key: $key) -> ${_sp.getStringList(key)}');
  }

}