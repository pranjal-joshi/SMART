import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import '../helpers/SmartHelper.dart';

import '../models/SmartProfile.dart';
import '../models/SmartPopupMenu.dart';

import '../providers/JsonNodeLabelProvider.dart';

import '../widgets/SmartDeviceCard.dart';
import '../widgets/ProfileCard.dart';
import '../widgets/CreateProfileCard.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  SmartHelper helper;
  final _sliverAppBarBorder = const BorderRadius.only(
    bottomLeft: Radius.circular(10),
    bottomRight: Radius.circular(10),
  );
  final _menuList = [
    SmartPopupMenu(title: 'Edit', icon: LineAwesomeIcons.edit),
    SmartPopupMenu(title: 'Reset', icon: LineAwesomeIcons.refresh),
    SmartPopupMenu(title: 'Emergency', icon: LineAwesomeIcons.power_off),
  ];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> args = {};

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    helper = SmartHelper(context: context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: _sliverAppBarBorder,
              ),
              pinned: false,
              snap: false,
              floating: true,
              forceElevated: true,
              actions: [
                PopupMenuButton(
                  itemBuilder: (_) => _menuList
                      .map(
                        (choice) => PopupMenuItem(
                          value: choice,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                choice.title,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Icon(
                                choice.icon,
                                color: helper.isDarkModeActive
                                    ? color_white_dark
                                    : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              expandedHeight: helper.screenHeight / 2.2 -
                  MediaQuery.of(context).padding.top,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  width: double.infinity,
                  decoration: helper.isDarkModeActive
                      ? BoxDecoration(
                          color: Color.fromRGBO(25, 25, 25, 1),
                          borderRadius: _sliverAppBarBorder,
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
                          borderRadius: _sliverAppBarBorder,
                        ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 16,
                        top: MediaQuery.of(context).padding.top * 2.0,
                        child: Icon(
                          args['icon'],
                          size: 156,
                          color: Colors.white30,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top * 2.4,
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
                                style: const TextStyle(
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
                                style: const TextStyle(
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
            SliverStickyHeader(
              header: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  bottom: 12,
                ),
                child: Text(
                  'All Devices',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              sliver: Consumer<JsonNodeLabelProvider>(
                builder: (_, labelData, __) {
                  final deviceList =
                      labelData.getDeviceDataListByRoomId(args['roomName']);
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: LayoutBuilder(
                          builder: (_, constraints) => SmartDeviceCard(
                            deviceData: deviceList[i],
                            helper: helper,
                            constraints: constraints,
                            textColor: Colors.indigo,
                            onTap: () => helper.showSnackbarTextWithGlobalKey(
                              _scaffoldKey,
                              'Opening this Device Details!',
                            ),
                          ),
                        ),
                      ),
                      childCount: deviceList.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 0,
                      childAspectRatio: 1 / 1,
                    ),
                  );
                },
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
            padding: EdgeInsets.all(10),
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
