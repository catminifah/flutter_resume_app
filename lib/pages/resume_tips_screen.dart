import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_resume_app/colors/pastel_star_color.dart';
import 'package:flutter_resume_app/data/resume_tip_item.dart';
import 'package:flutter_resume_app/pages/resume_tip_detail_screen.dart';
import 'package:flutter_resume_app/theme/dynamic_background.dart';
import 'package:twinkling_stars/twinkling_stars.dart';

class ResumeTipsScreen extends StatefulWidget {
  const ResumeTipsScreen({Key? key}) : super(key: key);

  @override
  _ResumeTipsScreen createState() => _ResumeTipsScreen();
}

class _ResumeTipsScreen extends State<ResumeTipsScreen> {
  late ResumeTipItem tip;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 3 : 2;
    return Scaffold(
      body: DynamicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: isLandscape ? 65 :100,
                    width: isLandscape ? 380 : 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3674B5), Color(0xFF578FCA),Color(0xFFF5F0CD),Color(0xFFFADA7A),],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          TwinklingStarsBackground(
                            starCount: 120,
                            starColors: PastelStarColor.iPastelStarColor,
                            starShapes: const [
                              StarShape.diamond,
                              StarShape.fivePoint,
                              StarShape.sixPoint,
                              StarShape.sparkle3,
                              StarShape.star4,
                            ],
                            child: const SizedBox.expand(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric( horizontal: 16.0, vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        Color(0xFF6EACDA),
                                        Color(0xFFE2E2B6),
                                      ],
                                    ).createShader(Rect.fromLTWH( 0, 0, bounds.width, bounds.height)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 110),
                                      child: Text(
                                        'Pick the resume trick you want to explore',
                                        style: TextStyle(
                                          fontSize: isLandscape ? 15 :18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Orbitron',
                                          letterSpacing: 0.5,
                                          height: 1.3,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset(
                              'assets/icons_home/resume_writing_tips.png',
                              width: isLandscape ? 70 : 100,
                              height: isLandscape ? 70 : 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(30),
                    itemCount: resumeTips.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final tip = resumeTips[index];
                      return _buildCategoryCard(context, tip);
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, ResumeTipItem tip) {
    return SizedBox(
      width: 100,
      height: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResumeTipDetailScreen(tip: tip),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                tip.icon,
                size: 40,
                color: tip.iconColor,
              ),
              const SizedBox(height: 12),
              Text(
                tip.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}