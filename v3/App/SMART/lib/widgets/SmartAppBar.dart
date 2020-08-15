import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class SmartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showActions;
  final bool elivated;

  SmartAppBar({
    @required this.title,
    this.showActions = false,
    this.elivated = false,
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
          color: Theme.of(context).primaryColorDark,
        ),
      ),
      elevation: elivated ? 2 : 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor: helper.getAppBarBackgroundColor,
      leading: showBackButton(context),
      actions: showActions
          ? <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).primaryColorDark,
                ),
              )
            ]
          : null,
    );
  }

  Widget showBackButton(BuildContext context) {
    if (ModalRoute.of(context).canPop) {
      return IconButton(
        icon: Icon(
          Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          color: Theme.of(context).primaryColorDark,
          size: 32,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      return null;
    }
  }
}
