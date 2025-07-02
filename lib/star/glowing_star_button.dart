import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/star/star8_painter.dart';

class GlowingStarButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;
  final Color color;
  final Widget? child;

  const GlowingStarButton({
    super.key,
    required this.onPressed,
    this.size = 70,
    required this.color,
    this.child,
  });

  @override
  State<GlowingStarButton> createState() => _GlowingStarButtonState();
}

class _GlowingStarButtonState extends State<GlowingStarButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _rotation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: _rotation.value,
                child: Transform.scale(
                  scale: _scale.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow behind the star
                      Container(
                        width: widget.size + 20,
                        height: widget.size + 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              widget.color.withOpacity(0.9),
                              widget.color.withOpacity(0.02),
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                      // Star shape with child
                      CustomPaint(
                        painter: Star8Painter(color: widget.color),
                        child: SizedBox(
                          width: widget.size,
                          height: widget.size,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(child: widget.child ?? const SizedBox()),
            ],
          );
        },
      ),
    );
  }
}
