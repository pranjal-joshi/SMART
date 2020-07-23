import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import '../models/SmartConstants.dart';
import '../models/SwitchboardRow.dart';

class SwitchboardTile extends StatefulWidget {
  final SwitchboardRow row;

  SwitchboardTile({
    @required this.row,
  });

  @override
  _SwitchboardTileState createState() => _SwitchboardTileState();
}

class _SwitchboardTileState extends State<SwitchboardTile> {
  bool _switchState;
  Icon _icon;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _switchState = widget.row.deviceState;
    _icon = Icon(
      widget.row.deviceIcon,
      color: color_accent,
      size: 32,
    );
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
        // leading: Icon(
        //   widget.row.deviceIcon,
        //   color: Theme.of(context).primaryColorDark,
        //   size: 32,
        // ),
        leading: _icon,
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
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: _icon,
                splashColor: helper.getSplashColor,
                padding: EdgeInsets.symmetric(horizontal: 16),
                onPressed: () async {
                  IconData iconData = await FlutterIconPicker.showIconPicker(
                      context,
                      iconPackMode: IconPack.material);
                  if (iconData != null) {
                    _icon = Icon(
                      iconData,
                      color: Theme.of(context).primaryColorDark,
                      size: 32,
                    );
                    setState(() {});
                  }
                },
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  style: Theme.of(context).textTheme.headline3,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.words,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Device Name",
                    contentPadding: EdgeInsets.all(4),
                  ),
                  onSubmitted: (str){
                    helper.showSnackbarText('Submited: $str');
                  },
                ),
              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          Text("Expanded 2"),
          Text("Expanded 3"),
        ],
      ),
    );
  }
}
