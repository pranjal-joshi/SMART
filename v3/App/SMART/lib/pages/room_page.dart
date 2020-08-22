import 'package:flutter/material.dart';

import '../helpers/SmartHelper.dart';

import '../models/SmartProfile.dart';

import '../widgets/ProfileCard.dart';
import '../widgets/CreateProfileCard.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  SmartHelper helper;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    helper = SmartHelper(context: context);
    return Scaffold(
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              pinned: true,
              snap: true,
              floating: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
              expandedHeight: helper.screenHeight / 2.2 -
                  MediaQuery.of(context).padding.top,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: double.infinity,
                  decoration: helper.isDarkModeActive
                      ? BoxDecoration(
                          color: Colors.black,
                        )
                      : BoxDecoration(
                          gradient: LinearGradient(
                            tileMode: TileMode.mirror,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).primaryColorDark,
                              Colors.indigo[500],
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 16,
                        top: MediaQuery.of(context).padding.top * 2.5,
                        child: Icon(
                          args['icon'],
                          size: 156,
                          color: Colors.white38,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top * 2.2,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                args['roomName'],
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '4 Devices',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        top: MediaQuery.of(context).padding.top * 6.2,
                        left: 0,
                        right: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: const Text(
                                'Profiles',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  height: 0.1,
                                ),
                              ),
                            ),
                            Expanded(
                              child: getProfileCards(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Placeholder(),
                ),
                childCount: 10,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 0,
                childAspectRatio: 1 / 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProfileCards({
    List<SmartProfile> profileList,
    SmartHelper helper,
  }) {
    final List<SmartProfile> profileList = [
      SmartProfile(profileName: "Party", profileIcon: Icons.blur_circular),
      SmartProfile(profileName: "Chill", profileIcon: Icons.music_note),
      SmartProfile(profileName: "Sleep", profileIcon: Icons.brightness_3),
      SmartProfile(profileName: "Movie", profileIcon: Icons.movie),
    ];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: profileList.length + 1,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        try {
          return Padding(
            padding: EdgeInsets.all(6),
            child: ProfileCard(
              profileIcon: profileList[index].profileIcon,
              profileName: profileList[index].profileName,
            ),
          );
        } catch (e) {
          return Padding(
            padding: EdgeInsets.fromLTRB(8, 10, 16, 10),
            child: CreateProfileCard(),
          );
        }
      },
    );
  }
}
