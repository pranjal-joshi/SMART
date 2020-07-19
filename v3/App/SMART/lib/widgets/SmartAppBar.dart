import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/SmartConstants.dart';

class SmartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final SmartHelper helper;

  SmartAppBar({
    @required this.title,
    @required this.helper,
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
          fontSize: 24,
          color: helper.getAppBarTextColor,
        ),
      ),
      backgroundColor: helper.getAppBarBackgroundColor,
      elevation: 8,
      leading: showBackButton(context),
    );
  }

  Widget showBackButton(BuildContext context) {
    if (ModalRoute.of(context).canPop) {
      return BackButton(
        color: helper.getAppBarTextColor,
      );
    } else {
      return null;
    }
  }
}
