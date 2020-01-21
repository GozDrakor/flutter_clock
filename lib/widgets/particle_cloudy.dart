import 'dart:math';
import 'package:flutter/material.dart';

class Cloudy extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CloudyState();
  }
}

class _CloudyState extends State<Cloudy> with SingleTickerProviderStateMixin {
  final int numOfClouds = 50;
  final double windSpeed = 0.2;
  _CloudyState();

  AnimationController _controller;
  List<Cloud> cloud;
  final Color color = Color(0x45666673);
  final double maxCloud = 150.0;

  @override
  void initState() {
    super.initState();

    // Initialize Cloudy
    cloud = List();
    int i = this.numOfClouds;
    while (i > 0) {
      cloud.add(Cloud(color, maxCloud, this.windSpeed));
      i--;
    }

    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(days: 365), vsync: this);
    _controller.addListener(() {
      updateCloudPosition();
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
        foregroundPainter: CloudPainter(cloud: cloud, controller: _controller),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.4),
      ),
    );
  }

  void updateCloudPosition() {
    cloud.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class CloudPainter extends CustomPainter {
  List<Cloud> cloud;
  AnimationController controller;
  double speed;

  CloudPainter({this.cloud, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    cloud.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Cloud {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Cloud(Color colour, double maxCloud, double _speed) {
    this.colour = colour.withOpacity(Random().nextDouble());
    this.direction = 15;
    this.speed = _speed;
    double rad = Random().nextDouble() * maxCloud;
    if (rad < maxCloud / 2) {
      rad = maxCloud / 2;
    }
    this.radius = rad;
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
      this.y = Random().nextDouble() * canvasSize.height / 3;
    }
  }

  updatePosition() {
    // Only move left to right
    x += 1 + (speed * sin((direction / 10)) / sin(speed)).abs();
  }

  resetWhenOffScreen(Size canvasSize) {
    if (x > (canvasSize.width + (this.radius * 2))) {
      this.x = (this.radius * -1) + -2;
    }
  }
}
