import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dotted_border/dotted_border.dart';

import '../helpers/SmartHelper.dart';

class CreateProfileCard extends StatelessWidget {
  CreateProfileCard();

  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);
    final double radius = helper.screenWidth * 0.08;

    return DottedBorder(
      borderType: BorderType.RRect,
      color: Theme.of(context).textTheme.bodyText2.color,
      radius: Radius.circular(radius),
      strokeWidth: 2,
      dashPattern: const [8,8],
      padding: const EdgeInsets.all(0),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          height: double.infinity,
          width: helper.screenWidth / 2.3,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 4, 0, 0),
                          child: Text(
                            "Create Profile",
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.start,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.bodyText2.color,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: helper.screenWidth * 0.16,
                        color: Theme.of(context).textTheme.bodyText2.color,
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
      ),
    );
  }
}
