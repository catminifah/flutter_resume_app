import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_resume_app/colors/pastel_star_color.dart';
import 'package:flutter_resume_app/colors/pastel_star_color2.dart';
import 'package:flutter_resume_app/pages/onboarding_screen.dart';
import 'package:flutter_resume_app/size_config.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';
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

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _scaleController = AnimationController(vsync: this, duration: const Duration(seconds: 2));

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

    _confettiController = ConfettiController(duration: const Duration(seconds: 2));

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
      body: DynamicBackground(
        child: SafeArea(
          child: Center(
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
                                colors: PastelStarColor.iPastelStarColor,
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
                    colors: PastelStarColor2.iPastelStarColor,
                    createParticlePath: (size) => drawStar(size),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
