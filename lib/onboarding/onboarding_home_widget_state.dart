import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_resume_app/data/onboarding_home_data.dart';
import 'package:flutter_resume_app/widgets/size_config.dart';
import 'package:flutter_resume_app/star/dot_indicator.dart';

class OnboardingWidgetState extends StatefulWidget {
  const OnboardingWidgetState({super.key});

  @override
  State<OnboardingWidgetState> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidgetState> with WidgetsBindingObserver {
  late PageController _pageController;
  int currentIndex = 0;
  Timer? _autoSlideTimer;

  List<OnboardingItem> get loopedItems {
    return [
      onboardingItems.last,
      ...onboardingItems,
      onboardingItems.first,
    ];
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    if (!mounted || !_pageController.hasClients) return;

    _autoSlideTimer?.cancel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final currentPage = (_pageController.page ?? 1).round();
        final nextPage = currentPage + 1;

        if (nextPage < loopedItems.length) {
          _pageController.jumpToPage(nextPage);
        } else {
          _pageController.jumpToPage(1);
        }
      } catch (e) {
        debugPrint("Error in didChangeMetrics: $e");
      }

      _startAutoSlide();
    });
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pageController = PageController(initialPage: 1);
    _startAutoSlide();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_pageController.hasClients) return;

      try {
        int nextPage = (_pageController.page ?? 1).round() + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        debugPrint('Slide error: $e');
      }
    });
  }

  void _onPageChanged(int index) {
    final lastIndex = onboardingItems.length;

    if (index == 0) {
      _pageController.jumpToPage(lastIndex);
    } else if (index == lastIndex + 1) {
      _pageController.jumpToPage(1);
    } else {
      setState(() {
        currentIndex = index - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final double maxWidth = isLandscape ? 600 : SizeConfig.screenW!;

    return Center(
      child: SizedBox(
        width: maxWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: loopedItems.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final item = loopedItems[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            item.imagePath,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black54, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 24,
                            left: 16,
                            right: 16,
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontFamily: 'Orbitron',
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingItems.length,
                      (index) => DotIndicator(
                        isActive: currentIndex == index,
                        dotSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
