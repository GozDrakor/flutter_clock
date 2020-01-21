import 'dart:math';
import 'package:flutter/material.dart';

class Foggy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FoggyState();
  }
}

class _FoggyState extends State<Foggy> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Fog> foggy;
  final int numberOfFoggy = 25;
  final Color color = Color(0x11666666);
  final double maxFoggy = 500.0;

  @override
  void initState() {
    super.initState();

    // Initialize Foggy
    foggy = List();
    int i = numberOfFoggy;
    while (i > 0) {
      foggy.add(Fog(color, maxFoggy));
      i--;
    }
    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(days: 365), vsync: this);
    _controller.addListener(() {
      updateFogPosition();
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
        foregroundPainter:
        FogPainter(foggy: foggy, controller: _controller),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.8),
      ),
    );
  }

  void updateFogPosition() {
    foggy.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class FogPainter extends CustomPainter {
  List<Fog> foggy;
  AnimationController controller;

  FogPainter({this.foggy, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    foggy.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Fog {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Fog(Color colour, double maxFoggy) {
    this.colour = colour.withOpacity(Random().nextDouble());
    this.direction = 15;
    this.speed = 0.02;
    double rad = Random().nextDouble() * maxFoggy;
    if(rad < maxFoggy/2) { rad = maxFoggy / 2; }
    this.radius = rad;
    //print(this.direction.toString());
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
      this.x = Random().nextDouble() * canvasSize.width;
    }
    if (y == null) {
      this.y = Random().nextDouble() * canvasSize.height/3;
    }
  }

  updatePosition() {
    //move left to right only
    x += 1 + (speed * sin((direction/10)) / sin(speed)).abs();
  }

  resetWhenOffScreen(Size canvasSize) {
    if (x > (canvasSize.width + (this.radius * 2)) ){
      this.x = (this.radius * -1) + -2;
    }
    if(y > (canvasSize.height + (this.radius * 2)) ) {
      this.x = Random().nextDouble() * canvasSize.height/3;
    }
  }
}