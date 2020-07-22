import 'package:SMART/models/SmartConstants.dart';
import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';
import '../models/SwitchboardRow.dart';

class SwitchboardTile extends StatefulWidget {
  final SwitchboardRow row;
  final bool isExpanded;
  final Function onExpansionChangedMethod;
  final int index;

  SwitchboardTile({
    @required this.row,
    @required this.isExpanded,
    @required this.onExpansionChangedMethod,
    @required this.index,
  });

  @override
  _SwitchboardTileState createState() => _SwitchboardTileState();
}

class _SwitchboardTileState extends State<SwitchboardTile> {
  bool _switchState;

  @override
  void initState() {
    super.initState();
    _switchState = widget.row.deviceState;
  }

  @override
  void dispose() {
    _switchState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: ExpansionTile(
        leading: Icon(
          widget.row.deviceIcon,
          color: Theme.of(context).primaryColorDark,
          size: 32,
        ),
        title: Text(
          widget.row.deviceName,
          style: Theme.of(context).textTheme.headline3,
        ),
        subtitle: Text(
          widget.row.deviceDescription,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        trailing: Switch.adaptive(
          value: _switchState,
          activeColor: Colors.blue[400],
          onChanged: (state) {
            helper.showSnackbarText('Switch State toggled to $state');
            setState(() => _switchState = state);
          },
        ),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
        initiallyExpanded: widget.isExpanded,
        key: GlobalKey(),
        onExpansionChanged: (exp) =>
            widget.onExpansionChangedMethod(exp, widget.index),
        children: <Widget>[
          Text("Expanded 1"),
          Text("Expanded 2"),
          Text("Expanded 3"),
        ],
      ),
    );
  }
}
