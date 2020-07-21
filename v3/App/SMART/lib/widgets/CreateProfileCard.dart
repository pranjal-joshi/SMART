import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/SmartConstants.dart';

class CreateProfileCard extends StatelessWidget {
  CreateProfileCard();

  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(helper.screenWidth * 0.08),
      ),
      elevation: 6,
      child: Container(
        height: double.infinity,
        width: helper.screenWidth / 2.3,
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
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                        child: Text(
                          "Create New\nProfile",
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
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: helper.screenWidth * 0.16,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    onPressed: () {
                      helper.showSnackbarText('Create New Profile');
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
