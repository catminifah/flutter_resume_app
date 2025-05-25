import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/pages/onboarding_screen.dart';
import 'package:flutter_resume_app/size_config.dart';
import 'package:twinkling_stars/twinkling_stars.dart';
import 'package:confetti/confetti.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();

    _scaleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeIn),
    );

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    _scaleController.forward();
    _confettiController.play();

    Timer(const Duration(seconds: 5), () {
      _confettiController.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  final List<Color> _gradientColors = const [
    Color(0xFF010A1A),
    Color(0xFF092E6E),
    Color(0xFF254E99),
  ];

  Path drawStar(Size size) {
    const int numPoints = 5;
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius / 2.5;
    final Path path = Path();
    final double angle = pi / numPoints;

    for (int i = 0; i < 2 * numPoints; i++) {
      final double r = i.isEven ? outerRadius : innerRadius;
      final double x = size.width / 2 + r * cos(i * angle);
      final double y = size.height / 2 + r * sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double width = SizeConfig.screenW!;
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
          // Twinkling Stars
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
          Center(
            child: SizedBox(
              width: width,
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
                            child: const Text(
                              'Star Resume App',
                              style: TextStyle(
                                fontSize: 30,
                                letterSpacing: 1.5,
                                fontFamily: 'SweetLollipop',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    numberOfParticles: 20,
                    maxBlastForce: 20,
                    minBlastForce: 5,
                    emissionFrequency: 0.02,
                    gravity: 0.3,
                    colors: const [
                      Color(0xFF7BD3EA),
                      Color(0xFFA1EEBD),
                      Color(0xFFF6F7C4),
                      Color(0xFFF6D6D6),
                    ],
                    createParticlePath: (size) => drawStar(size),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
