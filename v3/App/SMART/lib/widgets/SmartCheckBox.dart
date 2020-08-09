import 'package:flutter/material.dart';

class SmartCheckBox extends StatefulWidget {
  final EdgeInsets padding;
  final String title;
  final String subtitle;
  final Function onChange;
  final bool initialValue;

  SmartCheckBox({
    this.padding = const EdgeInsets.all(8),
    this.title,
    this.subtitle,
    @required this.onChange,
    this.initialValue = true,
  });
  @override
  _SmartCheckBoxState createState() => _SmartCheckBoxState();
}

class _SmartCheckBoxState extends State<SmartCheckBox> {
  bool _state;

  @override
  void initState() {
    _state = widget.initialValue;
    super.initState();
  }

  @override
  void dispose() {
    _state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: CheckboxListTile(
        dense: true,
        value: _state,
        onChanged: (val) {
          widget.onChange(val);
          setState(() => _state = val);
        },
        controlAffinity: ListTileControlAffinity.leading,
        title: widget.title == null
            ? null
            : Text(
                widget.title,
                style: Theme.of(context).textTheme.headline3,
              ),
        subtitle: widget.subtitle == null ? null : Text(widget.subtitle),
      ),
    );
  }
}
