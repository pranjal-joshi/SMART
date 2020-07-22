import 'package:SMART/models/SmartConstants.dart';
import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';
import '../models/SwitchboardRow.dart';

class SwitchboardTile extends StatefulWidget {
  final SwitchboardRow row;

  SwitchboardTile({@required this.row});

  @override
  _SwitchboardTileState createState() => _SwitchboardTileState();
}

class _SwitchboardTileState extends State<SwitchboardTile> {

bool _switchState = true;

  @override
  Widget build(BuildContext context) {

    SmartHelper helper = SmartHelper(context: context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: ListTile(
        onLongPress: () => helper
            .showSnackbarText("Long Tap to Edit Switchboard Tile!"),
        leading: Icon(
          widget.row.deviceIcon,
          color: Theme.of(context).primaryColorDark,
          size: 28,
        ),
        title: Text(
          widget.row.deviceName,
          style: Theme.of(context).textTheme.headline3,
        ),
        trailing: Switch.adaptive(
            value: _switchState,
            activeColor: Colors.blue[400],
            onChanged: (state) {
              helper.showSnackbarText('Switch State toggled to $state');
              setState(() => _switchState = state);
            }),
      ),
    );
  }
}
