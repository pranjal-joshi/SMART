import 'package:flutter/foundation.dart';

import '../models/JsonModel.dart';
import '../models/SmartConstants.dart';
import '../widgets/SmartRoomIndicator.dart';

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
          if (!_roomStateMap.containsKey(_statePacket.nodeName)) {
            _roomStateMap.putIfAbsent(
              _statePacket.nodeName,
              () => {
                _statePacket.smartId: _statePacket.dataList,
              },
            );
          } else {
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
            );
          }
          _roomPowerIndicatorMap = {};
          _roomStateMap.forEach((key, value) {
            value.forEach((k, v) {
              if (v.any((element) => element == 1)) {
                if (!_roomPowerIndicatorMap.containsKey(key))
                  _roomPowerIndicatorMap.putIfAbsent(
                    key,
                    () => SmartRoomIndicatorState.powerOn,
                  );
                else
                  _roomPowerIndicatorMap.update(
                    key,
                    (value) => SmartRoomIndicatorState.powerOn,
                  );
              } else {
                if (!_roomPowerIndicatorMap.containsKey(key))
                  _roomPowerIndicatorMap.putIfAbsent(
                    key,
                    () => SmartRoomIndicatorState.powerOff,
                  );
                else
                  _roomPowerIndicatorMap.update(key, (value) {
                    if (value == SmartRoomIndicatorState.powerOn)
                      return SmartRoomIndicatorState.powerOn;
                    return SmartRoomIndicatorState.powerOff;
                  });
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
}
