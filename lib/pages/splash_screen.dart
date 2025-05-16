import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/pages/onboarding_screen.dart';
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

  late AnimationController _twinkleController;

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

    _twinkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _twinkleController.dispose();
    super.dispose();
  }

  final List<Color> _gradientColors = const [
    Color(0xFF010A1A),
    Color(0xFF092E6E),
    Color(0xFF254E99),
  ];
  
  final List<Offset> _starPositions = const [
    Offset(-80, -80),
    Offset(100, -60),
    Offset(-100, 60),
    Offset(80, 80),
    Offset(0, -100),
    Offset(0, 100),
  ];

  @override
  Widget build(BuildContext context) {
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
            child: AnimatedBuilder(
              animation: _twinkleController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    for (final offset in _starPositions)
                      Positioned(
                        left: 150 + offset.dx,
                        top: 300 + offset.dy,
                        child: Opacity(
                          opacity: 0.6 + 0.4 * sin(_twinkleController.value * 2 * pi),
                          child: const Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('images/logoresume.png', width: 300),
                    const SizedBox(height: 20),
                    Text(
                      'Flutter Resume App',
                      style: GoogleFonts.orbitron(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
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
