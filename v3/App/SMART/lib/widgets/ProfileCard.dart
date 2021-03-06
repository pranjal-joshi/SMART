import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_icons/line_icons.dart';

import '../helpers/SmartHelper.dart';
import '../models/SmartPopupMenu.dart';
import '../widgets/SmartCard.dart';

class ProfileCard extends StatelessWidget {
  final String profileName;
  final IconData profileIcon;

  ProfileCard({
    @required this.profileName,
    @required this.profileIcon,
  });

  final List<SmartPopupMenu> menuList = [
    SmartPopupMenu(title: 'Edit', icon: LineIcons.edit),
    SmartPopupMenu(title: 'Delete', icon: LineIcons.trash_solid)
  ];

  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return SmartCard(
      helper: helper,
      cornerRadius: helper.screenWidth * 0.08,
      blurRadius: SmartCardBlurRadius.Subtle,
      elevation: 6,
      shadowColor: Colors.transparent,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 4, 0, 0),
                        child: Text(
                          profileName,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.start,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: PopupMenuButton(
                          icon: Icon(Icons.more_vert, color: Colors.black,),
                          onCanceled: () => print("Popup Dismissed!"),
                          onSelected: (val) => helper.showSnackbarText("Selected: ${val.title}"),
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
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                    Icon(
                                      choice.icon,
                                      color: helper.isDarkModeActive
                                          ? color_white_dark
                                          : Colors.black,
                                    ),
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
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(
                      profileIcon,
                      size: helper.screenWidth * 0.16,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    onPressed: () {
                      helper.showSnackbarText('$profileName Selected!');
                    },
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
