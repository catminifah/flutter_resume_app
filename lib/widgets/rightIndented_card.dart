import 'package:flutter/material.dart';

class ArrowBoxCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const ArrowBoxCard({
    super.key,
    required this.child,
    this.color = Colors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArrowBoxClipper(),
      child: Container(
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: child,
      ),
    );
  }
}

class ArrowBoxClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const arrowWidth = 20.0;

    final path = Path();

    // 🔼 ซ้ายแหลมเข้า
    path.moveTo(arrowWidth, 0);
    path.lineTo(size.width - arrowWidth, 0);             // ขอบบน

    // 🔼 ขวาแหลมออก
    path.lineTo(size.width, size.height / 2);            // จุดแหลมขวา
    path.lineTo(size.width - arrowWidth, size.height);   // ล่างขวา

    // 🔼 ล่างซ้ายกลับมาด้านแหลมซ้าย
    path.lineTo(arrowWidth, size.height);
    path.lineTo(0, size.height / 2);                     // จุดแหลมซ้าย
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
