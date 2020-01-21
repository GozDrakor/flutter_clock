import 'dart:math';
import 'package:flutter/material.dart';

class Rainy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RainyState();
  }
}

class _RainyState extends State<Rainy> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Rain> rainy;
  final int numberOfRain = 300;
  final Color color = Color(0xdd6666dd);
  final double maxRain = 3.0;

  @override
  void initState() {
    super.initState();

    // Initialize Rainy
    rainy = List();
    int i = numberOfRain;
    while (i > 0) {
      rainy.add(Rain(color, maxRain));
      i--;
    }

    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(days: 365), vsync: this);
    _controller.addListener(() {
      updateRainPosition();
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
        foregroundPainter: RainPainter(rainy: rainy, controller: _controller),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
      ),
    );
  }

  void updateRainPosition() {
    rainy.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class RainPainter extends CustomPainter {
  List<Rain> rainy;
  AnimationController controller;
  RainPainter({this.rainy, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    rainy.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Rain {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Rain(Color colour, double maxRain) {
    this.colour = colour.withOpacity(Random().nextDouble());
    this.direction = 15;
    this.speed = 5;
    this.radius = Random().nextDouble() * maxRain;
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = colour
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);
    resetWhenOffScreen(canvasSize);
    canvas.drawCircle(Offset(x, y), radius, paint);
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
    //rain only falls down for the animation
    y += 1 + (speed * sin(direction) / sin(speed)).abs();
  }

  resetWhenOffScreen(Size canvasSize) {
    if (x > canvasSize.width || x < 0) {
      this.x = Random().nextDouble() * canvasSize.width;
    }
    if (y > canvasSize.height || y < 2) {
      y = 5;
    }
  }
}
