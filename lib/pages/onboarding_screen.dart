import 'package:flutter/material.dart';
import 'package:flutter_resume_app/pages/bottomnav.dart';
import 'package:flutter_resume_app/star/dot_indicator.dart';
import 'package:flutter_resume_app/star/glowing_star_button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding/onboarding_contents.dart';
import '../size_config.dart';
import '../star/twinkling_stars_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  int _currentPage = 0;

  final List<List<Color>> gradientColors = const [
    [Color(0xFF010A1A), Color(0xFF092E6E), Color(0xFF254E99)],
    [Color(0xFF040B1F), Color(0xFF15356C), Color(0xFF4175C4)],
    [Color(0xFF000C1A), Color(0xFF194B88), Color(0xFF6BB1E1)],
  ];

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors[_currentPage],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const TwinklingStars_Background(child: SizedBox.expand()),
          SafeArea(
            child: OrientationBuilder(
              builder: (context, orientation) {
                SizeConfig.init(context);
                bool isLandscape = orientation == Orientation.landscape;

                return Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PageView.builder(
                        controller: _controller,
                        physics: const BouncingScrollPhysics(),
                        itemCount: contents.length,
                        onPageChanged: (value) {
                          setState(() => _currentPage = value);
                        },
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: isLandscape ? height * 0.5 : height * 0.35,
                                  child: Image.asset(
                                    contents[i].image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  contents[i].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Orbitron',
                                    fontSize: isLandscape ? 24 : 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  contents[i].desc,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Mulish-Regular',
                                    fontSize: isLandscape ? 16 : 18,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    //--------------------------------------- dot star------------------------------------------------//
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        contents.length,
                        (index) => DotIndicator(
                          isActive: _currentPage == index,
                          dotSize: 15,
                        ),
                      ),
                    ),
                    //--------------------------------------- dot star------------------------------------------------//
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: _currentPage + 1 == contents.length
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const /*HomeScreen()*/BottomNav()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellowAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      isLandscape ? width * 0.12 : width * 0.2,
                                  vertical: isLandscape ? 12 : 18,
                                ),
                              ),
                              child: Text(
                                "START",
                                style: TextStyle(
                                  fontFamily: 'Orbitron',
                                  fontSize: isLandscape ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _controller.jumpToPage(contents.length - 1);
                                  },
                                  child: Text(
                                    "SKIP",
                                    style: TextStyle(
                                      fontFamily: 'Orbitron',
                                      fontSize: isLandscape ? 14 : 16,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                //--------------------------------------- button star------------------------------------------------//
                                GlowingStarButton(
                                  onPressed: () {
                                    _controller.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  color: Colors.yellowAccent.withOpacity(0.9),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                                //--------------------------------------- button star------------------------------------------------//
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
