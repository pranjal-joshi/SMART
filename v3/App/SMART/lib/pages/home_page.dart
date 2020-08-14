import 'package:SMART/widgets/SmartRoomIndicator.dart';
import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';
import '../models/SmartRoomData.dart';

import '../widgets/SmartRoomCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SmartHelper helper;

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);

    List<SmartRoomData> dataList = [
      SmartRoomData(
        name: 'Room 1',
        icon: Icons.filter_1,
      ),
      SmartRoomData(
        name: 'Room 2',
        icon: Icons.filter_2,
      ),
      SmartRoomData(
        name: 'Room 3',
        icon: Icons.filter_3,
      ),
      SmartRoomData(
        name: 'Room 4',
        icon: Icons.filter_4,
      ),
      SmartRoomData(
        name: 'Room 5',
        icon: Icons.filter_5,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 5 / 3.5),
          itemCount: dataList.length,
          itemBuilder: (_, index) {
            return SmartRoomCard(
              helper: helper,
              roomData: dataList[index],
              indicatorState: SmartRoomIndicatorState.powerOn,
              onTap: (){
                print('Clicked on ${dataList[index].name}');
              },
            );
          },
        ),
      ),
    );
  }
}
