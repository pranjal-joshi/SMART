import 'package:SMART/widgets/ProfileCard.dart';
import 'package:SMART/widgets/SmartAppBar.dart';
import 'package:flutter/material.dart';
import '../models/SmartConstants.dart';
import '../widgets/SmartAppBar.dart';

class Room extends StatelessWidget {

  final List<Map<String,Object>> profileList = const [
    {
      "profileName": "Party",
      "profileIcon": Icons.blur_circular,
    },
    {
      "profileName": "Chill",
      "profileIcon": Icons.music_note,
    },
    {
      "profileName": "Sleeping",
      "profileIcon": Icons.brightness_3,
    },
    {
      "profileName": "Movie",
      "profileIcon": Icons.movie,
    }
  ];

  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return Scaffold(
      appBar: SmartAppBar(
        title: "Room Name",
        helper: helper,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: helper.getBackgroundColor,
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    color: helper.getCardBackgroudColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(12, 8, 8, 0),
                          child: Text(
                            "Profiles",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: helper.getTextHeadingColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            /*child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Card(
                                    elevation: 8,
                                    child: Container(
                                      height: double.infinity,
                                      width: helper.screenWidth / 3,
                                      color: helper.getCardBackgroudColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),*/
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: profileList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: ProfileCard(
                                    helper: helper,
                                    // profileIcon: Icons.lightbulb_outline,
                                    // profileName: "Profile Name",
                                    profileIcon: profileList[index]['profileIcon'],
                                    profileName: profileList[index]['profileName'],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Card(
                    child: Text(
                      "List of Device Switches",
                      textAlign: TextAlign.center,
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
