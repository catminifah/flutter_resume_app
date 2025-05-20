import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/star/star_painter.dart';

class GlowingStar extends StatefulWidget {
  final bool isActive;
  final double size;

  const GlowingStar({super.key, required this.isActive, this.size = 24});

  @override
  State<GlowingStar> createState() => _GlowingStarState();
}

class _GlowingStarState extends State<GlowingStar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  late Color _previousColor;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.6), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);

    _previousColor = widget.isActive ? Colors.yellowAccent : Colors.white54.withOpacity(0.3);

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant GlowingStar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      //_controller.stop();
      _controller.reset();
    }

    _previousColor = oldWidget.isActive
        ? Colors.yellowAccent
        : Colors.white54.withOpacity(0.3);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final targetColor = widget.isActive
        ? Colors.yellowAccent
        : Colors.white54.withOpacity(0.3);

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: _previousColor, end: targetColor),
      duration: const Duration(milliseconds: 500),
      builder: (context, animatedColor, child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: widget.isActive ? 1.0 : 0.6,
          curve: Curves.easeInOut,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final glowOpacity = widget.isActive ? _scaleAnimation.value.clamp(0.0, 1.0) : 0.0;
              final rotation = widget.isActive ? _rotationAnimation.value : 0.0;
              final scale = widget.isActive ? _scaleAnimation.value : 1.0;

              return Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: widget.isActive
                          ? [
                              BoxShadow(
                                color: Colors.yellowAccent.withOpacity(glowOpacity),
                                blurRadius: 12,
                                spreadRadius: 4,
                              )
                            ]
                          : [],
                    ),
                    child: CustomPaint(
                      painter: StarPainter(color: animatedColor ?? targetColor),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}