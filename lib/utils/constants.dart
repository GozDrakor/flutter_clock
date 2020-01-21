import 'package:flutter/material.dart';

class ClockConstants extends InheritedWidget {
  static ClockConstants of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();

  const ClockConstants({Widget child, Key key}): super(key: key, child: child);

  final double padAmt = 15.0;
  final double contMargin = 1.0;
  final textStyle = const TextStyle(
    color: Colors.white,
    shadows: [
      Shadow(
        blurRadius: 3.0,
        color: Colors.black,
        offset: Offset(1.0, 1.0),
      ),
    ],
  );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

