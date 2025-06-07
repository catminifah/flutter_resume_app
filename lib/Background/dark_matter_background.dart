import 'package:flutter/material.dart';
import 'package:flutter_resume_app/colors/background_color_galaxy.dart';
import 'package:twinkling_stars/twinkling_stars.dart';

class DarkMatterBackground extends StatelessWidget {
  final Widget child;

  const DarkMatterBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Galaxy Blue gradient background
        //---------------------------------------- background color -------------------------------------//
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: BackgroundColorsGalaxy.iBackgroundColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        //---------------------------------------- background color -------------------------------------//
        //---------------------------------------- background star --------------------------------------//
        TwinklingStarsBackground(
          starColors: const [Colors.white],
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
