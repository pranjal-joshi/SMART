import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';

class SmartTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final String helperText;
  final String initialVal;
  final IconData iconData;
  final bool obscure;
  final TextInputType keyboardType;
  final Function validator;
  final TextEditingController controller;
  final double topPadding;
  final double bottomPadding;
  final double leftPadding;
  final double rightPadding;

  SmartTextFormField({
    this.label,
    this.hint,
    this.helperText,
    this.initialVal,
    this.iconData,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.topPadding = 8,
    this.bottomPadding = 8,
    this.leftPadding = 0,
    this.rightPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final SmartHelper helper = SmartHelper(context: context);
    final OutlineInputBorder outlineInputBorder_2 = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColorDark,
        width: 2,
      ),
    );
    final OutlineInputBorder outlineInputBorder_3 = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColorDark,
        width: 3,
      ),
    );
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
        left: leftPadding,
        right: rightPadding,
      ),
      child: TextFormField(
        initialValue: initialVal != null ? initialVal : null,
        cursorColor: Theme.of(context).primaryColorDark,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        style: Theme.of(context).textTheme.headline3,
        obscureText: obscure,
        validator: (str) => validator != null ? validator(str) : null,
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          hintText: hint,
          helperText: helperText,
          helperMaxLines: 4,
          helperStyle: Theme.of(context).textTheme.subtitle1,
          hintMaxLines: 1,
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.subtitle1.color,
            fontSize: Theme.of(context).textTheme.headline3.fontSize,
          ),
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          icon: Icon(
            iconData,
            color: Theme.of(context).primaryColorDark,
            size: 32,
          ),
          border: outlineInputBorder_2,
          enabledBorder: outlineInputBorder_2,
          focusedBorder: outlineInputBorder_3,
          errorBorder: outlineInputBorder_2,
          errorMaxLines: 2,
          errorStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color:
                helper.isDarkModeActive ? Colors.blue[400] : Colors.blue[700],
          ),
        ),
      ),
    );
  }
}
