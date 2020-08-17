import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';

class SmartGradient extends StatelessWidget {
  SmartGradient({this.child, @required this.helper});

  final Widget child;
  final SmartHelper helper;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: helper.isDarkModeActive
            ? [
                Colors.grey[700].withOpacity(0.4),
                Colors.grey[700].withOpacity(0.7),
              ]
            : [
                Colors.indigo.withOpacity(0.5),
                Theme.of(context).accentColor,
              ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
