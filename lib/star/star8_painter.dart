import 'dart:math';

import 'package:flutter/material.dart';

class Star8Painter extends CustomPainter {
  final Color color;

  Star8Painter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2;

    const points = 8;
    final double innerRadius = radius * 0.75;

    for (int i = 0; i < points * 2; i++) {
      final isEven = i % 2 == 0;
      final angle = (i * pi) / points;
      final r = isEven ? radius : innerRadius;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
