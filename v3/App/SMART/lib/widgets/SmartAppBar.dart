import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/SmartConstants.dart';

class SmartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  SmartAppBar({
    @required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          //color: helper.getAppBarTextColor,
          color: Theme.of(context).textTheme.headline1.color,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      // backgroundColor: helper.getAppBarBackgroundColor,
      leading: showBackButton(context),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryColorDark,
          ),
        )
      ],
    );
  }

  Widget showBackButton(BuildContext context) {
    if (ModalRoute.of(context).canPop) {
      return BackButton(
        color: Theme.of(context).primaryColorDark,
      );
    } else {
      return null;
    }
  }
}
