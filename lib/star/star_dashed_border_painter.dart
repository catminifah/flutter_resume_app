import 'dart:math';
import 'package:flutter/material.dart';

class StarDashedBorderPainter extends CustomPainter {
  final Color color;
  StarDashedBorderPainter({this.color = Colors.white70});

  @override
  void paint(Canvas canvas, Size size) {
    const dashLength = 10.0;
    const starSize = 10.0;
    const spaceBetween = 8.0;
    final paintLine = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final radius = const Radius.circular(12);
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, radius);
    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics().toList();

    final drawStar = (Offset center) {
      final starPath = Path();
      const points = 5;
      final outerRadius = starSize / 2;
      final innerRadius = outerRadius / 2.5;

      for (int i = 0; i < points * 2; i++) {
        final isEven = i % 2 == 0;
        final radius = isEven ? outerRadius : innerRadius;
        final angle = (pi / points) * i - pi / 2;
        final x = center.dx + radius * cos(angle);
        final y = center.dy + radius * sin(angle);
        if (i == 0) {
          starPath.moveTo(x, y);
        } else {
          starPath.lineTo(x, y);
        }
      }
      starPath.close();
      canvas.drawPath(starPath, Paint()..color = color);
    };

    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance + dashLength + spaceBetween + starSize <= metric.length) {
        
        final from = metric.getTangentForOffset(distance)!.position;
        final to = metric.getTangentForOffset(distance + dashLength)!.position;
        canvas.drawLine(from, to, paintLine);

        final starOffset = metric.getTangentForOffset(
          distance + dashLength + spaceBetween + starSize / 2,
        )!;
        drawStar(starOffset.position);

        distance += dashLength + spaceBetween + starSize + spaceBetween;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

