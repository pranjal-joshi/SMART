import 'package:flutter/material.dart';

class RoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Hero(
          tag: 'TestRoom',
          child: Icon(
            Icons.android,
            size: 52,
          ),
        ),
      ),
    );
  }
}
