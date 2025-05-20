import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/pages/onboarding_screen.dart';
import 'package:flutter_resume_app/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinkling_stars/twinkling_stars.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Color> _gradientColors = const [
    Color(0xFF010A1A),
    Color(0xFF092E6E),
    Color(0xFF254E99),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          TwinklingStarsBackground(
            starColors: const [Colors.white],
            starShapes: [StarShape.diamond,StarShape.fivePoint,StarShape.sixPoint,StarShape.sparkle3],
            child: const SizedBox.expand(),
          ),
          Center(
            child: Container(
              width: width,
              child: ClipRRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('images/logoresume.png', width: 300),
                            const SizedBox(height: 20),
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: [
                                    Color(0xFFFFE1E0),
                                    Color(0xFFF49BAB),
                                    Color(0xFF9B7EBD),
                                    Color(0xFF7F55B1),
                                  ],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcIn,
                              child: Text(
                                'Star Resume App',
                                style: TextStyle(
                                  fontSize: 30,
                                  //fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontFamily: 'SweetLollipop',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    TwinklingStarsBackground(
                      starColors: const [
                        Color(0xFFFFE1E0),
                        Color(0xFFF49BAB),
                        Color(0xFF9B7EBD),
                        Color(0xFF7F55B1),
                      ],
                      starShapes: [
                        StarShape.diamond,
                        StarShape.fivePoint,
                        StarShape.sixPoint,
                        StarShape.sparkle3,
                        StarShape.star4,
                      ],
                      child: const SizedBox.expand(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
