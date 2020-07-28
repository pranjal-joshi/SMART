import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/SmartConstants.dart';

class SmartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showActions;

  SmartAppBar({
    @required this.title,
    @required this.showActions,
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
          fontSize: 32,
          //color: helper.getAppBarTextColor,
          color: Theme.of(context).textTheme.headline1.color,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      // backgroundColor: helper.getAppBarBackgroundColor,
      leading: showBackButton(context),
      actions: showActions ? <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryColorDark,
          ),
        )
      ] : null,
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
