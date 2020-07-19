import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/SmartConstants.dart';

class ProfileCard extends StatelessWidget {
  final SmartHelper helper;
  final String profileName;
  final IconData profileIcon;

  ProfileCard({
    @required this.helper,
    @required this.profileName,
    @required this.profileIcon,
  });

  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          side: helper.isDarkModeActive
              ? BorderSide(
                  color: helper.getCardBorderColor,
                  width: 2,
                )
              : BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
          borderRadius: BorderRadius.circular(helper.screenWidth * 0.08)),
      elevation: 6,
      child: Container(
        height: double.infinity,
        width: helper.screenWidth / 3,
        color: helper.isDarkModeActive
            ? Colors.grey[900]
            : helper.getCardBackgroudColor,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  child: IconButton(
                    icon: Icon(
                      profileIcon,
                      size: helper.screenWidth * 0.20,
                      color: helper.getTextHeadingColor,
                    ),
                    onPressed: () => print('Pressed $profileName'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Text(
                    profileName,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: helper.getTextBodyColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
