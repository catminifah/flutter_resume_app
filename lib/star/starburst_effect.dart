import 'dart:math';
import 'package:flutter/material.dart';

class StarburstEffect extends StatefulWidget {
  final Offset position;
  final VoidCallback onCompleted;

  const StarburstEffect({
    required this.position,
    required this.onCompleted,
    super.key,
  });

  @override
  State<StarburstEffect> createState() => _StarburstEffectState();
}

class _StarburstEffectState extends State<StarburstEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onCompleted();
            }
          })
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStar(double angle, Color color) {
    final double radius = 40.0;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final double progress = _controller.value;
        final double dx = radius * progress * cos(angle);
        final double dy = radius * progress * sin(angle);
        return Positioned(
          left: widget.position.dx + dx,
          top: widget.position.dy + dy,
          child: Opacity(
            opacity: 1 - progress,
            child: Icon(
              Icons.star,
              color: color,
              size: 12 + (8 * (1 - progress)),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      const Color(0xFFFFE1E0),
      const Color(0xFFF49BAB),
      const Color(0xFF9B7EBD),
      const Color(0xFF7F55B1),
    ];
    return Stack(
      children: List.generate(8, (i) {
        final angle = (2 * pi / 8) * i;
        final color = colors[i % colors.length];
        return _buildStar(angle, color);
      }),
    );
  }
}
