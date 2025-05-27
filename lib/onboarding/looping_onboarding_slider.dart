import 'dart:async';
import 'package:flutter/material.dart';

class OnboardingItem {
  final String imagePath;
  final String title;

  OnboardingItem({required this.imagePath, required this.title});
}

class LoopingOnboardingSlider extends StatefulWidget {
  final List<OnboardingItem> items;
  final double dotSize;
  final Duration autoSlideDuration;

  const LoopingOnboardingSlider({
    super.key,
    required this.items,
    this.dotSize = 12,
    this.autoSlideDuration = const Duration(seconds: 3),
  });

  @override
  State<LoopingOnboardingSlider> createState() => _LoopingOnboardingSliderState();
}

class _LoopingOnboardingSliderState extends State<LoopingOnboardingSlider> {
  late PageController _pageController;
  late List<OnboardingItem> _loopItems;
  int _currentIndex = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loopItems = [
      widget.items.last,
      ...widget.items,
      widget.items.first,
    ];

    _pageController = PageController(initialPage: _currentIndex);

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoSlideDuration, (_) {
      if (!_pageController.hasClients) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (index == 0) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _pageController.jumpToPage(widget.items.length);
      });
    } else if (index == widget.items.length + 1) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _pageController.jumpToPage(1);
      });
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _loopItems.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final item = _loopItems[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(item.imagePath, fit: BoxFit.cover),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black87,
                                ),
                              ],
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
                  children: List.generate(widget.items.length, (i) {
                    final isActive = _currentIndex == i + 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: widget.dotSize,
                        height: widget.dotSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? Colors.white : Colors.white54,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
