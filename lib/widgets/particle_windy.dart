import 'dart:math';
import 'package:flutter/material.dart';

class Windy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WindyState();
  }
}

class _WindyState extends State<Windy> with SingleTickerProviderStateMixin {
  final int numOfWinds = 100;
  final double windSpeed = 8;
  _WindyState();

  AnimationController _controller;
  List<Wind> wind;
  final Color color = Color(0x45555555);
  final double maxWind = 20.0;

  @override
  void initState() {
    super.initState();

    // Initialize Windy
    wind = List();
    int i = this.numOfWinds;
    while (i > 0) {
      wind.add(Wind(color, maxWind));
      i--;
    }

    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(days: 365), vsync: this);
    _controller.addListener(() {
      updateWindPosition();
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        foregroundPainter: WindPainter(wind: wind, controller: _controller),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
      ),
    );
  }

  void updateWindPosition() {
    wind.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class WindPainter extends CustomPainter {
  List<Wind> wind;
  AnimationController controller;
  double speed;

  WindPainter({this.wind, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    wind.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Wind {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Wind(Color colour, double maxWind) {
    this.colour = colour.withOpacity(Random().nextDouble());
    this.direction = 15;
    this.speed = 8.0;
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = colour
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);
    resetWhenOffScreen(canvasSize);
    canvas.drawRect(
        Rect.fromPoints(Offset(x, y), Offset(x + 25, y + 2)), paint);

  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    if (x == null) {
      this.x = Random().nextDouble() * canvasSize.width;
    }
    if (y == null) {
      this.y = Random().nextDouble() * canvasSize.height;
    }
  }

  updatePosition() {
    // Only move left to right
    x += 1 + (speed * sin((direction / 10)) / sin(speed)).abs();
  }

  resetWhenOffScreen(Size canvasSize) {
    if (x > (canvasSize.width + 5)) {
      this.x = -5;
    }
    if (y > (canvasSize.height + 5)) {
      this.y = Random().nextDouble() * canvasSize.height;
    }
  }
}
