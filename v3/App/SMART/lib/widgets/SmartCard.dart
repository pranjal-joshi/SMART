import 'package:flutter/material.dart';

import '../helpers/SmartHelper.dart';

enum SmartCardBlurRadius {
  Flat,
  Subtle,
  Spread14,
  Spread22,
}

class SmartCard extends StatelessWidget {
  final Color shadowColor;
  final double cornerRadius;
  final Widget child;
  final EdgeInsets padding;
  final SmartHelper helper;
  final double elevation;
  final SmartCardBlurRadius blurRadius;
  final Color darkModeSurfaceColor;

  SmartCard({
    this.shadowColor,
    this.cornerRadius = 4,
    this.elevation = 8,
    this.padding = const EdgeInsets.all(0),
    @required this.child,
    @required this.helper,
    this.blurRadius = SmartCardBlurRadius.Subtle,
    this.darkModeSurfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    Color _colorToUse;
    Color _darkModeColorToUse;
    double _blurRadiusToUse;
    switch (blurRadius) {
      case SmartCardBlurRadius.Flat:
        _blurRadiusToUse = 0;
        break;
      case SmartCardBlurRadius.Subtle:
        _blurRadiusToUse = 8;
        break;
      case SmartCardBlurRadius.Spread14:
        _blurRadiusToUse = 14;
        break;
      case SmartCardBlurRadius.Spread22:
        _blurRadiusToUse = 22;
        break;
    }
    shadowColor == null
        ? _colorToUse = Colors.grey[400]
        : _colorToUse = shadowColor.withOpacity(0.35);
    darkModeSurfaceColor == null
        ? _darkModeColorToUse = Theme.of(context).cardColor
        : _darkModeColorToUse = darkModeSurfaceColor;
    if (helper.isDarkModeActive) {
      return Container(
        child: ClipRRect(
          child: child,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        ),
        padding: padding,
        decoration: BoxDecoration(
          color: _darkModeColorToUse,
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        ),
      );
    }
    return Container(
      child: ClipRRect(
        child: child,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
      ),
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        boxShadow: blurRadius != SmartCardBlurRadius.Flat
            ? [
                BoxShadow(
                  blurRadius: _blurRadiusToUse,
                  spreadRadius: -4,
                  color: _colorToUse,
                  offset: Offset(0, elevation),
                ),
                BoxShadow(
                  blurRadius: _blurRadiusToUse,
                  spreadRadius: -4,
                  color: _colorToUse,
                  offset: Offset(0, -elevation / 80),
                ),
                BoxShadow(
                  blurRadius: _blurRadiusToUse,
                  spreadRadius: -4,
                  color: _colorToUse,
                  offset: Offset(elevation / 6, 0),
                ),
              ]
            : null,
      ),
    );
  }
}
