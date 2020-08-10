import 'package:flutter/material.dart';

import '../models/SmartConstants.dart';

class SmartDropdown extends StatefulWidget {
  final IconData prefixIcon;
  final double borderRadius;
  final List<dynamic> itemList;
  final String hint;
  final Function onChanged;
  dynamic selectedItem;

  SmartDropdown({
    this.borderRadius = 16,
    this.hint = 'Please Select',
    this.prefixIcon,
    @required this.itemList,
    @required this.selectedItem,
    @required this.onChanged,
  });

  @override
  _SmartDropdownState createState() => _SmartDropdownState();
}

class _SmartDropdownState extends State<SmartDropdown> {
  SmartHelper helper;

  @override
  Widget build(BuildContext context) {
    helper = SmartHelper(context: context);
    return Row(
      children: <Widget>[
        Container(
          child: widget.prefixIcon == null
              ? null
              : Icon(
                  widget.prefixIcon,
                  color: Theme.of(context).primaryColorDark,
                  size: 32,
                ),
        ),
        Container(
          width: widget.prefixIcon == null
              ? helper.screenWidth - 32 - 16
              : helper.screenWidth - 32 - 48,
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              width: 2,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(Icons.arrow_drop_down),
              items: widget.itemList,
              elevation: 2,
              iconEnabledColor: Theme.of(context).primaryColorDark,
              isExpanded: true,
              hint: Text(
                widget.hint,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              value: widget.selectedItem,
              onChanged: (dynamic val) {
                widget.onChanged(val);
                setState(() => widget.selectedItem = val);
              },
            ),
          ),
        ),
      ],
    );
  }
}
