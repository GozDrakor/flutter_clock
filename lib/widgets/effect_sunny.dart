import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget sunny(double _rayGlow, DateTime _dateTime) {
  int hrs = int.parse(DateFormat('hh').format(_dateTime));
  String daytime = DateFormat("a").format(_dateTime);
  //change glow when rendered.
  Alignment vBegin = Alignment.topLeft, vEnd = Alignment.bottomRight;
  //this will change the direction of the glow on the screen based on the time of day
  //default to daytime sunny glow
  Color rays = Color(0x99cccc00);

  //night time
  if (((hrs > 7 && hrs <= 11 && daytime == "PM") ||
      ((hrs < 7 || hrs == 12) && daytime == "AM"))) {
    rays = Color(0xff888888);
  }
  if ((hrs >= 1 && hrs <= 10 && daytime == "AM") ||
      (hrs == 12 && daytime == "AM")) {
    vBegin = Alignment.topLeft;
    vEnd = Alignment.bottomRight;
  } else if ((hrs >= 11 && daytime == "AM" && hrs <= 12) ||
      ((hrs == 12 || (hrs >= 1 && hrs <= 2)) && daytime == "PM")) {
    vBegin = Alignment.topCenter;
    vEnd = Alignment.bottomCenter;
  } else if (hrs > 2 && daytime == "PM") {
    vBegin = Alignment.topRight;
    vEnd = Alignment.bottomLeft;
  }

  return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: vBegin,
              end: vEnd,
              stops: [0.0, _rayGlow],
              colors: [rays, Colors.transparent])));
}
