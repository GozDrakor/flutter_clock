import 'dart:math';
import 'package:flutter/material.dart';

class Thunderstorm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ThunderstormState();
  }
}

class _ThunderstormState extends State<Thunderstorm>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Thunder> thunderStorm;
  final int numberOfThunderstorm = 40;
  final Color color = Color(0x45757555);
  final double maxThunderStorm = 150.0;

  @override
  void initState() {
    super.initState();

    // Initialize Thunderstorm
    thunderStorm = List();
    int i = numberOfThunderstorm;
    while (i > 0) {
      thunderStorm.add(Thunder(color, maxThunderStorm));
      i--;
    }
    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(days: 365), vsync: this);
    _controller.addListener(() {
      updateThunderPosition();
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
            ThunderPainter(thunderStorm: thunderStorm, controller: _controller),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.25),
      ),
    );
  }

  void updateThunderPosition() {
    thunderStorm.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class ThunderPainter extends CustomPainter {
  List<Thunder> thunderStorm;
  AnimationController controller;

  ThunderPainter({this.thunderStorm, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    thunderStorm.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Thunder {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Thunder(Color colour, double maxThunderStorm) {
    this.colour = colour.withOpacity(Random().nextDouble());
    this.direction = 15;
    this.speed = 0.5;
    double rad = Random().nextDouble() * maxThunderStorm;
    if (rad < maxThunderStorm / 2) {
      rad = maxThunderStorm / 2;
    }
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

    //draw lightning rarely
    double checkLightning = Random().nextDouble() * 2;
    if (checkLightning > 1.997) {
      double _x = Random().nextDouble() * canvasSize.width;
      double _y = canvasSize.height * 0.3;

      Path _path = Path();
      Paint _paint = Paint()
        ..color = Color(0xccffff00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.square;

      _path.moveTo(_x, _y);

      for (double loop = 0; loop <= 30; loop++) {
        _path.lineTo(_x, _y);
        _x += Random().nextDouble() * 7;
        _y += Random().nextDouble() * 20;
      }

      canvas.drawPath(_path, _paint);
    }
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
    if (y > (canvasSize.height + (this.radius * 2))) {
      this.x = Random().nextDouble() * canvasSize.height / 3;
    }
  }
}
