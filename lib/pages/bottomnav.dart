import 'package:flutter/material.dart';
import 'package:flutter_resume_app/colors/pastel_star_color.dart';
import 'package:flutter_resume_app/colors/pastel_star_color2.dart';
import 'package:flutter_resume_app/pages/home_screen.dart';
import 'package:flutter_resume_app/pages/resume_editor.dart';
import 'package:flutter_resume_app/pages/setting_screen.dart';
import 'package:flutter_resume_app/star/star8_painter.dart';
import 'package:twinkling_stars/twinkling_stars.dart';

import '../star/sparkle_burst.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  int currentTabIndex=0;
  late List<Widget> pages;

  late final List<GlobalKey> _itemKeys;

  final List<IconData> icons = [
    Icons.home,
    Icons.file_open_rounded,
    Icons.settings,
  ];

  final List<String> labels = ['Home', 'Create', 'Setting'];

  int _previousIndex = 0;

  final List<Color> selectedColors = const [
    Color(0xFFF7CFD8),
    Color(0xFFA6D6D6),
    Color(0xFF8E7DBE),
  ];

  final List<Color> selectediconColors = const [
    Color(0xFFB64F6A),
    Color(0xFF4F9C9C),
    Color(0xFF5A459B),
  ];

  late Widget currentPage;
  
  late HomeScreen home;
  late ResumeEditor createreume;
  late SettingScreen settingresume;

  @override
  void initState() {
    _itemKeys = List.generate(icons.length, (_) => GlobalKey());
    home=HomeScreen();
    createreume=ResumeEditor();
    settingresume=SettingScreen();
    pages=[home,createreume,settingresume];
    currentPage = home;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 100,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 60,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF010A1A),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(icons.length, (index) {
                          final isSelected = currentTabIndex == index;
                          final wasSelected = _previousIndex == index;
                          final selectedColor = selectedColors[index % selectedColors.length];
                          final selectediconColor = selectediconColors[index % selectediconColors.length];
                          final Offset offset;
                          return GestureDetector(
                            key: _itemKeys[index],
                            onTap: () {
                              final context = _itemKeys[index].currentContext;
                              if (context == null) return;
        
                              if (currentTabIndex != index) {
                                setState(() {
                                  _previousIndex = currentTabIndex;
                                  currentTabIndex = index;
                                });

                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  final renderBox = context.findRenderObject();
                                  if (renderBox is RenderBox) {
                                    final position = renderBox.localToGlobal(Offset.zero);
                                    final overlay = Overlay.of(context);
                                    late final OverlayEntry overlayEntry;
        
                                    final isSelected = currentTabIndex == index;
                                    final transformOffsetX = isSelected ? 0.0 : 90.0;
                                    final transformOffsetY = isSelected ? -35.0 : 0.0;
        
                                    overlayEntry = OverlayEntry(
                                      builder: (context) => SparkleBurstEffect(
                                        center: Offset(
                                          position.dx + renderBox.size.width / 2 + transformOffsetX,
                                          position.dy + renderBox.size.height / 2 + transformOffsetY,
                                        ),
                                        radius: 60,
                                        sparkleCount: 15,
                                        colors: PastelStarColor2.iPastelStarColor,
                                        sizes: [8, 12, 16],
                                        starShapes: [
                                          StarShapes.fivePoint,
                                          StarShapes.sixPoint,
                                          StarShapes.diamond,
                                          StarShapes.sparkle3,
                                        ],
                                        duration: Duration(milliseconds: 800),
                                        onComplete: () {
                                          overlayEntry.remove();
                                        },
                                      ),
                                    );
        
                                    overlay.insert(overlayEntry);
                                  }
                                });
                                setState(() {
                                  currentTabIndex = index;
                                });
                              }
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                if (wasSelected && currentTabIndex != index)
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 400),
                                    top: 0,
                                    curve: Curves.easeOut,
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 400),
                                      opacity: 0,
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: selectedColor.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOut,
                                  transform: Matrix4.translationValues( 0, isSelected ? -30 : 0, 0),
                                  width: 70,
                                  height: 70,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedRotation(
                                        turns: isSelected ? 1.0 : 0.0,
                                        duration: const Duration(milliseconds: 1000),
                                        curve: Curves.easeOut,
                                        child: CustomPaint(
                                          painter: Star8Painter(color: isSelected ? selectedColor : Colors.transparent,),
                                          child: SizedBox( width: 70,height: 70,),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AnimatedScale(
                                            scale: isSelected ? 1.3 : 1.0,
                                            duration: const Duration(milliseconds: 300),
                                            child: Icon(
                                              icons[index],
                                              color: isSelected ? const Color(0xFF010A1A).withOpacity(0.6) : Colors.white70,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            labels[index],
                                            style: TextStyle(
                                              color: isSelected ? const Color(0xFF010A1A).withOpacity(0.6) : Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    child: IgnorePointer(
                      child: TwinklingStarsBackground(
                        starColors: PastelStarColor.iPastelStarColor,
                        starShapes: [
                          StarShape.diamond,
                          StarShape.fivePoint,
                          StarShape.sixPoint,
                          StarShape.sparkle3,
                        ],
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: pages[currentTabIndex],
    );
  }
}