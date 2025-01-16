import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analog clock',
      home: MyHomePage(),
    );
  }
}

class MyAppState extends State<MyHomePage> {
  late int _seconds;
  late int _minutes;
  late int _hours;

  @override
  void initState() {
    super.initState();

    updateState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        updateState();
      });
    });
  }

  void updateState() {
    var now = DateTime.now();
    _seconds = now.second;
    _minutes = now.minute;
    _hours = now.hour % 12 * 5;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(size.width / 2, size.height / 2),
              painter: MyPainter(
                  hours: _hours, minutes: _minutes, seconds: _seconds),
            )
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyPainter extends CustomPainter {
  final int hours;
  final int minutes;
  final int seconds;

  double toRadian(double angle) => (angle * pi / 30.0) - (pi / 2.0);

  Offset calculateOffset(Offset center, double radius, int timeUnit) {
    return Offset(center.dx + radius * cos(toRadian(timeUnit.toDouble())),
        center.dy + radius * sin(toRadian(timeUnit.toDouble())));
  }

  Offset hourOffset(Offset center, double radius) {
    return calculateOffset(center, radius / 2.0, hours);
  }

  Offset minuteOffset(Offset center, double radius) {
    return calculateOffset(center, 0.75 * radius, minutes);
  }

  Offset secondsOffset(Offset center, double radius) {
    return calculateOffset(center, 0.85 * radius, seconds);
  }

  MyPainter(
      {required this.hours, required this.minutes, required this.seconds});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, paint);
    canvas.drawLine(center, hourOffset(center, radius), paint);
    canvas.drawLine(center, minuteOffset(center, radius), paint);
    final Paint secondsPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(center, secondsOffset(center, radius), secondsPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
