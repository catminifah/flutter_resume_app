import 'package:flutter/material.dart';
import 'package:flutter_resume_app/star/glowing_star.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;
  final double dotSize;

  const DotIndicator({
    super.key,
    required this.isActive,
    this.dotSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GlowingStar(
        isActive: isActive,
        size: dotSize,
      ),
    );
  }
}