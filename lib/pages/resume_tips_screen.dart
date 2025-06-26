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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        const AssetImage('assets/images/resume_tip_1.png'),
        context,
      );
      precacheImage(
        const AssetImage('assets/images/resume_tip_2.jpg'),
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 3 : 2;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.5;
    return Scaffold(
      body: DynamicBackground(
        child: Stack(
          children: [
             Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: imageHeight,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.transparent,
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  isLandscape
                      ? 'assets/images/resume_tip_2.jpg'
                      : 'assets/images/resume_tip_1.png',
                  fit: BoxFit.cover,
                  alignment: isLandscape ? const Alignment(0, -0.8) : Alignment.topCenter,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isLandscape ? 0 : 100),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                      child: Text(
                        'Resume Tip!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                    ),
                    resumeTipPromptCard(isLandscape),
                    SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: resumeTips.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: isLandscape ? 300 : 200,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: isLandscape ? 1.3 : 1,
                        ),
                        itemBuilder: (context, index) {
                          final tip = resumeTips[index];
                          return _buildCategoryCard(context, tip);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resumeTipPromptCard(var isLandscape) {
    return Center(
      child: Container(
        height: isLandscape ? 65 : 100,
        width: isLandscape ? 380 : 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Color(0xFF3674B5).withOpacity(0.8),
              Color(0xFF578FCA).withOpacity(0.8),
              Color(0xFFF5F0CD).withOpacity(0.8),
              Color(0xFFFADA7A).withOpacity(0.8),
            ],
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Color(0xFFFBFBFB),
                            Color(0xFFE8F9FF),
                            Color(0xFFC4D9FF),
                            Color(0xFFA3D8FF),
                          ],
                        ).createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 110),
                          child: Text(
                            'Pick the resume trick you want to explore',
                            style: TextStyle(
                              fontSize: isLandscape ? 15 : 18,
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
                  'assets/icons_image/resume_writing_tips.png',
                  width: isLandscape ? 70 : 100,
                  height: isLandscape ? 70 : 100,
                  fit: BoxFit.contain,
                ),
              ),
            ],
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white,
                      Colors.transparent,
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  tip.image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: tip.iconColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tip.icon,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tip.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
