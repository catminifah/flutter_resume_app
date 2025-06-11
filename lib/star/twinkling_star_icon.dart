import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/star/star8_painter.dart';

class TwinklingStarIcon extends StatefulWidget {
  final double size;
  final List<Color> colorPool;

  const TwinklingStarIcon({
    Key? key,
    this.size = 30,
    this.colorPool = const [Colors.pink, Colors.yellow, Colors.lightBlueAccent],
  }) : super(key: key);

  @override
  State<TwinklingStarIcon> createState() => _TwinklingStarIconState();
}

class _TwinklingStarIconState extends State<TwinklingStarIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;
  late Animation<Color?> _colorAnim;

  late AnimationController _colorController;
  late ColorTween _colorTween;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    final initialColor = widget.colorPool[_random.nextInt(widget.colorPool.length)];
    final nextColor = widget.colorPool[_random.nextInt(widget.colorPool.length)];
    _colorTween = ColorTween(begin: initialColor, end: nextColor);
    _colorAnim = _colorTween.animate(_colorController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _setNewColorTween();
          _colorController.forward(from: 0);
        }
      });

    _colorController.forward();
    _startWithDelay();
  }

  void _startWithDelay() async {
    final delay = Duration(milliseconds: _random.nextInt(1000));
    await Future.delayed(delay);
    _controller.repeat(reverse: true);
    _colorController.forward();
  }

  void _setNewColorTween() {
    final from = _colorAnim.value ?? widget.colorPool[0];
    final to = widget.colorPool[_random.nextInt(widget.colorPool.length)];
    _colorTween = ColorTween(begin: from, end: to);
    _colorAnim = _colorTween.animate(_colorController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _colorController]),
      builder: (_, __) {
        final color = _colorAnim.value ?? Colors.white;
        return Transform.rotate(
          angle: _rotation.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.7),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: CustomPaint(
                painter: Star8Painter(color: color),
              ),
            ),
          ),
        );
      },
    );
  }
}
