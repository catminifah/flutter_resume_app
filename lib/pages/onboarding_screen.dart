import 'package:flutter/material.dart';
import 'package:flutter_resume_app/pages/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_contents.dart';
import '../size_config.dart';
import '../twinkling_stars_background.dart';

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

  AnimatedContainer _buildDots({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 16 : 10,
      height: _currentPage == index ? 16 : 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.yellowAccent : Colors.white54,
        boxShadow: _currentPage == index
            ? [
                BoxShadow(
                  color: Colors.yellowAccent.withOpacity(0.6),
                  blurRadius: 6,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
    );
  }

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
                colors: gradientColors[_currentPage],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const TwinklingStarsBackground(child: SizedBox.expand()),
          SafeArea(
            child: Column(
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
                          children: [
                            Expanded(
                              child: Image.asset(contents[i].image),
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.orbitron(
                                fontSize: width * 0.08,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              contents[i].desc,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mulish(
                                fontSize: width * 0.045,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indicator Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          contents.length,
                          (index) => _buildDots(index: index),
                        ),
                      ),
                      // Buttons
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: _currentPage + 1 == contents.length
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const HomeScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellowAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  shadowColor: Colors.yellow,
                                  elevation: 10,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.2,
                                    vertical: 20,
                                  ),
                                ),
                                child: Text(
                                  "START",
                                  style: GoogleFonts.orbitron(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _controller.jumpToPage(contents.length - 1);
                                    },
                                    child: Text(
                                      "SKIP",
                                      style: GoogleFonts.orbitron(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellowAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 20,
                                      ),
                                    ),
                                    child: Text(
                                      "NEXT",
                                      style: GoogleFonts.orbitron(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
