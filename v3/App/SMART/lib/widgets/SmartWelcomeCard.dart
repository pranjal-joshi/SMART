import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';

class SmartWelcomeCard extends StatelessWidget {
  final SmartHelper helper;
  final BoxConstraints constraints;
  final String title;
  final String subtitle;
  final Function onActionTap;

  SmartWelcomeCard({
    @required this.helper,
    @required this.constraints,
    @required this.title,
    this.subtitle,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 16,
          color: helper.isDarkModeActive ? Colors.grey[850] : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: constraints.maxHeight / 30,
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.settings_remote,
                color: Theme.of(context).accentColor,
                size: 42,
              ),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline1,
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle,
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                : null,
            trailing: IconButton(
              icon: Icon(
                Icons.settings,
                size: 32,
                color: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .color
                    .withOpacity(0.8),
              ),
              onPressed: onActionTap != null ? onActionTap : null,
            ),
          ),
        ),
      ),
    );
  }
}