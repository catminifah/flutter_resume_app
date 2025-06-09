import 'package:flutter/material.dart';
import 'package:flutter_resume_app/colors/pastel_star_color.dart';
import 'package:flutter_resume_app/colors/pastel_star_color2.dart';
import 'package:twinkling_stars/twinkling_stars.dart';

class PastelSkyBackground extends StatelessWidget {
  final Widget child;

  const PastelSkyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Pastel Sky gradient background
        //---------------------------------------- background color -------------------------------------//
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: PastelStarColor.PastelStarColorBackground,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        //---------------------------------------- background color -------------------------------------//
        //---------------------------------------- background star --------------------------------------//
        TwinklingStarsBackground(
          starColors: PastelStarColor2.iPastelStarColor,
          starShapes: [
            StarShape.diamond,
            StarShape.fivePoint,
            StarShape.sixPoint,
            StarShape.sparkle3
          ],
          child: const SizedBox.expand(),
        ),
        //---------------------------------------- background star -------------------------------------//
        // Foreground content
        child,
      ],
    );
  }
}
