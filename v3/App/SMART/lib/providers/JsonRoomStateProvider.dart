import 'package:flutter/foundation.dart';

import '../models/JsonModel.dart';
import '../helpers/SmartHelper.dart';
import '../widgets/SmartRoomIndicator.dart';

// Provider class - Manage States of all nodes by their parent room
// Provides additional method for BLOC
// Call 'addState' method in MQTT listener
/*
Example Data Container
{
  'room a': {
    'smart_1': [1,0,1,0],
    'smart_2': [0,1],
  }
  'room b': {
    'smart_3': [1]
  }
}
*/

class JsonRoomStateProvider with ChangeNotifier {
  final bool debug;
  Map<String, Map<String, List<int>>> _roomStateMap = {};
  Map<String, SmartRoomIndicatorState> _roomPowerIndicatorMap = {};
  JsonNodeToAppSwitchState _statePacket;

  JsonRoomStateProvider({@required this.debug});

  Map<String, Map<String, List<int>>> get roomStateMap {
    return {..._roomStateMap};
  }

  Map<String, SmartRoomIndicatorState> get roomPowerIndicatorMap {
    return {..._roomPowerIndicatorMap};
  }

  void addState(String rawJson, var decodedJson) {
    try {
      if (decodedJson is Map) {
        if (decodedJson[JSON_TYPE] == JSON_TYPE_STATE) {
          _statePacket = JsonNodeToAppSwitchState.fromJsonString(rawJson);
          _roomStateMap.update(
            _statePacket.nodeName,
            (value) {
              value.update(
                _statePacket.smartId,
                (value) => _statePacket.dataList,
                ifAbsent: () => value.values.toList()[0],
              );
              return value;
            },
            ifAbsent: () => _roomStateMap.putIfAbsent(
              _statePacket.nodeName,
              () => {
                _statePacket.smartId: _statePacket.dataList,
              },
            ),
          );
          _roomPowerIndicatorMap = {};
          _roomStateMap.forEach((key, value) {
            value.forEach((k, v) {
              if (v.any((element) => element == 1)) {
                _roomPowerIndicatorMap.update(
                  key,
                  (value) => SmartRoomIndicatorState.powerOn,
                  ifAbsent: () => _roomPowerIndicatorMap.putIfAbsent(
                    key,
                    () => SmartRoomIndicatorState.powerOn,
                  ),
                );
              } else {
                _roomPowerIndicatorMap.update(
                  key,
                  (value) {
                    if (value == SmartRoomIndicatorState.powerOn)
                      return SmartRoomIndicatorState.powerOn;
                    return SmartRoomIndicatorState.powerOff;
                  },
                  ifAbsent: () => _roomPowerIndicatorMap.putIfAbsent(
                    key,
                    () => SmartRoomIndicatorState.powerOff,
                  ),
                );
              }
            });
          });
          notifyListeners();
        }
      }
    } catch (e) {
      if (debug)
        print('[JsonRoomStateProvider] -> EXCEPTION: $e\nJSON: $rawJson');
    }
  }

  // get list of state [true(1),false(0),...] by SmartID
  List<bool> getStateBySmartId(String smartId) {
    List<bool> list = [];
    try {
      _roomStateMap.forEach((key, value) {
        if (value.containsKey(smartId)) {
          value[smartId]
              .forEach((e) => e > 0 ? list.add(true) : list.add(false));
        }
      });
    } catch (e) {
      if (debug)
        print('[JsonRoomStateProvider] -> getStateBySmartId EXCEPTION: $e');
    }
    return list;
  }

  List<int> getPublishableStateBySmartId(String smartId) {
    List<int> list = [];
    try {
      _roomStateMap.forEach((key, value) {
        if (value.containsKey(smartId)) {
          list = value[smartId];
          return;
        }
      });
    } catch (e) {
      if (debug)
        print(
            '[JsonRoomStateProvider] -> getPublishableStateBySmartId EXCEPTION: $e');
    }
    return list;
  }
}
