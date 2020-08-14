import 'package:flutter/material.dart';

class SmartGradient extends StatelessWidget {
  SmartGradient({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).primaryColorDark.withOpacity(0.01),
          Theme.of(context).primaryColorDark,
        ],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
