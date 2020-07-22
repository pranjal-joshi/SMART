import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';
import '../widgets/SwitchboardTile.dart';
import '../models/SwitchboardRow.dart';

class SwitchboardCard extends StatefulWidget {
  final List<SwitchboardRow> switchboardList;

  SwitchboardCard({@required this.switchboardList});

  @override
  _SwitchboardCardState createState() => _SwitchboardCardState();
}

class _SwitchboardCardState extends State<SwitchboardCard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    SmartHelper helper = SmartHelper(context: context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: DefaultTabController(
        length: 2,
        child: Container(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(helper.screenWidth * 0.1),
                topRight: Radius.circular(helper.screenWidth * 0.1),
              ),
            ),
            //color: helper.getCardBackgroudColor,
            color: Theme.of(context).cardColor,
            child: Column(
              children: <Widget>[
                TabBar(
                  isScrollable: false,
                  labelColor: Theme.of(context).textTheme.headline2.color,
                  labelStyle: Theme.of(context).textTheme.headline2,
                  tabs: [
                    Tab(text: "Switches"),
                    Tab(text: "Devices"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // ListView(
                      //   children: <Widget>[
                      //     SwitchboardTile(
                      //       deviceName: "My Device",
                      //       deviceIcon: Icons.ac_unit,
                      //       deviceState: true,
                      //       helper: helper,
                      //     ),
                      //   ],
                      // ),
                      ListView.builder(
                        itemCount: widget.switchboardList.length,
                        itemBuilder: (ctx, index) {
                          return SwitchboardTile(
                            row: widget.switchboardList[index],
                          );
                        },
                      ),
                      Text("Add Switch List Here 2"),
                    ],
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
