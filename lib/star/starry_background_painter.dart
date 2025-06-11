import 'dart:math';
import 'package:flutter/material.dart';

class StarryBackgroundPainter extends CustomPainter {
  final int starCount;

  StarryBackgroundPainter({required this.starCount});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
    Color.fromARGB(255, 163, 136, 235).withOpacity(0.2),
    Color.fromARGB(255, 96, 228, 228).withOpacity(0.2),
    Color.fromARGB(255, 237, 252, 106).withOpacity(0.2),
    Color.fromARGB(255, 250, 136, 161).withOpacity(0.2),
  ],
    );
    final bgPaint = Paint()..shader = gradient.createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);
    final starColors = [
      Colors.purple.withOpacity(0.4),
      Colors.yellowAccent.withOpacity(0.4),
      Colors.lightBlueAccent.withOpacity(0.4),
      Colors.pinkAccent.withOpacity(0.4),
    ];

    final random = Random(12345);
    final placedStars = <Offset>[];

    int attempts = 0;
    while (placedStars.length < starCount && attempts < starCount * 10) {
      attempts++;

      final starSize = random.nextDouble() * 10 + 10;
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final position = Offset(x, y);

      const minDistance = 24.0;
      bool tooClose = placedStars.any((other) =>
          (position - other).distance < minDistance);

      if (tooClose) continue;

      placedStars.add(position);

      final color = starColors[random.nextInt(starColors.length)];
      final angle = random.nextDouble() * 2 * pi;

      final path = _createStarPath(starSize);
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      canvas.save();
      canvas.translate(x, y);
      canvas.drawCircle(Offset.zero, starSize * 0.5, glowPaint);
      canvas.rotate(angle);
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
      canvas.restore();
    }
  }

  Path _createStarPath(double size) {
    final path = Path();
    const points = 5;
    final center = Offset.zero;
    final outerRadius = size / 2;
    final innerRadius = outerRadius / 2.5;

    for (int i = 0; i < points * 2; i++) {
      final isEven = i % 2 == 0;
      final radius = isEven ? outerRadius : innerRadius;
      final angle = (pi / points) * i - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant StarryBackgroundPainter oldDelegate) =>
      oldDelegate.starCount != starCount;
}
