import 'dart:math';
import 'package:flutter/material.dart';

class Snow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SnowState();
  }
}

class _SnowState extends State<Snow> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Bubble> snow;
  final int numberOfSnow = 100;
  final Color color = Color(0xdddddddd);
  final double maxSnow = 6.0;

  @override
  void initState() {
    super.initState();

    // Initialize Snow
    snow = List();
    int i = numberOfSnow;
    while (i > 0) {
      snow.add(Bubble(color, maxSnow));
      i--;
    }

    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(days: 365), vsync: this);
    _controller.addListener(() {
      updateBubblePosition();
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
        foregroundPainter: BubblePainter(snow: snow, controller: _controller),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
      ),
    );
  }

  void updateBubblePosition() {
    snow.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class BubblePainter extends CustomPainter {
  List<Bubble> snow;
  AnimationController controller;

  BubblePainter({this.snow, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    snow.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Bubble {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Bubble(Color colour, double maxSnow) {
    this.colour = colour.withOpacity(Random().nextDouble());
    this.direction = 1 + (Random().nextDouble() * 90);
    this.speed = 1;
    this.radius = Random().nextDouble() * maxSnow;
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);
    resetWhenOffScreen(canvasSize);
    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    if (x == null) {
      this.x = 1 + (Random().nextDouble() * canvasSize.width);
    }
    if (y == null) {
      this.y = 1 + (Random().nextDouble() * canvasSize.height);
    }
  }

  updatePosition() {
    x += 1 + (speed * sin(direction) / sin(speed)).abs();
    y += 1 + (speed * sin(direction) / sin(speed)).abs();
  }

  resetWhenOffScreen(Size canvasSize) {
    if (x > (canvasSize.width + 10) || x < -10) {
      this.x = Random().nextDouble() * canvasSize.width;
    }
    if (y > (canvasSize.height + 10) || y < -10) {
      y = -5;
    }
  }
}
