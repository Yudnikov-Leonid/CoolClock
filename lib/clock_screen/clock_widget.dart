import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final dateTime = DateTime.now();

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final radius = min(centerX, centerY);

    final fillBrush = Paint()..color = Colors.black26;
    final outlineBrush = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke;
    final centerBrush = Paint()..color = Colors.grey.shade300;

    final secBrush = Paint()
      ..color = Colors.amber
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final minBrush = Paint()
      ..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.blue])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final hourBrush = Paint()
      ..shader = const RadialGradient(colors: [Colors.pink, Colors.purple])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outlineBrush);

    final secX = centerX + 80 * cos(dateTime.second * 6 * pi / 180);
    final secY = centerY + 80 * sin(dateTime.second * 6 * pi / 180);

    final minX = centerX + 80 * cos(dateTime.minute * 6 * pi / 180);
    final minY = centerY + 80 * sin(dateTime.minute * 6 * pi / 180);

    final hourX = centerX +
        60 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    final hourY = centerY +
        60 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);

    canvas.drawLine(center, Offset(hourX, hourY), hourBrush);
    canvas.drawLine(center, Offset(minX, minY), minBrush);
    canvas.drawLine(center, Offset(secX, secY), secBrush);

    canvas.drawCircle(center, 16, centerBrush);

    final outerCircleRadius = radius;
    final innerCircleRadius = radius - 14;
    final dashBrush = Paint()
      ..color = Colors.white38
      ..strokeWidth = 2;
    for (double i = 0; i < 360; i += 12) {
      final x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      final y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      final x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      final y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
