// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:digital_clock/widgets/clock_widgets.dart';
import 'package:digital_clock/styles/style.dart';
import 'package:digital_clock/utils/constants.dart';
import 'package:digital_clock/widgets/particle_rain.dart';
import 'package:digital_clock/widgets/particle_snow.dart';
import 'package:digital_clock/widgets/particle_cloudy.dart';
import 'package:digital_clock/widgets/particle_windy.dart';
import 'package:digital_clock/widgets/particle_foggy.dart';
import 'package:digital_clock/widgets/particle_thunderstorm.dart';
import 'package:digital_clock/widgets/effect_sunny.dart';

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  double _rayGlow = 0.6;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      //change sunny glow when time updates
      if (_rayGlow > 0.6) {
        _rayGlow = 0.6;
      } else {
        _rayGlow = 1.0;
      }
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // default to dark theme, didn't create a light theme for this clock
    final colors = darkTheme;

    // setting some variables based on the orientation and size of device
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final double colWidth = ((width / 2) - 80) / 3;
    final double genHeight =
        height - (ClockConstants.of(context).padAmt * 2) + 5;

    String hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    String weather = widget.model.weatherString;
    //sunny widget defaulted
    Color wColor = Color(0x66333333);
    Widget wEffect = sunny(_rayGlow, _dateTime);
    // cloudy,foggy,rainy,snowy,sunny,thunderstorm,windy,
    if (weather == "cloudy") {
      wColor = Color(0x66333366);
      wEffect = Cloudy();
    } else if (weather == "foggy") {
      wColor = Color(0x66333333);
      wEffect = Foggy();
    } else if (weather == "snowy") {
      wColor = Color(0x66aaaaaa);
      wEffect = Snow();
    } else if (weather == "rainy") {
      wColor = Color(0x88222299);
      wEffect = Rainy();
    } else if (weather == "windy") {
      wColor = Color(0x88555555);
      wEffect = Windy();
    } else if (weather == "thunderstorm") {
      wColor = Color(0x55dddd00);
      wEffect = Thunderstorm();
    }
    weather = weather[0].toUpperCase() +
        weather.substring(1); //upper case first letter.

    String minute = DateFormat('mm').format(_dateTime);
    String second = DateFormat('ss').format(_dateTime);

    //only display clock in landscape mode.
    //display rotate messaging in portrait mode
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Container(
          padding: EdgeInsets.all(40.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.rotate_left, size: 50.0),
                Text("Please rotate your device",
                    style: TextStyle(fontSize: 20.0)),
                Text("to view the clock", style: TextStyle(fontSize: 20.0)),
              ]));
    } else {
      return Stack(children: <Widget>[
        Container(
          //width: width,
          height: height,
          color: Colors.transparent,
          child: wEffect,
        ),
        Container(
            padding: EdgeInsets.all(ClockConstants.of(context).padAmt),
            color: colors[clockStyle.background],
            //width: width,
            height: height,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.all(ClockConstants.of(context).contMargin),
                      padding: EdgeInsets.all(9.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        color: wColor,
                      ),
                      width: colWidth * 2 + 2,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Center(
                            child: Text(weather,
                                style: ClockConstants.of(context).textStyle),
                          )),
                      height: genHeight * .20,
                    ),
                    Row(children: <Widget>[
                      Column(
                        //adding in the high/low for weather
                        children: tempGauge(
                            widget.model.highString,
                            widget.model.lowString,
                            colWidth,
                            genHeight,
                            ClockConstants.of(context).contMargin,
                            ClockConstants.of(context).textStyle),
                      ),
                      Column(
                        children: processClock(
                            hour.substring(0, 1),
                            1,
                            2,
                            colWidth,
                            ((genHeight * .80) - 42) / 2,
                            ClockConstants.of(context).contMargin,
                            ClockConstants.of(context).textStyle),
                      ),
                    ]),
                  ])
                ]),

                Column(
                  children: processClock(
                      hour.substring(1),
                      0,
                      9,
                      colWidth,
                      (genHeight - 56) / 10,
                      ClockConstants.of(context).contMargin,
                      ClockConstants.of(context).textStyle),
                ),
                //divider below
                Column(
                  children: processClock(
                      "0",
                      1,
                      1,
                      25,
                      height - 88,
                      ClockConstants.of(context).contMargin,
                      ClockConstants.of(context).textStyle),
                ),
                Column(
                  children: processClock(
                      minute.substring(0, 1),
                      0,
                      5,
                      colWidth,
                      (genHeight - 49) / 6,
                      ClockConstants.of(context).contMargin,
                      ClockConstants.of(context).textStyle),
                ),
                Column(
                  children: processClock(
                      minute.substring(1),
                      0,
                      9,
                      colWidth,
                      (genHeight - 59) / 10,
                      ClockConstants.of(context).contMargin,
                      ClockConstants.of(context).textStyle),
                ),
                Column(
                  children: processClock(
                      second.toString(),
                      1,
                      60,
                      colWidth,
                      (genHeight - 157) / 60,
                      ClockConstants.of(context).contMargin,
                      ClockConstants.of(context).textStyle),
                )
              ],
            )))
      ]);
    }
  }
}
