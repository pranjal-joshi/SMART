import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:line_icons/line_icons.dart';

import '../providers/JsonRoomStateProvider.dart';

import '../helpers/SmartHelper.dart';
import '../models/JsonModel.dart';
import '../models/SmartDeviceData.dart';

// Provider class - Manage Label of all nodes by their parent room
// Provides additional method for BLOC
// Call 'addLabel' method in MQTT listener
// This needs JsonRoomStateProvider through ProxyProviderChangeListener!
/*
Example Data Container
{
  'room a': {
    'smart_1': ['name1','name2','name3','name4'],
    'smart_2': ['name1','name2'],
  }
  'room b': {
    'smart_3': ['name1']
  }
}
*/
class JsonNodeLabelProvider with ChangeNotifier {
  final bool debug;
  Map<String, Map<String, List<String>>> _roomLabelMap = {};
  JsonNodeLabel _nodeLabel;
  JsonRoomStateProvider _roomStateProvider;

  JsonNodeLabelProvider({
    @required this.debug,
  });

  Map<String, Map<String, List<String>>> get roomLabelMap {
    return {..._roomLabelMap};
  }

  JsonRoomStateProvider get roomStateProvider => _roomStateProvider;

  set roomStateProvider(JsonRoomStateProvider jsonRoomStateProvider) {
    _roomStateProvider = jsonRoomStateProvider;
    notifyListeners();
  }

  void addLabel(String rawJson, var decodedJson) {
    try {
      if (decodedJson is Map) {
        if (decodedJson[JSON_TYPE] == JSON_TYPE_LABEL) {
          _nodeLabel = JsonNodeLabel.fromJsonString(rawJson);
          _roomLabelMap.update(
            _nodeLabel.nodeName,
            (value) {
              value.update(
                _nodeLabel.smartId,
                (value) => _nodeLabel.dataList,
                ifAbsent: () => _nodeLabel.dataList,
              );
              return value;
            },
            ifAbsent: () => _roomLabelMap.putIfAbsent(
              _nodeLabel.nodeName,
              () => {
                _nodeLabel.smartId: _nodeLabel.dataList,
              },
            ),
          );
          notifyListeners();
        }
      }
    } catch (e) {
      if (debug)
        print('[JsonNodeLabelProvider] -> EXCEPTION: $e\nJSON: $rawJson');
    }
  }

  Map<String, List<String>> findLabelsByRoomId(String nodeName) {
    if (_roomLabelMap.containsKey(nodeName))
      return {..._roomLabelMap[nodeName]};
    return {};
  }

  List<String> findLabelsBySmartId(String smartId) {
    List<String> list = [];
    _roomLabelMap.forEach((key, value) {
      if (value.containsKey(smartId)) {
        list = value[smartId];
        return;
      }
    });
    return list;
  }

  List<SmartDeviceData> getDeviceDataListByRoomId(String nodeName) {
    List<SmartDeviceData> list = [];
    if (_roomLabelMap.containsKey(nodeName)) {
      _roomLabelMap[nodeName].forEach((key, value) {
        int valueIndex = 0;
        value.forEach((e) {
          list.add(
            SmartDeviceData(
              smartId: key,
              deviceName: e,
              id: valueIndex,
              iconData: LineIcons.atom_solid,
              switchState: _roomStateProvider.getStateBySmartId(key)[valueIndex],
            ),
          );
          valueIndex++;
        });
      });
    }
    return list;
  }
}
