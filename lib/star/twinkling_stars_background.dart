import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class TwinklingStars_Background extends StatefulWidget {
  final Widget child;

  const TwinklingStars_Background({required this.child, super.key});

  @override
  _TwinklingStars_BackgroundState createState() =>
      _TwinklingStars_BackgroundState();
}

class _TwinklingStars_BackgroundState extends State<TwinklingStars_Background>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);

    final random = Random();
    _stars = List.generate(100, (index) {
      final isBig = random.nextDouble() < 0.1;
      return Star.random(isBigStar: isBig);
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: size,
              painter: TwinklingStarPainter(_stars, _controller.value),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

enum StarShape {
  star4,
  star5,
  star6,
  sparkle3,
  sparkle4,
  fivePoint,
  sixPoint,
  diamond,
}

class Star {
  final Offset position;
  final double baseRadius;
  final double baseOpacity;
  final double twinkleSpeed;
  final double rotationSpeed;
  final StarShape shapeType;
  final bool isBigStar;
  final double twinklePhase;

  Star(
    this.position,
    this.baseRadius,
    this.baseOpacity,
    this.twinkleSpeed,
    this.rotationSpeed,
    this.shapeType,
    this.isBigStar,
    this.twinklePhase,
  );

  factory Star.random({bool isBigStar = false}) {
    final random = Random();

    return Star(
      Offset(random.nextDouble(), random.nextDouble()),
      isBigStar ? (random.nextDouble() * 4 + 3) : (random.nextDouble() * 2 + 0.5),
      random.nextDouble() * 0.5 + 0.3,
      random.nextDouble() * 2 + 1,
      random.nextDouble() * 2 - 1,
      StarShape.values[random.nextInt(StarShape.values.length)],
      isBigStar,
      random.nextDouble() * 2 * pi,
    );
  }
}

Path createStarPath(Offset center, double radius, StarShape shape, double rotationAngle) {
  final path = Path();
  int numPoints;
  final double innerRadius;
  switch (shape) {
    case StarShape.star4:
      {
        final points = 4;
        final step = pi / points;
        for (int i = 0; i < 2 * points; i++) {
          final r = (i % 2 == 0) ? radius : radius / 2;
          final angle = i * step - pi / 2 + rotationAngle;
          final point = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
          if (i == 0) path.moveTo(point.dx, point.dy);
          else path.lineTo(point.dx, point.dy);
        }
        path.close();
        return path;
      }
    case StarShape.star5:
      {
        final points = 5;
        final step = pi / points;
        for (int i = 0; i < 2 * points; i++) {
          final r = (i % 2 == 0) ? radius : radius / 2;
          final angle = i * step - pi / 2 + rotationAngle;
          final point = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
          if (i == 0) path.moveTo(point.dx, point.dy);
          else path.lineTo(point.dx, point.dy);
        }
        path.close();
        return path;
      }
    case StarShape.star6:
      {
        final points = 6;
        final step = pi / points;
        for (int i = 0; i < 2 * points; i++) {
          final r = (i % 2 == 0) ? radius : radius / 2;
          final angle = i * step - pi / 2 + rotationAngle;
          final point = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
          if (i == 0) path.moveTo(point.dx, point.dy);
          else path.lineTo(point.dx, point.dy);
        }
        path.close();
        return path;
      }
    case StarShape.sparkle3:
      {
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx, center.dy + radius);
        path.moveTo(center.dx - radius * 0.6, center.dy);
        path.lineTo(center.dx + radius * 0.6, center.dy);
        path.moveTo(center.dx - radius * 0.5, center.dy - radius * 0.5);
        path.lineTo(center.dx + radius * 0.5, center.dy + radius * 0.5);
        return path;
      }
    case StarShape.sparkle4:
      {
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx, center.dy + radius);
        path.moveTo(center.dx - radius, center.dy);
        path.lineTo(center.dx + radius, center.dy);
        path.moveTo(center.dx - radius * 0.7, center.dy - radius * 0.7);
        path.lineTo(center.dx + radius * 0.7, center.dy + radius * 0.7);
        path.moveTo(center.dx - radius * 0.7, center.dy + radius * 0.7);
        path.lineTo(center.dx + radius * 0.7, center.dy - radius * 0.7);
        return path;
      }
    case StarShape.fivePoint:
      numPoints = 5;
      innerRadius = radius * 0.5;
      break;
    case StarShape.sixPoint:
      numPoints = 6;
      innerRadius = radius * 0.55;
      break;
    case StarShape.diamond:
      path.moveTo(center.dx, center.dy - radius);
      path.lineTo(center.dx + radius, center.dy);
      path.lineTo(center.dx, center.dy + radius);
      path.lineTo(center.dx - radius, center.dy);
      path.close();
      return path;
  }

  final double angleStep = pi / numPoints;

  for (int i = 0; i < numPoints * 2; i++) {
    final bool isEven = i % 2 == 0;
    final double r = isEven ? radius : innerRadius;
    final double angle = rotationAngle + i * angleStep;

    final x = center.dx + r * cos(angle);
    final y = center.dy + r * sin(angle);

    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }

  path.close();
  return path;
}

class TwinklingStarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  TwinklingStarPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final position =
          Offset(star.position.dx * size.width, star.position.dy * size.height);

      double scale = 0.5 +
          0.5 *
              sin(animationValue * 2 * pi * star.twinkleSpeed +
                  star.twinklePhase);
      double radius = star.baseRadius * scale;

      final double opacity = (star.baseOpacity +
              sin(animationValue * pi * star.twinkleSpeed + star.twinklePhase) *
                  0.3)
          .clamp(0, 1);

      final Paint paint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final double rotationAngle = animationValue * 2 * pi * star.rotationSpeed;

      if (star.isBigStar) {
        final glowPaint = Paint()
          ..color = Colors.white.withOpacity(opacity * 0.4)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
        final glowPath = createStarPath(
            position, radius * 2.5, star.shapeType, rotationAngle);
        canvas.drawPath(glowPath, glowPaint);
      }

      final path =
          createStarPath(position, radius * 2, star.shapeType, rotationAngle);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
