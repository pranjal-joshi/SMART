import 'package:flutter/material.dart';
import '../models/SmartConstants.dart';

class SwitchboardCard extends StatefulWidget {
  @override
  _SwitchboardCardState createState() => _SwitchboardCardState();
}

class _SwitchboardCardState extends State<SwitchboardCard> {
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
            elevation: 24,
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
                  labelColor: helper.getTextHeadingColor,
                  labelStyle: TextStyle(
                    fontFamily: 'ProductSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  tabs: [
                    Tab(text: "Switches"),
                    Tab(text: "Devices"),
                  ],
                ),
                SizedBox(height: 24,),
                Text("Add Switch List Here"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
