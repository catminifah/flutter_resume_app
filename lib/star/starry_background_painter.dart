import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_resume_app/star/star_painter.dart';

class StarryBackgroundPainter extends CustomPainter {
  final int starCount;
  final List<Color> starColors;

  StarryBackgroundPainter({
    required this.starCount,
    this.starColors = const [
      Colors.white,
      Colors.pinkAccent,
      Colors.lightBlueAccent,
      Colors.amberAccent,
      Colors.purpleAccent,
    ],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();

    for (int i = 0; i < starCount; i++) {
      final starSize = random.nextDouble() * 8 + 4; // 4 - 12 px
      final position = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      final color = starColors[random.nextInt(starColors.length)];

      final painter = StarPainter(color: color);
      painter.paint(
        canvas,
        Size(starSize, starSize),
      );

      canvas.save();
      canvas.translate(position.dx, position.dy);
      painter.paint(canvas, Size(starSize, starSize));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
