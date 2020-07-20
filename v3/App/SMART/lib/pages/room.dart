import 'package:SMART/widgets/ProfileCard.dart';
import 'package:SMART/widgets/SmartAppBar.dart';
import 'package:flutter/material.dart';
import '../models/SmartConstants.dart';
import '../widgets/SmartAppBar.dart';

class Room extends StatelessWidget {
  final List<Map<String, Object>> profileList = const [
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 8, 0),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
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
                    ),
                    getProfileCards(
                      helper: helper,
                      profileList: profileList,
                    ),
                  ],
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
    );
  }

  Widget getProfileCards(
      {List<Map<String, Object>> profileList, SmartHelper helper}) {
    return Expanded(
      child: Container(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: profileList.length+1,
          itemBuilder: (context, index) {
            try {
              return Padding(
                padding: EdgeInsets.all(8),
                child: ProfileCard(
                  helper: helper,
                  profileIcon: profileList[index]['profileIcon'],
                  profileName: profileList[index]['profileName'],
                ),
              );
            } catch (e) {
              return ProfileCard(
                  helper: helper,
                  profileIcon: Icons.add_circle_outline,
                  profileName: "Create\nNew",
                );
            }
          },
        ),
      ),
    );
  }
}
