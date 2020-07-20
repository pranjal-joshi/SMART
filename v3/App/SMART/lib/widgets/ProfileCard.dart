import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/SmartConstants.dart';
import '../models/SmartPopupMenu.dart';

class ProfileCard extends StatelessWidget {
  final SmartHelper helper;
  final String profileName;
  final IconData profileIcon;

  ProfileCard({
    @required this.helper,
    @required this.profileName,
    @required this.profileIcon,
  });

  final List<SmartPopupMenu> menuList = [
    SmartPopupMenu(title: 'Edit', icon: Icons.edit),
    SmartPopupMenu(title: 'Delete', icon: Icons.delete)
  ];

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: helper.profileCardGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 16, 0, 0),
                        child: Text(
                          profileName,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.start,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: helper.getTextBodyColor,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 18, 12, 0),
                        child: PopupMenuButton(
                          elevation: 4,
                          color: helper.getCardBackgroudColor,
                          onCanceled: () => print("Popup Dismissed!"),
                          onSelected: (val) => print("Selected: ${val.title}"),
                          itemBuilder: (context) {
                            return menuList.map((SmartPopupMenu choice) {
                              return PopupMenuItem(
                                value: choice,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      choice.title,
                                    ),
                                    Icon(choice.icon),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(
                      profileIcon,
                      size: helper.screenWidth * 0.16,
                      color: helper.getTextBodyColor.withOpacity(0.8),
                    ),
                    onPressed: () => print('Pressed $profileName'),
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
