import 'dart:math';
import 'package:flutter/material.dart';

enum StarShapes { fivePoint, sixPoint, diamond, sparkle3 }

enum EffectPosition { top, bottom, left, right, center }

class SparkleBurstEffect extends StatefulWidget {
  final Offset center;
  final double radius;
  final int sparkleCount;
  final List<Color> colors;
  final List<double> sizes;
  final List<StarShapes> starShapes;
  final Duration duration;
  final VoidCallback? onComplete;
  final EffectPosition effectPosition;

  const SparkleBurstEffect({
    super.key,
    required this.center,
    this.radius = 40,
    this.sparkleCount = 15,
    this.colors = const [Colors.white],
    this.sizes = const [10],
    this.starShapes = const [StarShapes.fivePoint],
    this.duration = const Duration(milliseconds: 800),
    this.effectPosition = EffectPosition.center,
    this.onComplete,
  });

  @override
  _SparkleBurstEffectState createState() => _SparkleBurstEffectState();
}

class _SparkleBurstEffectState extends State<SparkleBurstEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Sparkle> sparkles;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    sparkles = List.generate(widget.sparkleCount, (index) {
      final angle = random.nextDouble() * 2 * pi;
      final size = widget.sizes[random.nextInt(widget.sizes.length)];
      final color = widget.colors[random.nextInt(widget.colors.length)];
      final shape = widget.starShapes[random.nextInt(widget.starShapes.length)];
      return _Sparkle(
        angle: angle,
        distance: 0,
        opacity: 1.0,
        size: size,
        color: color,
        shape: shape,
      );
    });

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {
          for (var sparkle in sparkles) {
            sparkle.distance = _controller.value * widget.radius;
            sparkle.opacity = 1.0 - _controller.value;
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _calculateOffset() {
    switch (widget.effectPosition) {
      case EffectPosition.top:
        return Offset(0, -widget.radius);
      case EffectPosition.bottom:
        return Offset(0, widget.radius);
      case EffectPosition.left:
        return Offset(-widget.radius, 0);
      case EffectPosition.right:
        return Offset(widget.radius, 0);
      case EffectPosition.center:
      return Offset.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizeBox = widget.radius * 2 + 40;
    Offset adjustedCenter = widget.center + _calculateOffset();

    return Positioned(
      left: adjustedCenter.dx - sizeBox / 2,
      top: adjustedCenter.dy - sizeBox / 2,
      width: sizeBox,
      height: sizeBox,
      child: Stack(
        children: sparkles.map((sparkle) {
          final dx = cos(sparkle.angle) * sparkle.distance + sizeBox / 2;
          final dy = sin(sparkle.angle) * sparkle.distance + sizeBox / 2;

          return Positioned(
            left: dx,
            top: dy,
            child: Opacity(
              opacity: sparkle.opacity,
              child: CustomPaint(
                size: Size(sparkle.size, sparkle.size),
                painter: _StarPainter(color: sparkle.color, shape: sparkle.shape),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Sparkle {
  double angle;
  double distance;
  double opacity;
  double size;
  Color color;
  StarShapes shape;

  _Sparkle({
    required this.angle,
    required this.distance,
    required this.opacity,
    required this.size,
    required this.color,
    required this.shape,
  });
}

class _StarPainter extends CustomPainter {
  final Color color;
  final StarShapes shape;

  _StarPainter({required this.color, required this.shape});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    switch (shape) {
      case StarShapes.fivePoint:
        _drawStar(canvas, size, 5, paint);
        break;
      case StarShapes.sixPoint:
        _drawStar(canvas, size, 6, paint);
        break;
      case StarShapes.diamond:
        _drawDiamond(canvas, size, paint);
        break;
      case StarShapes.sparkle3:
        _drawSparkle3(canvas, size, paint);
        break;
    }
  }

  void _drawStar(Canvas canvas, Size size, int points, Paint paint) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < points; i++) {
      double angle = (i * 360 / points) * pi / 180;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += 180 / points * pi / 180;
      x = center.dx + radius / 2 * cos(angle);
      y = center.dy + radius / 2 * sin(angle);
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDiamond(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width / 2;
    final h = size.height / 2;

    path.moveTo(center.dx, center.dy - h);
    path.lineTo(center.dx + w, center.dy);
    path.lineTo(center.dx, center.dy + h);
    path.lineTo(center.dx - w, center.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawSparkle3(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      double angle = (i * 120) * pi / 180;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += 60 * pi / 180;
      x = center.dx + radius / 3 * cos(angle);
      y = center.dy + radius / 3 * sin(angle);
      path.lineTo(x, y);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.shape != shape;
  }
}
